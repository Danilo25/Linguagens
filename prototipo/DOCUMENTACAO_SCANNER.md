# Documentação do Scanner Léxico (scanner.l)

## Visão Geral

Este documento descreve o analisador léxico (scanner) implementado em Flex para a linguagem de programação funcional. O scanner é responsável por converter o código fonte em tokens que serão processados pelo parser (`parser.y`).

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

O scanner inclui:
- `parser.tab.h`: Arquivo gerado pelo Yacc/Bison contendo as definições dos tokens
- Bibliotecas padrão C para I/O, alocação de memória e manipulação de strings

### Opções do Flex

```flex
%option noyywrap
%option yylineno
```

- `noyywrap`: Elimina a necessidade da função `yywrap()`, simplificando o código
- `yylineno`: Ativa o rastreamento automático do número da linha atual

## Tokens Reconhecidos

### 1. Tipos de Dados

| Palavra-chave | Token Retornado | Descrição |
|---------------|-----------------|-----------|
| `Unit` | `UNIT` | Tipo vazio (equivalente a void) |
| `Float` | `FLOAT` | Tipo ponto flutuante |
| `Int` | `INT` | Tipo inteiro |
| `Rational` | `RATIONAL` | Tipo número racional |
| `Matrix` | `MATRIX` | Tipo matriz |
| `BST` | `BST` | Tipo árvore de busca binária |
| `ref` | `REF` | Modificador para passagem por referência |

### 2. Palavras-chave de Controle

| Palavra-chave | Token Retornado | Descrição |
|---------------|-----------------|-----------|
| `print` | `PRINT` | Comando de impressão |
| `return` | `RETURN` | Comando de retorno |
| `if` | `IF` | Estrutura condicional |
| `while` | `WHILE` | Estrutura de repetição |

### 3. Operadores de Comparação

| Operador | Token Retornado | Descrição |
|----------|-----------------|-----------|
| `<=` | `LE` | Menor ou igual |
| `>=` | `GE` | Maior ou igual |
| `==` | `EQ` | Igual |
| `!=` | `NE` | Diferente |
| `<` | `LT` | Menor que |
| `>` | `GT` | Maior que |

### 4. Operadores Aritméticos e Especiais

| Operador | Token Retornado | Descrição |
|----------|-----------------|-----------|
| `<-` | `ARROW_LEFT` | Operador de atribuição |
| `&` | `AMPERSAND` | Operador de endereço |
| `+` | `PLUS` | Adição |
| `-` | `MINUS` | Subtração |
| `*` | `MUL` | Multiplicação |
| `/` | `DIV` | Divisão |

### 5. Delimitadores

| Símbolo | Token Retornado | Descrição |
|---------|-----------------|-----------|
| `;` | `SEMICOLON` | Fim de comando |
| `,` | `COMMA` | Separador de parâmetros |
| `(` | `LPAREN` | Parêntese esquerdo |
| `)` | `RPAREN` | Parêntese direito |
| `{` | `LBRACE` | Chave esquerda |
| `}` | `RBRACE` | Chave direita |

## Expressões Regulares e Literais

### Literais Numéricos

#### Números de Ponto Flutuante
```flex
[0-9]+\.[0-9]+  { yylval.float_val = atof(yytext); return FLOAT_LIT; }
```
- **Padrão**: Um ou mais dígitos, seguidos de ponto, seguidos de um ou mais dígitos
- **Exemplos**: `3.14`, `0.5`, `123.456`
- **Ação**: Converte o texto para `float` usando `atof()` e armazena em `yylval.float_val`

#### Números Inteiros
```flex
[0-9]+          { yylval.int_val   = atoi(yytext); return INT_LIT; }
```
- **Padrão**: Um ou mais dígitos
- **Exemplos**: `42`, `0`, `1234`
- **Ação**: Converte o texto para `int` usando `atoi()` e armazena em `yylval.int_val`

### Identificadores
```flex
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str_val = strdup(yytext); return ID; }
```
- **Padrão**: Letra ou underscore, seguido de zero ou mais letras, dígitos ou underscores
- **Exemplos**: `variavel`, `_temp`, `func123`, `MAX_VALUE`
- **Ação**: Duplica a string usando `strdup()` e armazena em `yylval.str_val`

