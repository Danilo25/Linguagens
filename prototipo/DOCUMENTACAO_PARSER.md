# Documentação do Parser (parser.y)

## Visão Geral

Este documento descreve o analisador sintático (parser) implementado em Yacc/Bison para uma linguagem de programação funcional que suporta tipos de dados especializados como números racionais, matrizes e árvores de busca binária (BST).

## Estrutura do Arquivo

### Cabeçalho e Inclusões

```c
%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}
```

O parser utiliza as seguintes bibliotecas auxiliares, todas localizadas no diretório `/lib`:

- `lib/record.h`: Estruturas e funções para gerenciamento de registros intermediários.
- `lib/symbol_table.h`: Implementação da tabela de símbolos para armazenamento de variáveis e tipos.
- `lib/rational.h`: Operações e tipos para manipulação de números racionais.
- `lib/matrix.h`: Funções para criação e manipulação de matrizes.
- `lib/bst.h`: Estruturas e operações para árvores de busca binária (BST).


### Funções Auxiliares

#### `new_label()`
Gera labels únicos para controle de fluxo (if, while):
```c
char *new_label() {
    char buf[32];
    sprintf(buf, "L%d", label_count++);
    return strdup(buf);
}
```

#### `cat()`
Concatena até 5 strings:
```c
char* cat(const char *s1, const char *s2, const char *s3, const char *s4, const char *s5)
```

#### `map_type()`
Mapeia tipos da linguagem para tipos em C:
- `Int` → `int`
- `Float` → `float`
- `Unit` → `void`
- `Rational` → `rational_t`
- `Matrix` → `matrix_t*`
- `BST` → `TreeNode*`

## Tokens e Tipos

### Tokens Básicos
- **Tipos**: `UNIT`, `FLOAT`, `INT`, `RATIONAL`, `MATRIX`, `BST`
- **Palavras-chave**: `PRINT`, `RETURN`, `IF`, `WHILE`, `REF`
- **Operadores**: `ARROW_LEFT` (←), `PLUS`, `MINUS`, `MUL`, `DIV`
- **Comparadores**: `LT`, `LE`, `GT`, `GE`, `EQ`, `NE`
- **Delimitadores**: `SEMICOLON`, `LPAREN`, `RPAREN`, `LBRACE`, `RBRACE`, `COMMA`
- **Especiais**: `AMPERSAND` (&), `REF`

### União Semântica
```c
%union {
    int int_val;
    float float_val;
    char *str_val;
    struct record *rec;
}
```

## Gramática da Linguagem

### Estrutura do Programa

#### `program`
```
program: decl_list
```
Gera o cabeçalho C com includes necessários e as declarações.

#### `decl_list`
```
decl_list: func_decl
         | decl_list func_decl
```
Lista de declarações de funções.

#### `func_decl`
```
func_decl: type ID LPAREN param_list_opt RPAREN LBRACE stmt_list RBRACE
         | type ID LPAREN param_list_opt RPAREN SEMICOLON
```
Declaração de função com implementação ou apenas protótipo.

### Parâmetros

#### `param_list_opt` e `param_list`
```
param_list_opt: /* vazio */ | param_list
param_list: param | param_list COMMA param
```

#### `param`
```
param: type ID
     | REF type ID
```
Parâmetros normais ou por referência (usando `REF`).

### Comandos (Statements)

#### `stmt_list` e `stmt`
```
stmt: var_decl_stmt
    | assignment_stmt
    | print_stmt
    | return_stmt
    | func_call_stmt
    | if_stmt
    | while_stmt
```

#### Declaração de Variáveis
```
var_decl_stmt: type ID SEMICOLON
             | type ID ARROW_LEFT expr SEMICOLON
```
Declaração com ou sem inicialização usando `←`.

#### Atribuição
```
assignment_stmt: lvalue ARROW_LEFT expr SEMICOLON
```
Atribuição usando o operador `←`.

