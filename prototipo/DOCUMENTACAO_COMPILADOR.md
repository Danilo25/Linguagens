# Documentação do Compilador

## 1. Introdução - Visão Geral do Projeto

### 1.1 Descrição do Projeto
Este projeto implementa um compilador completo para uma linguagem de programação funcional que suporta tipos de dados especializados. O compilador é desenvolvido utilizando as ferramentas Flex (para análise léxica) e Bison/Yacc (para análise sintática), gerando código C como saída.

### 1.2 Características da Linguagem
A linguagem compilada possui as seguintes características:
- **Tipos de dados especializados**: Rational (números racionais), Matrix (matrizes), BST (árvores de busca binária)
- **Tipos básicos**: Int, Float, Unit (void)
- **Operador de atribuição único**: `<-` (seta esquerda)
- **Estruturas de controle**: if, while
- **Passagem por referência**: usando a palavra-chave `ref`
- **Funções**: declaração e chamada com suporte a múltiplos tipos
- **Comentários**: suporte a comentários de linha (`//`)

### 1.3 Arquitetura do Compilador
O compilador é estruturado em duas fases principais:
1. **Análise Léxica** (`scanner.l`): Converte o código fonte em tokens
2. **Análise Sintática** (`parser.y`): Processa os tokens e gera código C

### 1.4 Estrutura do Projeto
```
prototipo/
├── scanner.l              # Analisador léxico
├── parser.y               # Analisador sintático  
├── makefile               # Automação de compilação
├── compiler.exe           # Compilador executável
├── lib/                   # Bibliotecas auxiliares
│   ├── symbol_table.h/c   # Tabela de símbolos
│   ├── record.h/c         # Estruturas de dados
│   ├── rational.h/c       # Operações com racionais
│   ├── matrix.h/c         # Operações com matrizes
│   └── bst.h/c           # Árvores de busca binária
└── tests/                 # Arquivos de teste
```

## 2. Design da Implementação

### 2.1 Transformação do Código-Fonte em Unidades Léxicas

#### 2.1.1 Analisador Léxico (scanner.l)
O analisador léxico utiliza Flex para definir padrões de reconhecimento:

**Tokens de Tipos:**
- `Unit`, `Float`, `Int`, `Rational`, `Matrix`, `BST`, `ref`

**Tokens de Controle:**
- `print`, `return`, `if`, `while`

**Operadores:**
- Comparação: `<=`, `>=`, `==`, `!=`, `<`, `>`
- Aritméticos: `+`, `-`, `*`, `/`
- Especiais: `<-` (atribuição), `&` (endereço)

**Delimitadores:**
- `;`, `,`, `(`, `)`, `{`, `}`

**Literais:**
```flex
[0-9]+\.[0-9]+          { yylval.float_val = atof(yytext); return FLOAT_LIT; }
[0-9]+                  { yylval.int_val = atoi(yytext); return INT_LIT; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str_val = strdup(yytext); return ID; }
```

**Tratamento de Espaços e Comentários:**
```flex
[ \t\r\n]+              { /* ignora espaços */ }
"//".* { /* ignora comentários de linha */ }
```

**Tratamento de Erros:**
```flex
.  { fprintf(stderr, "ERRO LÉXICO: '%s' na linha %d\n", yytext, yylineno); exit(1); }
```

#### 2.1.2 Integração com o Parser
O scanner utiliza a união semântica definida no parser:
```c
%union {
    int int_val;
    float float_val;  
    char *str_val;
    struct record *rec;
}
```

### 2.2 Representação de Símbolos, Tabela de Símbolos e Funções Associadas

#### 2.2.1 Estrutura da Tabela de Símbolos
A tabela de símbolos é implementada como uma lista ligada simples:

```c
typedef struct Sym {
    char *name;    // Nome do símbolo
    char *type;    // Tipo do símbolo
    struct Sym *next;  // Próximo símbolo
} Sym;
```

#### 2.2.2 Funções da Tabela de Símbolos

**Inicialização:**
```c
void initSymbolTable(void);
```
Inicializa a tabela como vazia.

**Inserção:**
```c
void insertSymbol(const char *name, const char *type);
```
Insere um novo símbolo na tabela com seu tipo.

**Busca:**
```c
const char *lookupSymbol(const char *name);
```
Busca um símbolo na tabela e retorna seu tipo. Retorna "Int" como padrão se não encontrado.

**Liberação:**
```c
void freeSymbolTable(void);
```
Libera toda a memória alocada para a tabela.

#### 2.2.3 Mapeamento de Tipos
O compilador mapeia tipos da linguagem para tipos C:

```c
char* map_type(const char *type) {
    if (strcmp(type, "Int") == 0) return "int";
    if (strcmp(type, "Float") == 0) return "float";
    if (strcmp(type, "Unit") == 0) return "void";
    if (strcmp(type, "Rational") == 0) return "rational_t";
    if (strcmp(type, "Matrix") == 0) return "matrix_t*";
    if (strcmp(type, "BST") == 0) return "TreeNode*";
    return "int"; // padrão
}
```

