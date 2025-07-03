%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./lib/record.h"
#include "./lib/symbol_table.h"

int yylex(void);
void yyerror(const char *s);
extern int yylineno;
extern char *yytext;
extern FILE *yyin, *yyout;

static int label_count = 0;
char *new_label() {
    char buf[32];
    sprintf(buf, "L%d", label_count++);
    return strdup(buf);
}

char* cat(const char *s1, const char *s2, const char *s3, const char *s4, const char *s5);
const char* map_type(const char* o);
%}

%union {
    int int_val;
    float float_val;
    char *str_val;
    struct record *rec;
}

%token UNIT FLOAT INT PRINT RETURN IF WHILE
%token ARROW_LEFT PLUS MINUS MUL DIV
%token LT LE GT GE EQ NE
%token SEMICOLON LPAREN RPAREN LBRACE RBRACE COMMA
%token <str_val> ID
%token <int_val> INT_LIT
%token <float_val> FLOAT_LIT

%type <rec> program decl_list func_decl param_list_opt param_list param
%type <rec> stmt_list stmt var_decl_stmt assignment_stmt func_call_stmt print_stmt return_stmt if_stmt while_stmt type expr func_call arg_list_opt arg_list

%left PLUS MINUS
%left MUL DIV
%left LT LE GT GE EQ NE

%%

program:
    decl_list {
        fprintf(yyout,
            "#include <stdio.h>\n"
            "#include <stdlib.h>\n"
            "#include <stdbool.h>\n\n"
            "/* Stub de leitura */\n"
            "float read() { float v; if (scanf(\"%%f\", &v)!=1) return -1.0f; return v;}\n\n"
        );
        fprintf(yyout, "%s\n", $1->code);
        freeRecord($1);
    }
;

// lista de funções

decl_list:
      func_decl
    | decl_list func_decl {
        char *s = cat($1->code, "\n\n", $2->code, "", "");
        $$ = createRecord(s, ""); free(s);
        freeRecord($1); freeRecord($2);
    }
;

// definição de função

func_decl:
    type ID LPAREN param_list_opt RPAREN LBRACE stmt_list RBRACE {
        const char *rt = strcmp($2, "main")==0 ? "int" : map_type($1->code);
        char *h = cat(rt, " ", $2, "(", $4->code);
        char *b = cat(h, ") {\n", $7->code, "}\n", "");
        $$ = createRecord(b, ""); free(h); free(b);
        freeRecord($1); free($2); freeRecord($4); freeRecord($7);
    }
;

// parâmetros

param_list_opt:
      /* vazio */ { $$ = createRecord("", ""); }
    | param_list
;

param_list:
      param
    | param_list COMMA param {
        char *s = cat($1->code, ", ", $3->code, "", "");
        $$ = createRecord(s, ""); free(s);
        freeRecord($1); freeRecord($3);
    }
;

param:
    type ID {
        char *s = cat($1->code, " ", $2, "", "");
        $$ = createRecord(s, $1->opt1);
        free(s); freeRecord($1); free($2);
    }
;

// comandos dentro de função

stmt_list:
      /* vazio */ { $$ = createRecord("", ""); }
    | stmt_list stmt {
        char *s = cat($1->code, $2->code, "\n", "", "");
        $$ = createRecord(s, ""); free(s);
        freeRecord($1); freeRecord($2);
    }
;

stmt:
      var_decl_stmt
    | assignment_stmt
    | print_stmt
    | return_stmt
    | func_call_stmt
    | if_stmt
    | while_stmt
;

// declaração de variáveis

var_decl_stmt:
    type ID SEMICOLON {
        char *s = cat("    ", $1->code, " ", $2, ";"); /* Corrigido */
        $$ = createRecord(s, ""); free(s);
        insertSymbol($2, $1->opt1);
        freeRecord($1); free($2);
    }
  | type ID ARROW_LEFT expr SEMICOLON {
        char *p = cat("    ", $1->code, " ", $2, " = ");
        char *s = cat(p, $4->code, ";", "", "");
        $$ = createRecord(s, ""); free(p); free(s);
        insertSymbol($2, $1->opt1);
        freeRecord($1); free($2); freeRecord($4);
    }
;

// atribuição

assignment_stmt:
    ID ARROW_LEFT expr SEMICOLON {
        char *s = cat("    ", $1, " = ", $3->code, ";");
        $$ = createRecord(s, ""); free(s);
        free($1); freeRecord($3);
    }
;

// chamada de função

func_call_stmt:
    func_call SEMICOLON {
        char *s = cat("    ", $1->code, ";", "", "");
        $$ = createRecord(s, ""); free(s); freeRecord($1);
    }
;

// print

print_stmt:
    PRINT expr SEMICOLON {
        const char *fmt = strcmp($2->opt1, "Float")==0 ? "%f" : "%d";
        char *s = cat("    printf(\"", fmt, "\\n\", ", $2->code, ");");
        $$ = createRecord(s, ""); free(s); freeRecord($2);
    }
;

// return

return_stmt:
    RETURN expr SEMICOLON {
        char *s = cat("    return ", $2->code, ";", "", "");
        $$ = createRecord(s, ""); free(s); freeRecord($2);
    }
;

// if-else sem else

if_stmt:
    IF LPAREN expr RPAREN LBRACE stmt_list RBRACE {
        char *lend = new_label();
        char *cond = cat("    if (!(", $3->code, ")) goto ", lend, ";");
        char *body = $6->code;
        char *code = cat(cond, "\n", body, "\n", lend);
        code = cat(code, ":", "", "", "");
        $$ = createRecord(code, ""); free(cond); free(lend); freeRecord($3); freeRecord($6);
    }