#### Comando Print
```
print_stmt: PRINT expr SEMICOLON
```
Suporta impressão de diferentes tipos:
- `Float`: `printf("%f\n", ...)`
- `Int`: `printf("%d\n", ...)`
- `Rational`: `print_rational(...)`
- `Matrix`: `print_matrix(...)`
- `BST`: `print_bst_by_level(...)`

#### Comando Return
```
return_stmt: RETURN expr SEMICOLON
```

#### Estruturas de Controle

##### If Statement
```
if_stmt: IF LPAREN expr RPAREN LBRACE stmt_list RBRACE
```
Implementado usando labels e gotos em C.

##### While Statement
```
while_stmt: WHILE LPAREN expr RPAREN LBRACE stmt_list RBRACE
```
Implementado com labels para início e fim do loop.

### Expressões

#### Operadores Aritméticos
- `+`, `-`, `*`, `/`

#### Operadores de Comparação
- `<`, `<=`, `>`, `>=`, `==`, `!=`

#### Operadores Especiais
- `&ID`: Operador de endereço (address-of)
- `*ID`: Operador de desreferenciamento

#### Literais
- `INT_LIT`: Literais inteiros
- `FLOAT_LIT`: Literais de ponto flutuante
- `ID`: Identificadores de variáveis

### L-Values
```
lvalue: ID
      | MUL ID
```
Suporta variáveis normais e desreferenciamento de ponteiros.

### Chamadas de Função
```
func_call: ID LPAREN arg_list_opt RPAREN
```

#### Funções Reconhecidas e seus Tipos de Retorno

##### Funções de Rational
- `create_rational`, `add`, `subtract`, `multiply`, `divide`, `negate`, `inverse` → `Rational`
- `are_equal` → `Int`

##### Funções de Matrix
- `create_matrix`, `add_matrices`, `multiply_matrices` → `Matrix`

##### Funções de BST
- `create_bst_from_sequence` → `BST`
- `get_min_value`, `get_min_level`, `get_max_value`, `get_max_level` → `Int`

## Precedência de Operadores

```
%left PLUS MINUS
%left MUL DIV
%left LT LE GT GE EQ NE
```

## Geração de Código

### Cabeçalho Gerado
O parser gera automaticamente um cabeçalho C com:
```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "lib/rational.h"
#include "lib/matrix.h"
#include "lib/bst.h"

float read() { float v; if (scanf("%f", &v)!=1) return -1.0f; return v;}
```

### Tratamento de Referências
O parser suporta passagem por referência usando a palavra-chave `REF`:
- `REF type ID` é traduzido para `type* ID` em C
- Expressões `&ID` geram código `&ID` em C
- Expressões `*ID` geram código `*ID` em C

## Exemplo de Uso

### Código de Entrada
```
Int main() {
    Rational r <- create_rational(3, 4);
    print r;
    return 0;
}
```

### Código C Gerado
```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "lib/rational.h"
#include "lib/matrix.h"
#include "lib/bst.h"

float read() { float v; if (scanf("%f", &v)!=1) return -1.0f; return v;}

int main() {
    rational_t r = create_rational(3, 4);
    print_rational(r);
    return 0;
}
```

## Gerenciamento de Memória

O parser utiliza:
- `createRecord()`: Cria registros com código e tipo
- `freeRecord()`: Libera memória dos registros
- `strdup()`: Duplica strings quando necessário
- Liberação adequada de strings temporárias com `free()`

## Tabela de Símbolos

- `initSymbolTable()`: Inicializa a tabela de símbolos
- `insertSymbol()`: Insere símbolos na tabela
- `lookupSymbol()`: Busca símbolos na tabela
- `freeSymbolTable()`: Libera a tabela de símbolos

## Compilação e Execução

O programa principal:
1. Aceita dois argumentos: arquivo de entrada e arquivo de saída
2. Abre os arquivos
3. Inicializa a tabela de símbolos
4. Executa o parser (`yyparse()`)
5. Libera recursos
6. Fecha arquivos

### Uso
```bash
./parser entrada.txt saida.c
```

## Tratamento de Erros

A função `yyerror()` reporta erros de sintaxe com:
- Linha do erro
- Texto próximo ao erro
- Mensagem descritiva
