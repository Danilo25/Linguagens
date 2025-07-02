%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./lib/record.h" // Incluindo a biblioteca de record


int yylex(void);
void yyerror(const char *s);
extern int yylineno;
extern char *yytext;
extern FILE *yyin, *yyout;

char *cat(const char *s1, const char *s2, const char *s3, const char *s4, const char *s5);
const char* map_type(const char* original_type);

%}


%union {
    int int_val;
    float float_val;
    char *str_val;
    struct record *rec; 
}


%token UNIT FLOAT INT PRINT RETURN
%token ARROW_LEFT SEMICOLON LPAREN RPAREN LBRACE RBRACE COMMA
%token PLUS MINUS MUL DIV


%token <str_val> ID
%token <int_val> INT_LIT
%token <float_val> FLOAT_LIT


%type <rec> program decl_list func_decl param_list_opt param_list param
%type <rec> stmt_list stmt var_decl_stmt assignment_stmt func_call_stmt 
%type <rec> print_stmt return_stmt type expr func_call arg_list_opt arg_list

%left PLUS MINUS
%left MUL DIV

%%

program: decl_list 
        {
            fprintf(yyout, "#include <stdio.h>\n\n");
            fprintf(yyout, "%s\n", $1->code);
            freeRecord($1);
            printf("Arquivo de saída gerado com sucesso!\n");
        }
        ;


decl_list: func_decl
         | decl_list func_decl 
           {
               char *s = cat($1->code, "\n\n", $2->code, "", "");
               $$ = createRecord(s, "");
               free(s);
               freeRecord($1);
               freeRecord($2);
           }
         ;

func_decl: type ID LPAREN param_list_opt RPAREN LBRACE stmt_list RBRACE
           {
               const char* c_return_type = strcmp($2, "main") == 0 ? "int" : map_type($1->code);
               
               char *s1 = cat((char*)c_return_type, " ", $2, "(", $4->code);
               char *s2 = cat(s1, ")\n{\n", $7->code, "}\n", "");
               $$ = createRecord(s2, "");
               free(s1);
               free(s2);
               freeRecord($1);
               free($2);
               freeRecord($4);
               freeRecord($7);
           }
         ;

param_list_opt: { $$ = createRecord("", ""); }
              | param_list
              ;

param_list: param
          | param_list COMMA param
            {
                char *s = cat($1->code, ", ", $3->code, "", "");
                $$ = createRecord(s, "");
                free(s);
                freeRecord($1);
                freeRecord($3);
            }
          ;

param: type ID 
       {
           char *s = cat($1->code, " ", $2, "", "");
           $$ = createRecord(s, $1->code);
           free(s);
           freeRecord($1);
           free($2);
       }
     ;


stmt_list: { $$ = createRecord("", ""); }
         | stmt_list stmt
           {
               char* s = cat($1->code, $2->code, "\n", "", "");
               $$ = createRecord(s, "");
               free(s);
               freeRecord($1);
               freeRecord($2);
           }
         ;


stmt: var_decl_stmt
    | assignment_stmt
    | print_stmt
    | return_stmt
    | func_call_stmt
    ;


var_decl_stmt: type ID SEMICOLON
               {
                   char* s = cat("\t", $1->code, " ", $2, ";");
                   $$ = createRecord(s, "");
                   free(s);
                   freeRecord($1);
                   free($2);
               }
             | type ID ARROW_LEFT expr SEMICOLON
               {
                   char* part1 = cat("\t", $1->code, " ", $2, " = ");
                   char* s = cat(part1, $4->code, ";", "", "");
                   $$ = createRecord(s, "");
                   
                   free(part1);
                   free(s);
                   freeRecord($1);
                   free($2);
                   freeRecord($4);
               }
             ;

assignment_stmt: ID ARROW_LEFT expr SEMICOLON
                 {
                     char* s = cat("\t", $1, " = ", $3->code, ";");
                     $$ = createRecord(s, "");
                     free(s);
                     free($1);
                     freeRecord($3);
                 }
               ;
               