;

// while

while_stmt:
    WHILE LPAREN expr RPAREN LBRACE stmt_list RBRACE {
        char *lbegin = new_label();
        char *lend   = new_label();
        char *start = cat(lbegin, ":\n", "", "", "");
        char *cond  = cat("    if (!(", $3->code, ")) goto ", lend, ";");
        char *body  = $6->code;
        char *back  = cat("    goto ", lbegin, ";", "", "");
        char *end   = cat(lend, ":", "", "", "");
        char *tmp   = cat(start, cond, "\n", body, "\n");
        tmp = cat(tmp, back, "\n", end, "");
        $$ = createRecord(tmp, ""); free(tmp); freeRecord($3); freeRecord($6);
    }
;

// tipos

type:
    INT { $$ = createRecord("int", "Int"); }
  | FLOAT { $$ = createRecord("float", "Float"); }
  | UNIT { $$ = createRecord("void", "Unit"); }


// expressões aritméticas e comparações

expr:
      expr PLUS expr  { char *s=cat("(", $1->code, " + ", $3->code, ")"); $$=createRecord(s,$1->opt1); free(s); freeRecord($1); freeRecord($3); }
    | expr MINUS expr { char *s=cat("(", $1->code, " - ", $3->code, ")"); $$=createRecord(s,$1->opt1); free(s); freeRecord($1); freeRecord($3); }
    | expr MUL expr   { char *s=cat("(", $1->code, " * ", $3->code, ")"); $$=createRecord(s,$1->opt1); free(s); freeRecord($1); freeRecord($3); }
    | expr DIV expr   { char *s=cat("(", $1->code, " / ", $3->code, ")"); $$=createRecord(s,$1->opt1); free(s); freeRecord($1); freeRecord($3); }
    | expr LT expr    { char *s=cat("(", $1->code, " < ",  $3->code, ")"); $$=createRecord(s,(char*)"Int"); free(s); freeRecord($1); freeRecord($3); }
    | expr LE expr    { char *s=cat("(", $1->code, " <= ", $3->code, ")"); $$=createRecord(s,(char*)"Int"); free(s); freeRecord($1); freeRecord($3); }
    | expr GT expr    { char *s=cat("(", $1->code, " > ",  $3->code, ")"); $$=createRecord(s,(char*)"Int"); free(s); freeRecord($1); freeRecord($3); }
    | expr GE expr    { char *s=cat("(", $1->code, " >= ", $3->code, ")"); $$=createRecord(s,(char*)"Int"); free(s); freeRecord($1); freeRecord($3); }
    | expr EQ expr    { char *s=cat("(", $1->code, " == ", $3->code, ")"); $$=createRecord(s,(char*)"Int"); free(s); freeRecord($1); freeRecord($3); }
    | expr NE expr    { char *s=cat("(", $1->code, " != ", $3->code, ")"); $$=createRecord(s,(char*)"Int"); free(s); freeRecord($1); freeRecord($3); }
    | LPAREN expr RPAREN { $$ = $2; }
    | ID               { const char *t = lookupSymbol($1); $$ = createRecord($1,(char*)t); free($1); }
    | INT_LIT          { char b[32]; sprintf(b,"%d",$1); $$=createRecord(strdup(b),(char*)"Int"); }
    | FLOAT_LIT        { char b[32]; sprintf(b,"%f",$1); $$=createRecord(strdup(b),(char*)"Float"); }
    | func_call        { $$ = $1; }
;

// chamada de função

func_call:
    ID LPAREN arg_list_opt RPAREN {
        char *s = cat($1, "(", $3->code, ")", ""); $$ = createRecord(s,(char*)"call"); free(s); free($1); freeRecord($3);
    }
;

arg_list_opt:
      /* empty */ { $$ = createRecord("", ""); }
    | arg_list
;

arg_list:
      expr
    | arg_list COMMA expr { char *s=cat($1->code, ", ", $3->code, "", ""); $$=createRecord(s,""); free(s); freeRecord($1); freeRecord($3); }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "ERRO DE SINTAXE: %s na linha %d perto de '%s'\n", s, yylineno, yytext);
}

char* cat(const char *s1, const char *s2, const char *s3, const char *s4, const char *s5) {
    size_t len = strlen(s1) + strlen(s2) + strlen(s3) + strlen(s4) + strlen(s5) + 1;
    char *o = malloc(len);
    if (!o) { fprintf(stderr, "Erro de malloc!\n"); exit(1); }
    sprintf(o, "%s%s%s%s%s", s1, s2, s3, s4, s5);
    return o;
}

const char* map_type(const char* o) {
    if (strcmp(o, "Int") == 0) return "int";
    if (strcmp(o, "Float") == 0) return "float";
    if (strcmp(o, "Unit") == 0) return "void";
    return "void";
}

int main(int argc, char **argv) {
    if (argc != 3) { fprintf(stderr, "Uso: %s <in> <out>\n", argv[0]); return 1; }
    yyin = fopen(argv[1], "r"); if (!yyin) { perror("fopen"); return 1; }
    yyout = fopen(argv[2], "w"); if (!yyout) { perror("fopen"); fclose(yyin); return 1; }
    initSymbolTable();
    yyparse();
    freeSymbolTable();
    fclose(yyin);
    fclose(yyout);
    return 0;
}
