%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
void yyerror(const char *s);
%}

%token IF ELSE FOR SWITCH WHILE RETURN PRINTF SCANF
%token UNIT BOOL INT FLOAT STRUCTURE SUM CHAR UNSIGNED CONST STRING
%token BREAK CONTINUE CASE
%token EQ NE LE GE LT GT AND OR NOT
%token SEMICOLON COMMA LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET ARROWR AMP PIPE CARET TILDE QUESTION COLON
%token ID FLOAT_LIT INT_LIT STRING_LIT CHAR_LIT
%token PLUS MINUS TIMES DIVIDE
%token ASSIGN_OP 

%nonassoc THEN_STMT


%right ASSIGN_OP

%left OR
%left AND
%right NOT

%left EQ NE
%left LE GE LT GT

%left PLUS MINUS
%left TIMES DIVIDE

%% 
program:
    /* empty */
    | program statement
    ;

statement:
    declaration SEMICOLON { printf(" --> Declaration OK\n"); }
    | if_statement { printf(" --> IF statement OK\n"); }
    | loop_statement { printf(" --> Loop statement OK\n"); }
    | assign_statement SEMICOLON { printf(" --> Assignment OK\n"); }
    | print_statement SEMICOLON { printf(" --> Print OK\n"); }
    | scan_statement SEMICOLON { printf(" --> Scan OK\n"); }
    | return_statement SEMICOLON { printf(" --> Return OK\n"); }
    | break_statement SEMICOLON { printf(" --> Break OK\n"); }
    | continue_statement SEMICOLON { printf(" --> Continue OK\n"); }
    | block { printf(" --> Block OK\n"); }
    ;

declaration:
    type ID 
    | CONST type ID
    ;

type:
    INT
    | FLOAT
    | CHAR
    | BOOL
    | UNSIGNED
    | STRING
    | UNIT
    | STRUCTURE
    | SUM
    ;

if_statement:
    IF LPAREN expression RPAREN statement %prec THEN_STMT 
    | IF LPAREN expression RPAREN statement ELSE statement
    ;

loop_statement:
    FOR LPAREN for_init SEMICOLON expression SEMICOLON for_update RPAREN statement
    | WHILE LPAREN expression RPAREN statement
    ;

for_init:
    /* empty */ 
    | declaration
    | assign_statement
    ;

for_update:
    /* empty */ 
    | assign_statement
    | expression 
    ;

assign_statement:
    ID ASSIGN_OP expression
    ;

print_statement:
    PRINTF LPAREN expression RPAREN
    ;

scan_statement:
    SCANF LPAREN ID RPAREN
    ;

return_statement:
    RETURN expression
    ;

break_statement:
    BREAK
    ;

continue_statement:
    CONTINUE
    ;

block:
    LBRACE program RBRACE
    ;

expression:
    ID
    | INT_LIT
    | FLOAT_LIT
    | CHAR_LIT
    | STRING_LIT
    | LPAREN expression RPAREN
    | expression PLUS expression      
    | expression MINUS expression     
    | expression TIMES expression     
    | expression DIVIDE expression   
    | ID ASSIGN_OP expression         
    | expression EQ expression
    | expression NE expression
    | expression LE expression
    | expression GE expression
    | expression LT expression
    | expression GT expression
    | expression AND expression
    | expression OR expression
    | NOT expression
    ;

%%
void yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
    exit(1);
}

int main(int argc, char **argv) {
    yyparse();
    printf("Parsing completed successfully!\n");
    return 0;
}