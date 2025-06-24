%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yylineno;
extern char *yytext;
extern FILE *yyin;

void yyerror(const char *s) {
    fprintf(stderr, "SYNTAX ERROR: %s at line %d near '%s'\n", s, yylineno, yytext);
}
%}

%union {
    int int_val;
    float float_val;
    char char_val;
    char *str_val;
}

%token IF ELSE FOR SWITCH WHILE RETURN DO
%token PRINT SCAN
%token UNIT BOOL INT FLOAT CHAR STRING
%token STRUCTURE SUM
%token MUT
%token BREAK CASE
%token SKIP STOP PLUSPLUS MINUSMINUS
%token PLUS_INT MINUS_INT MUL_INT DIV_INT MOD_INT
%token PLUS_FLOAT MINUS_FLOAT MUL_FLOAT DIV_FLOAT
%token AND OR NOT
%token EQQ NEQ LE GE LSHIFT RSHIFT LT GT EQ ARROW_LEFT ARROW_RIGHT
%token SEMICOLON COMMA LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET

%token <str_val> ID
%token <int_val> INT_LIT
%token <float_val> FLOAT_LIT
%token <char_val> CHAR_LIT
%token <str_val> STRING_LIT

%type <str_val> type

%left OR
%left AND
%left EQQ NEQ
%left LT GT LE GE
%left LSHIFT RSHIFT
%left PLUS_INT MINUS_INT
%left MUL_INT DIV_INT MOD_INT
%left PLUS_FLOAT MINUS_FLOAT
%left MUL_FLOAT DIV_FLOAT
%right NOT
%nonassoc PLUSPLUS MINUSMINUS
%nonassoc EQ ARROW_LEFT

%%

program : decl_list { printf("Parsing completed successfully!\n"); }
        | /* empty */ { printf("Parsing completed successfully (empty program)!\n"); }
        ;

decl_list : decl_list decl
          | decl
          ;

decl : var_decl
     | func_decl
     | struct_decl
     | sum_decl
     ;

var_decl : type ID SEMICOLON
         | type ID EQ expr SEMICOLON
         | type ID ARROW_LEFT expr SEMICOLON
         | MUT type ID SEMICOLON
         | MUT type ID EQ expr SEMICOLON
         | MUT type ID ARROW_LEFT expr SEMICOLON
         ;

type : UNIT         { $$ = strdup("Unit"); }
     | BOOL         { $$ = strdup("Bool"); }
     | INT          { $$ = strdup("Int"); }
     | FLOAT        { $$ = strdup("Float"); }
     | CHAR         { $$ = strdup("Char"); }
     | STRING       { $$ = strdup("String"); }
     | ID           { $$ = strdup($1); }
     ;

func_decl : type ID LPAREN param_list RPAREN LBRACE stmt_list RBRACE
          ;

param_list : param_list COMMA type ID
           | type ID
           | /* empty */
           ;

struct_decl : STRUCTURE ID LBRACE field_list RBRACE
            ;

field_list : field_list COMMA type ID
           | type ID
           | /* empty */
           ;

sum_decl : SUM ID LBRACE variant_list RBRACE
         ;

variant_list : variant_list COMMA ID
             | ID
             | /* empty */
             ;

stmt_list : stmt_list stmt
          | /* empty */
          ;

stmt : var_decl
     | expr SEMICOLON
     | IF LPAREN expr RPAREN LBRACE stmt_list RBRACE
     | IF LPAREN expr RPAREN LBRACE stmt_list RBRACE ELSE LBRACE stmt_list RBRACE
     | WHILE LPAREN expr RPAREN LBRACE stmt_list RBRACE
     | FOR LPAREN var_decl expr SEMICOLON expr RPAREN LBRACE stmt_list RBRACE
     | DO LBRACE stmt_list RBRACE WHILE LPAREN expr RPAREN SEMICOLON
     | SWITCH LPAREN expr RPAREN LBRACE case_list RBRACE
     | RETURN expr SEMICOLON
     | RETURN SEMICOLON
     | BREAK SEMICOLON
     | SKIP SEMICOLON
     | STOP SEMICOLON
     | PRINT expr SEMICOLON
     | SCAN ID SEMICOLON
     ;

case_list : case_list CASE expr LBRACE stmt_list RBRACE
          | CASE expr LBRACE stmt_list RBRACE
          ;

expr : expr PLUS_INT expr
     | expr MINUS_INT expr
     | expr MUL_INT expr
     | expr DIV_INT expr
     | expr MOD_INT expr
     | expr PLUS_FLOAT expr
     | expr MINUS_FLOAT expr
     | expr MUL_FLOAT expr
     | expr DIV_FLOAT expr
     | expr AND expr
     | expr OR expr
     | NOT expr
     | expr EQQ expr
     | expr NEQ expr
     | expr LT expr
     | expr GT expr
     | expr LE expr
     | expr GE expr
     | expr LSHIFT expr
     | expr RSHIFT expr
     | ID PLUSPLUS
     | ID MINUSMINUS
     | ID EQ expr
     | ID ARROW_LEFT expr
     | ID LPAREN arg_list RPAREN
     | ID LBRACKET expr RBRACKET
     | ID
     | INT_LIT
     | FLOAT_LIT
     | CHAR_LIT
     | STRING_LIT
     | LPAREN expr RPAREN
     ;

arg_list : arg_list COMMA expr
         | expr
         | /* empty */
         ;

%%

int main(int argc, char **argv) {
    printf("Iniciando análise sintática...\n");
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Could not open input file");
            return 1;
        }
    }
    yyparse();
    if (yyin != stdin) fclose(yyin);
    return 0;
}