### 2.3 Tratamento de Estruturas Condicionais e de Repetição

#### 2.3.1 Estrutura Condicional (if)
**Gramática:**
```yacc
if_stmt: IF LPAREN expr RPAREN LBRACE stmt_list RBRACE
```

**Geração de Código:**
```c
if_stmt: IF LPAREN expr RPAREN LBRACE stmt_list RBRACE {
    char *end_label = new_label();
    $$ = createRecord(cat("if (!(", $3->code, ")) goto ", end_label, ";\n"),
                     cat($6->code, end_label, ":\n", NULL, NULL));
}
```

**Código C Gerado:**
```c
if (!(condição)) goto L1;
// comandos do if
L1:
```

#### 2.3.2 Estrutura de Repetição (while)
**Gramática:**
```yacc
while_stmt: WHILE LPAREN expr RPAREN LBRACE stmt_list RBRACE
```

**Geração de Código:**
```c
while_stmt: WHILE LPAREN expr RPAREN LBRACE stmt_list RBRACE {
    char *start_label = new_label();
    char *end_label = new_label();
    $$ = createRecord(cat(start_label, ":\nif (!(", $3->code, ")) goto ", end_label),
                     cat(";\n", $6->code, "goto ", start_label, ";\n"));
}
```

**Código C Gerado:**
```c
L1:
if (!(condição)) goto L2;
// comandos do while
goto L1;
L2:
```

#### 2.3.3 Geração de Labels
```c
static int label_count = 0;
char *new_label() {
    char buf[32];
    sprintf(buf, "L%d", label_count++);
    return strdup(buf);
}
```

### 2.4 Tratamento de Subprogramas

#### 2.4.1 Declaração de Funções
**Gramática:**
```yacc
func_decl: type ID LPAREN param_list_opt RPAREN LBRACE stmt_list RBRACE
         | type ID LPAREN param_list_opt RPAREN SEMICOLON
```

**Geração de Código:**
```c
func_decl: type ID LPAREN param_list_opt RPAREN LBRACE stmt_list RBRACE {
    char *func_header = cat(map_type($1), " ", $2, "(", $4 ? $4->code : "");
    char *func_body = cat(func_header, ") {\n", $7->code, "}\n\n");
    $$ = createRecord(func_body, $1);
}
```

#### 2.4.2 Parâmetros de Função
**Gramática:**
```yacc
param: type ID
     | REF type ID
```

**Tratamento de Referências:**
```c
param: REF type ID {
    char *param_code = cat(map_type($2), "* ", $3, NULL, NULL);
    $$ = createRecord(param_code, $2);
}
```

#### 2.4.3 Chamadas de Função
**Gramática:**
```yacc
func_call: ID LPAREN arg_list_opt RPAREN
```

**Reconhecimento de Funções Especiais:**
O compilador reconhece funções específicas para cada tipo:
- **Rational**: `create_rational`, `add`, `subtract`, `multiply`, `divide`
- **Matrix**: `create_matrix`, `add_matrices`, `multiply_matrices`
- **BST**: `create_bst_from_sequence`, `get_min_value`, `get_max_value`

### 2.5 Verificações Realizadas

#### 2.5.1 Verificação de Tipos
- **Mapeamento automático**: Tipos da linguagem são automaticamente mapeados para tipos C
- **Verificação de compatibilidade**: Operações são verificadas conforme o tipo
- **Funções tipadas**: Chamadas de função retornam tipos específicos

#### 2.5.2 Verificação de Declarações
- **Tabela de símbolos**: Mantém registro de todas as variáveis declaradas
- **Busca de símbolos**: Verifica se variáveis foram declaradas antes do uso
- **Inserção de símbolos**: Registra novas declarações na tabela

#### 2.5.3 Verificação Léxica
- **Caracteres inválidos**: Detecta e reporta caracteres não reconhecidos
- **Formato de números**: Valida formato de literais numéricos
- **Identificadores**: Verifica formato válido de identificadores

#### 2.5.4 Verificação Sintática
- **Estrutura de programa**: Valida estrutura geral do programa
- **Balanceamento**: Verifica balanceamento de parênteses e chaves
- **Comandos**: Valida sintaxe de comandos e expressões

#### 2.5.5 Tratamento de Erros
**Erros Léxicos:**
```c
{ fprintf(stderr, "ERRO LÉXICO: '%s' na linha %d\n", yytext, yylineno); exit(1); }
```

**Erros Sintáticos:**
```c
void yyerror(const char *s) {
    fprintf(stderr, "ERRO SINTÁTICO: %s próximo a '%s' na linha %d\n", 
            s, yytext, yylineno);
}
```

## 3. Instruções de Uso do Compilador

### 3.1 Requisitos do Sistema
- **Sistema Operacional**: Windows/Linux/macOS
- **Compilador C**: GCC ou equivalente
- **Flex**: Gerador de analisadores léxicos
- **Bison/Yacc**: Gerador de analisadores sintáticos
- **Make**: Para automatização da compilação

### 3.2 Compilação do Compilador