## Tratamento de Espaços em Branco e Comentários

### Espaços em Branco
```flex
[ \t\r\n]+      { }
```
- **Padrão**: Um ou mais espaços, tabs, carriage returns ou quebras de linha
- **Ação**: Ignora (ação vazia)

### Comentários de Linha
```flex
"//".* { }
```
- **Padrão**: `//` seguido de qualquer caractere até o fim da linha
- **Exemplos**: `// Este é um comentário`, `// TODO: implementar`
- **Ação**: Ignora (ação vazia)

## Tratamento de Erros

### Caracteres Não Reconhecidos
```flex
.               { fprintf(stderr, "ERRO LÉXICO: '%s' na linha %d\n", yytext, yylineno); exit(1); }
```
- **Padrão**: Qualquer caractere não reconhecido pelas regras anteriores
- **Ação**: 
  - Imprime mensagem de erro com o caractere inválido e número da linha
  - Termina a execução do programa com `exit(1)`

## Integração com o Parser

### Valores Semânticos
O scanner utiliza a união `yylval` definida no parser para passar valores:

```c
// No parser.y
%union {
    int int_val;
    float float_val;
    char *str_val;
    struct record *rec;
}
```

### Correspondência de Tokens
- Literais inteiros → `yylval.int_val`
- Literais de ponto flutuante → `yylval.float_val`
- Identificadores → `yylval.str_val` (string duplicada)

## Características Especiais

### 1. Operador de Atribuição Único
A linguagem usa `<-` como operador de atribuição, diferente do `=` tradicional:
```
x <- 42;        // Atribuição
y <- x + 10;    // Expressão com atribuição
```

### 2. Rastreamento de Linha
Com `%option yylineno`, o scanner mantém automaticamente a variável `yylineno` atualizada, permitindo reportar erros com números de linha precisos.

### 3. Gerenciamento de Memória
- `strdup()` é usado para identificadores, criando cópias das strings
- O parser é responsável por liberar essa memória posteriormente

## Exemplos de Tokenização

### Código de Entrada
```
Int main() {
    Float x <- 3.14;
    print x;
    return 0;
}
```

### Sequência de Tokens Gerada
1. `INT` ("Int")
2. `ID` ("main")
3. `LPAREN` ("(")
4. `RPAREN` (")")
5. `LBRACE` ("{")
6. `FLOAT` ("Float")
7. `ID` ("x")
8. `ARROW_LEFT` ("<-")
9. `FLOAT_LIT` (3.14)
10. `SEMICOLON` (";")
11. `PRINT` ("print")
12. `ID` ("x")
13. `SEMICOLON` (";")
14. `RETURN` ("return")
15. `INT_LIT` (0)
16. `SEMICOLON` (";")
17. `RBRACE` ("}")

## Tratamento de Casos Especiais

### Números Decimais
- `3.14` → `FLOAT_LIT` (correto)
- `3.` → `INT_LIT` (3) seguido de erro léxico (`.`)
- `.14` → Erro léxico (`.`) seguido de `INT_LIT` (14)

### Identificadores vs. Palavras-chave
O scanner reconhece palavras-chave antes de identificadores:
- `print` → `PRINT` (palavra-chave)
- `printf` → `ID` (identificador)
- `Int` → `INT` (palavra-chave, case-sensitive)
- `int` → `ID` (identificador)

## Compilação e Uso

### Geração do Scanner
```bash
flex scanner.l
```
Gera o arquivo `lex.yy.c` contendo o código C do scanner.

### Integração com o Parser
```bash
bison -d parser.y    # Gera parser.tab.c e parser.tab.h
flex scanner.l       # Gera lex.yy.c
gcc -o compiler parser.tab.c lex.yy.c lib/*.c
```

## Limitações e Considerações

### 1. Case Sensitivity
A linguagem é case-sensitive:
- `Int` é um tipo
- `int` seria um identificador

### 2. Comentários
- Suporta apenas comentários de linha (`//`)
- Não suporta comentários de bloco (`/* */`)

### 3. Strings Literais
- Não há suporte para strings literais na linguagem
- Apenas números e identificadores são reconhecidos

### 4. Caracteres de Escape
- Não há tratamento especial para caracteres de escape
- Caracteres especiais devem ser evitados