func_call_stmt: func_call SEMICOLON 
                {
                    char* s = cat("\t", $1->code, ";", "", "");
                    $$ = createRecord(s, "");
                    free(s);
                    freeRecord($1);
                }
              ;

print_stmt: PRINT expr SEMICOLON
            {
                const char* format = strcmp($2->opt1, "Float") == 0 ? "%f" : "%d";
                char* s = cat("\tprintf(\"", format, "\\n\", ", $2->code, ");");
                $$ = createRecord(s, "");
                free(s);
                freeRecord($2);
            }
          ;

return_stmt: RETURN expr SEMICOLON
             {
                 char* s = cat("\treturn ", $2->code, ";", "", "");
                 $$ = createRecord(s, "");
                 free(s);
                 freeRecord($2);
             }
           ;

type: UNIT  { $$ = createRecord("void", "Unit"); }
    | FLOAT { $$ = createRecord("float", "Float"); }
    | INT   { $$ = createRecord("int", "Int"); }
    ;

expr: expr PLUS expr  { char* s = cat("(", $1->code, " + ", $3->code, ")"); $$ = createRecord(s, $1->opt1); free(s); freeRecord($1); freeRecord($3); }
    | expr MINUS expr { char* s = cat("(", $1->code, " - ", $3->code, ")"); $$ = createRecord(s, $1->opt1); free(s); freeRecord($1); freeRecord($3); }
    | expr MUL expr   { char* s = cat("(", $1->code, " * ", $3->code, ")"); $$ = createRecord(s, $1->opt1); free(s); freeRecord($1); freeRecord($3); }
    | expr DIV expr   { char* s = cat("(", $1->code, " / ", $3->code, ")"); $$ = createRecord(s, $1->opt1); free(s); freeRecord($1); freeRecord($3); }
    | LPAREN expr RPAREN { $$ = $2; }
    | ID          { $$ = createRecord($1, "ID"); free($1); }
    | INT_LIT     { char buf[32]; sprintf(buf, "%d", $1); $$ = createRecord(strdup(buf), "Int"); }
    | FLOAT_LIT   { char buf[32]; sprintf(buf, "%f", $1); $$ = createRecord(strdup(buf), "Float"); }
    | func_call
    ;

func_call: ID LPAREN arg_list_opt RPAREN
           {
               char* s = cat($1, "(", $3->code, ")", "");
               $$ = createRecord(s, "call");
               free(s);
               free($1);
               freeRecord($3);
           }
         ;

arg_list_opt: { $$ = createRecord("", ""); }
            | arg_list
            ;

arg_list: expr
        | arg_list COMMA expr
          {
              char *s = cat($1->code, ", ", $3->code, "", "");
              $$ = createRecord(s, "");
              free(s);
              freeRecord($1);
              freeRecord($3);
          }
        ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "ERRO DE SINTAXE: %s na linha %d perto de '%s'\n", s, yylineno, yytext);
}

char* cat(const char *s1, const char *s2, const char *s3, const char *s4, const char *s5) {
    size_t len = strlen(s1) + strlen(s2) + strlen(s3) + strlen(s4) + strlen(s5) + 1;
    char *output = (char *) malloc(len);
    if (!output) {
        fprintf(stderr, "Erro de alocação de memória!\n");
        exit(1);
    }
    sprintf(output, "%s%s%s%s%s", s1, s2, s3, s4, s5);
    return output;
}

const char* map_type(const char* original_type) {
    if (strcmp(original_type, "Int") == 0) return "int";
    if (strcmp(original_type, "Float") == 0) return "float";
    if (strcmp(original_type, "Unit") == 0) return "void";
    return "void";
}

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(stderr, "Uso: %s <arquivo-de-entrada> <arquivo-de-saida>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Não foi possível abrir o arquivo de entrada");
        return 1;
    }

    yyout = fopen(argv[2], "w");
    if (!yyout) {
        perror("Não foi possível abrir o arquivo de saída");
        fclose(yyin);
        return 1;
    }

    printf("Iniciando compilação...\n");
    yyparse();

    fclose(yyin);
    fclose(yyout);

    return 0;
}
