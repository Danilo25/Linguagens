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

%token IF ELSE FOR SWITCH WHILE RETURN BREAK CONTINUE CASE
%token PRINTF SCANF
%token UNIT BOOL INT FLOAT STRUCTURE SUM CHAR UNSIGNED CONST STRING
%token ID
%token INT_LIT FLOAT_LIT STRING_LIT CHAR_LIT
%token EQ NE LE GE LT GT ASSIGN ARROW_LEFT ARROW_RIGHT
%token PLUS_ASSIGN MINUS_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN
%token INCREMENT DECREMENT
%token PLUS MINUS MUL DIV MOD DOT
%token AND OR NOT
%token SEMICOLON COMMA LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET
%token AMP PIPE CARET TILDE QUESTION COLON

%start programa

%left PLUS MINUS
%left MUL DIV MOD
%right ASSIGN

%%

// Regras sintáticas da linguagem
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
    : INT
    | FLOAT
    | CHAR
    | STRING
    | STRUCTURE
    | SUM
    | UNIT
    | BOOL
    ;

parametros
    : parametro
    | parametros COMMA parametro
    | /* vazio */
    ;

parametro
    : tipo ID
    ;

bloco
    : LBRACE comandos_opt RBRACE
    ;

comandos_opt
    : comandos
    | /* vazio */
    ;

comandos
    : comandos comando
    | comando
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
    ;

expressao
    : ID ASSIGN expressao
    | expressao PLUS expressao
    | expressao MINUS expressao
    | expressao MUL expressao
    | expressao DIV expressao
    | expressao MOD expressao
    | LPAREN expressao RPAREN
    | ID
    | INT_LIT
    | FLOAT_LIT
    | CHAR_LIT
    | STRING_LIT
    ;

%%

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
