%{
#include <stdio.h>
#include <stdlib.h>

#define YYDEBUG 1
int yydebug = 1;

void yyerror(const char *s);
int yylex();
extern FILE *yyin;
%}

%union {
    int ival;
    float fval;
    char* sval;
}

/* Tokens from the scanner */
%token IF ELSE FOR SWITCH WHILE RETURN BREAK CONTINUE CASE
%token UNIT BOOL INT FLOAT STRUCTURE SUM CHAR UNSIGNED CONST STRING
%token ID
%token INT_LIT FLOAT_LIT STRING_LIT CHAR_LIT
%token EQ NE LE GE LT GT
%token ARROW_LEFT ARROW_RIGHT
%token INCREMENT DECREMENT
%token PLUS MINUS MUL DIV MOD DOT
%token AND OR NOT
%token SEMICOLON COMMA LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET
%token AMP PIPE CARET TILDE QUESTION COLON
%token UNKNOWN

/*
 * Operator Precedence is now handled by the grammar structure itself.
 * We still need to define associativity for the binary operators to resolve
 * ambiguity in sequences like a + b + c.
 */
%left PLUS MINUS
%left MUL DIV MOD

%start programa

%%

/* Grammar Rules */
programa
    : declaracoes
    ;

declaracoes
    : declaracoes declaracao
    | declaracao
    ;

declaracao
    : tipo ID LPAREN parametros RPAREN bloco
    | tipo ID SEMICOLON
    ;

tipo
    : INT | FLOAT | CHAR | STRING | STRUCTURE | SUM | UNIT | BOOL
    ;

parametros
    : /* vazio */
    | parametro_lista
    ;

parametro_lista
    : parametro
    | parametro_lista COMMA parametro
    ;

parametro
    : tipo ID
    ;

bloco
    : LBRACE comandos RBRACE
    ;

comandos
    : /* vazio */
    | comandos comando
    ;

comando
    : expressao SEMICOLON
    | RETURN expressao SEMICOLON
    | IF LPAREN expressao RPAREN bloco
    | IF LPAREN expressao RPAREN bloco ELSE bloco
    | WHILE LPAREN expressao RPAREN bloco
    | FOR LPAREN expressao SEMICOLON expressao SEMICOLON expressao RPAREN bloco
    | BREAK SEMICOLON
    | CONTINUE SEMICOLON
    | bloco
    | tipo ID ARROW_LEFT expressao SEMICOLON
    ;


/* CONFLICT-FREE EXPRESSION GRAMMAR */
expressao
    : assignment_expression
    ;

assignment_expression
    : ID ARROW_LEFT assignment_expression
    | binary_expression
    ;

binary_expression
    : binary_expression PLUS binary_expression
    | binary_expression MINUS binary_expression
    | binary_expression MUL binary_expression
    | binary_expression DIV binary_expression
    | binary_expression MOD binary_expression
    | primary_expression
    ;

primary_expression
    : ID
    | INT_LIT
    | FLOAT_LIT
    | CHAR_LIT
    | STRING_LIT
    | ID LPAREN arg_list_opt RPAREN
    | LPAREN expressao RPAREN
    ;

arg_list_opt
    : /* vazio */
    | arg_list
    ;

arg_list
    : expressao
    | arg_list COMMA expressao
    ;

%%

/* C code section remains the same */
void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s arquivo.txt\n", argv[0]);
        return 1;
    }

    FILE *arquivo = fopen(argv[1], "r");
    if (!arquivo) {
        perror("Erro ao abrir o arquivo");
        return 1;
    }

    yyin = arquivo;
    printf("Iniciando análise sintática...\n");
    int result = yyparse();
    if (result == 0) {
        printf("Análise concluída com sucesso!\n");
    } else {
        printf("Erro durante análise sintática.\n");
    }

    fclose(arquivo);
    return 0;
}
