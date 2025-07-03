%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Tabela de símbolos para variáveis */
#define MAX_SYMBOLS 100
struct symbol {
    char *name;
    char *type;
    int value;
} symbols[MAX_SYMBOLS];
int sym_count = 0;

/* Pilha de escopos */
#define MAX_STACK 100
char *scope_stack[MAX_STACK];
int stack_top = -1;

/* Funções para gerenciar escopo */
void push_scope(char *scope) {
    if (stack_top < MAX_STACK - 1) {
        scope_stack[++stack_top] = strdup(scope);
    } else {
        fprintf(stderr, "Erro: Pilha de escopos cheia\n");
        exit(1);
    }
}

void pop_scope() {
    if (stack_top >= 0) {
        free(scope_stack[stack_top--]);
    }
}

char* top_scope() {
    return stack_top >= 0 ? scope_stack[stack_top] : "global";
}

/* Funções para tabela de símbolos */
int lookup_symbol(char *name, char **type) {
    for (int i = 0; i < sym_count; i++) {
        if (strcmp(symbols[i].name, name) == 0) {
            *type = symbols[i].type;
            return symbols[i].value;
        }
    }
    return -1; /* Não encontrado */
}

void set_symbol(char *name, char *type, int value) {
    for (int i = 0; i < sym_count; i++) {
        if (strcmp(symbols[i].name, name) == 0) {
            symbols[i].value = value;
            symbols[i].type = strdup(type);
            return;
        }
    }
    if (sym_count < MAX_SYMBOLS) {
        symbols[sym_count].name = strdup(name);
        symbols[sym_count].type = strdup(type);
        symbols[sym_count].value = value;
        sym_count++;
    } else {
        fprintf(stderr, "Erro: Tabela de símbolos cheia\n");
        exit(1);
    }
}

/* Verificação de compatibilidade de tipos */
int compativel(char *tipo1, char *tipo2) {
    return strcmp(tipo1, tipo2) == 0; /* Simplificação: tipos iguais são compatíveis */
}

/* Declarações do lexer */
extern int yylex();
extern int yylineno;
extern char *yytext;
extern FILE *yyin;

void yyerror(const char *s) {
    fprintf(stderr, "Erro de sintaxe: %s na linha %d perto de '%s'\n", s, yylineno, yytext);
    exit(1);
}
%}

/* Definição da união */
%union {
    int int_val;
    char *str_val;
    struct { char *text; char *type; int value; } expr_val;
}

/* Tokens do lexer */
%token <str_val> ID
%token <int_val> INT_LIT
%token PLUS_INT MINUS_INT MUL_INT DIV_INT
%token EQ SEMICOLON LPAREN RPAREN LBRACE RBRACE
%token INT FLOAT CHAR STRING
%token RETURN INICIO FIM

/* Tipos das produções */
%type <str_val> type
%type <expr_val> expr

/* Precedência dos operadores */
%left PLUS_INT MINUS_INT
%left MUL_INT DIV_INT

%%

/* Programa principal */
program : { push_scope("global"); } decl_list subprogram_list INICIO stmt_list FIM { pop_scope(); printf("Programa executado com sucesso!\n"); }
        ;

/* Declarações */
decl_list : decl_list decl
          | /* vazio */
          ;

decl : type id_list SEMICOLON { }
     ;

id_list : ID { set_symbol($1, $<str_val>0, 0); } /* Inicializa variável com valor 0 */
        | id_list COMMA ID { set_symbol($3, $<str_val>0, 0); }
        ;

/* Subprogramas */
subprogram_list : subprogram_list subprogram
                | /* vazio */
                ;

subprogram : type ID LPAREN { push_scope($2); } decl_list RPAREN LBRACE stmt_list RBRACE { pop_scope(); }
           ;

/* Comandos */
stmt_list : stmt_list stmt
          | /* vazio */
          ;

stmt : decl
     | RETURN expr SEMICOLON {
         char *sub_type = top_scope();
         if (compativel(sub_type, $2.type)) {
             printf("Retornando valor: %d\n", $2.value);
         } else {
             yyerror("Tipos incompatíveis no retorno");
         }
     }
     | ID EQ expr SEMICOLON {
         char *var_type;
         if (lookup_symbol($1, &var_type) != -1) {
             if (compativel(var_type, $3.type)) {
                 set_symbol($1, var_type, $3.value);
                 printf("Atribuído %d a %s\n", $3.value, $1);
             } else {
                 yyerror("Tipos incompatíveis na atribuição");
             }
         } else {
             yyerror("Variável não declarada");
         }
     }
     ;

/* Tipos */
type : INT    { $$ = strdup("Int"); }
     | FLOAT  { $$ = strdup("Float"); }
     | CHAR   { $$ = strdup("Char"); }
     | STRING { $$ = strdup("String"); }
     ;

/* Expressões */
expr : expr PLUS_INT expr {
         if (compativel($1.type, $3.type)) {
             $$.value = $1.value + $3.value;
             $$.text = malloc(strlen($1.text) + strlen("+") + strlen($3.text) + 1);
             sprintf($$.text, "%s+%s", $1.text, $3.text);
             $$.type = $1.type;
         } else {
             yyerror("Tipos incompatíveis na soma");
         }
     }
     | expr MINUS_INT expr {
         if (compativel($1.type, $3.type)) {
             $$.value = $1.value - $3.value;
             $$.text = malloc(strlen($1.text) + strlen("-") + strlen($3.text) + 1);
             sprintf($$.text, "%s-%s", $1.text, $3.text);
             $$.type = $1.type;
         } else {
             yyerror("Tipos incompatíveis na subtração");
         }
     }
     | expr MUL_INT expr {
         if (compativel($1.type, $3.type)) {
             $$.value = $1.value * $3.value;
             $$.text = malloc(strlen($1.text) + strlen("*") + strlen($3.text) + 1);
             sprintf($$.text, "%s*%s", $1.text, $3.text);
             $$.type = $1.type;
         } else {
             yyerror("Tipos incompatíveis na multiplicação");
         }
     }
     | expr DIV_INT expr {
         if (compativel($1.type, $3.type)) {
             if ($3.value != 0) {
                 $$.value = $1.value / $3.value;
                 $$.text = malloc(strlen($1.text) + strlen("/") + strlen($3.text) + 1);
                 sprintf($$.text, "%s/%s", $1.text, $3.text);
                 $$.type = $1.type;
             } else {
                 yyerror("Divisão por zero");
             }
         } else {
             yyerror("Tipos incompatíveis na divisão");
         }
     }
     | ID {
         char *type;
         int value = lookup_symbol($1, &type);
         if (value != -1) {
             $$.value = value;
             $$.text = strdup($1);
             $$.type = type;
         } else {
             yyerror("Variável não declarada");
         }
     }
     | INT_LIT {
         $$.value = $1;
         $$.text = malloc(20);
         sprintf($$.text, "%d", $1);
         $$.type = strdup("Int");
     }
     ;

%%

/* Função principal */
int main(int argc, char **argv) {
    printf("Iniciando o interpretador...\n");

    /* Abre o arquivo de entrada */
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Erro ao abrir o arquivo de entrada");
            return 1;
        }
    } else {
        yyin = stdin;
    }

    /* Executa o parser */
    yyparse();

    /* Fecha o arquivo */
    if (yyin != stdin) {
        fclose(yyin);
    }

    return 0;
}