#### 3.2.1 Usando Makefile
```bash
make
```
Este comando executa:
1. `bison -d parser.y` - Gera parser.tab.c e parser.tab.h
2. `flex scanner.l` - Gera lex.yy.c
3. `gcc -o compiler.exe parser.tab.c lex.yy.c lib/*.c` - Compila o executável

#### 3.2.2 Compilação Manual
```bash
# Gerar parser
bison -d parser.y

# Gerar scanner
flex scanner.l

# Compilar todas as bibliotecas
gcc -c lib/symbol_table.c -o lib/symbol_table.o
gcc -c lib/record.c -o lib/record.o
gcc -c lib/rational.c -o lib/rational.o
gcc -c lib/matrix.c -o lib/matrix.o
gcc -c lib/bst.c -o lib/bst.o

# Compilar o compilador
gcc -o compiler.exe parser.tab.c lex.yy.c lib/*.o
```

### 3.3 Uso do Compilador

#### 3.3.1 Sintaxe de Comando
```bash
./compiler.exe <arquivo_entrada> <arquivo_saida>
```

**Parâmetros:**
- `arquivo_entrada`: Arquivo fonte na linguagem definida (.txt)
- `arquivo_saida`: Arquivo C gerado (.c)

#### 3.3.2 Exemplo de Uso
```bash
# Compilar programa
./compiler.exe programa.txt saida.c

# Compilar o código C gerado
gcc saida.c -o programa_final

# Executar programa final
./programa_final
```

### 3.4 Sintaxe da Linguagem

#### 3.4.1 Estrutura Básica
```
Int main() {
    // declarações e comandos
    return 0;
}
```

#### 3.4.2 Declaração de Variáveis
```
Int x;              // Declaração simples
Float y <- 3.14;    // Declaração com inicialização
```

#### 3.4.3 Atribuição
```
x <- 42;            // Atribuição usando <-
```

#### 3.4.4 Estruturas de Controle
```
if (x > 0) {
    print x;
}

while (x > 0) {
    x <- x - 1;
}
```

#### 3.4.5 Funções
```
Int soma(Int a, Int b) {
    return a + b;
}

// Função com parâmetro por referência
Unit incrementa(ref Int x) {
    x <- x + 1;
}
```

#### 3.4.6 Tipos Especiais
```
// Rational
Rational r <- create_rational(3, 4);
print r;

// Matrix
Matrix m <- create_matrix(2, 2);
print m;

// BST
BST arvore <- create_bst_from_sequence(5);
print arvore;
```

### 3.5 Exemplos Completos

#### 3.5.1 Programa Simples
**Entrada (programa.txt):**
```
Int main() {
    Int x <- 10;
    print x;
    return 0;
}
```

**Saída (saida.c):**
```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "lib/rational.h"
#include "lib/matrix.h"
#include "lib/bst.h"

float read() { float v; if (scanf("%f", &v)!=1) return -1.0f; return v;}

int main() {
    int x = 10;
    printf("%d\n", x);
    return 0;
}
```

#### 3.5.2 Programa com Estruturas de Controle
**Entrada:**
```
Int main() {
    Int i <- 1;
    while (i <= 5) {
        print i;
        i <- i + 1;
    }
    return 0;
}
```

**Saída:**
```c
int main() {
    int i = 1;
L1:
if (!(i <= 5)) goto L2;
    printf("%d\n", i);
    i = i + 1;
goto L1;
L2:
    return 0;
}
```

### 3.6 Tratamento de Erros

#### 3.6.1 Erros Comuns
1. **Erro Léxico**: Caractere não reconhecido
2. **Erro Sintático**: Estrutura inválida
3. **Arquivo não encontrado**: Arquivo de entrada inexistente

#### 3.6.2 Mensagens de Erro
```
ERRO LÉXICO: '@' na linha 3
ERRO SINTÁTICO: syntax error próximo a 'if' na linha 5
```

### 3.7 Arquivos de Teste
O projeto inclui arquivos de teste na pasta `tests/`:
- `problema1/`: Testes básicos
- `problema2/`: Testes com estruturas de controle
- `problema3/`: Testes com funções
- `problema4/`: Testes com tipos especiais
- `problema5/`: Testes com referências
- `problema6/`: Testes complexos

#### 3.7.1 Executar Testes
```bash
# Executar todos os testes
./run_tests.sh

# Executar teste específico
./compiler.exe tests/problema1/entrada.txt tests/problema1/saida.c
gcc tests/problema1/saida.c -o tests/problema1/teste
./tests/problema1/teste
```

## 4. Conclusão

Este compilador implementa uma linguagem funcional completa com tipos especializados, demonstrando:
- Análise léxica robusta com tratamento de erros
- Análise sintática com geração de código C
- Gerenciamento de tabela de símbolos
- Suporte a estruturas de controle com labels
- Tratamento de subprogramas e passagem por referência
- Verificações de tipos e declarações

A arquitetura modular permite extensões futuras e manutenção facilitada, enquanto a geração de código C garante portabilidade e eficiência.
