%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./lib/tabela_simbolos.h" 

extern int yylex();
extern int yylineno;
extern char *yytext;
extern FILE *yyin;

void yyerror(const char *s);
%}

%union {
    int int_val;
    float float_val;
    char *str_val;
}

%token UNIT FLOAT INT PRINT RETURN
%token ARROW_LEFT SEMICOLON LPAREN RPAREN LBRACE RBRACE COMMA
%token PLUS MINUS MUL DIV

%token <str_val> ID
%token <int_val> INT_LIT
%token <float_val> FLOAT_LIT

%type <str_val> type

%left PLUS MINUS
%left MUL DIV

%%

program: decl_list 
        { 
            printf("Análise sintática e semântica concluídas com sucesso!\n"); 
        }
        ;

decl_list: func_decl
         | decl_list func_decl
         ;

func_decl: type ID LPAREN { enter_scope(); } param_list_opt RPAREN LBRACE stmt_list RBRACE { exit_scope(); }
         ;


param_list_opt: /* Vazio */
              | param_list
              ;

param_list: param
          | param_list COMMA param
          ;

param: type ID 
       { 
           // Agora 'add_symbol' é chamado dentro do escopo correto.
           add_symbol($2, $1, yylineno); 
           free($1);
           free($2);
       }
     ;

stmt_list: /* Vazio */
         | stmt_list stmt
         ;

stmt: var_decl_stmt
    | assignment_stmt
    | print_stmt
    | return_stmt
    | func_call_stmt
    ;

var_decl_stmt: type ID SEMICOLON
               { 
                   add_symbol($2, $1, yylineno);
                   free($1);
                   free($2);
               }
             | type ID ARROW_LEFT expr SEMICOLON
               {
                   add_symbol($2, $1, yylineno);
                   free($1);
                   free($2);
               }
             ;

assignment_stmt: ID ARROW_LEFT expr SEMICOLON
                 {
                     if (find_symbol($1) == NULL) {
                         fprintf(stderr, "Erro Semântico (linha %d): Variável '%s' não foi declarada.\n", yylineno, $1);
                     }
                     free($1);
                 }
               ;
               
func_call_stmt: func_call SEMICOLON;

print_stmt: PRINT expr SEMICOLON;

return_stmt: RETURN expr SEMICOLON;

type: UNIT  { $$ = strdup("Unit"); }
    | FLOAT { $$ = strdup("Float"); }
    | INT   { $$ = strdup("Int"); }
    ;

expr: expr PLUS expr
    | expr MINUS expr
    | expr MUL expr
    | expr DIV expr
    | LPAREN expr RPAREN
    | ID 
      {
          if (find_symbol($1) == NULL) {
              fprintf(stderr, "Erro Semântico (linha %d): Variável '%s' não foi declarada.\n", yylineno, $1);
          }
          free($1);
      }
    | FLOAT_LIT
    | INT_LIT
    | func_call
    ;

func_call: ID LPAREN arg_list_opt RPAREN;

arg_list_opt: /* Vazio */
            | arg_list
            ;

arg_list: expr
        | arg_list COMMA expr
        ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "ERRO DE SINTAXE: %s na linha %d perto de '%s'\n", s, yylineno, yytext);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Não foi possível abrir o arquivo de entrada");
            return 1;
        }
    } else {
        printf("Usando entrada padrão (stdin)...\n");
        yyin = stdin;
    }
    
    init_table();

    printf("Iniciando análise...\n");
    yyparse();
    
    free_table(); 
    
    if (yyin && yyin != stdin) {
        fclose(yyin);
    }
    return 0;
}
