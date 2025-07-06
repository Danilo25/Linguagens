# Avaliação Técnica do Compilador - Principais Aspectos

## 1. Estrutura Sintática

### 1.1 Introdução e Detecção de Erros Léxicos e Sintáticos

#### A) Detecção de Erros Léxicos
**Implementação no `scanner.l`:**
```flex
.  { fprintf(stderr, "ERRO LÉXICO: '%s' na linha %d\n", yytext, yylineno); exit(1); }
```

**Funcionalidades:**
- ✅ Detecção de caracteres inválidos
- ✅ Rastreamento de linha com `yylineno`
- ✅ Mensagens de erro descritivas
- ✅ Terminação controlada com `exit(1)`

**Exemplo de Erro Léxico:**
```
Entrada: Int x @ 5;
Saída: ERRO LÉXICO: '@' na linha 1
```

#### B) Detecção de Erros Sintáticos
**Implementação no `parser.y`:**
```c
void yyerror(const char *s) {
    fprintf(stderr, "ERRO DE SINTAXE: %s na linha %d perto de '%s'\n", s, yylineno, yytext);
}
```

**Funcionalidades:**
- ✅ Mensagens de erro com contexto
- ✅ Localização precisa (linha e token)
- ✅ Recuperação de erro integrada do Bison
- ✅ Informações detalhadas sobre o erro

**Exemplo de Erro Sintático:**
```
Entrada: Int x <- ;
Saída: ERRO DE SINTAXE: syntax error na linha 1 perto de ';'
```

### 1.2 Derivação das Regras Sintáticas

#### A) Estrutura do Programa
```yacc
program: decl_list
decl_list: func_decl | decl_list func_decl
func_decl: type ID LPAREN param_list_opt RPAREN LBRACE stmt_list RBRACE
         | type ID LPAREN param_list_opt RPAREN SEMICOLON
```

**Derivação Exemplo:**
```
program → decl_list → func_decl → Int main () { stmt_list }
```

#### B) Comandos e Expressões
```yacc
stmt: var_decl_stmt | assignment_stmt | print_stmt | return_stmt | func_call_stmt | if_stmt | while_stmt
expr: expr PLUS expr | expr MINUS expr | expr MUL expr | expr DIV expr | ID | INT_LIT | FLOAT_LIT | func_call
```

**Árvore de Derivação para `x <- y + 3`:**
```
assignment_stmt → lvalue ARROW_LEFT expr SEMICOLON
                → ID ARROW_LEFT expr SEMICOLON
                → x ARROW_LEFT expr SEMICOLON
                → x ARROW_LEFT expr PLUS expr SEMICOLON
                → x ARROW_LEFT ID PLUS INT_LIT SEMICOLON
                → x ARROW_LEFT y PLUS 3 SEMICOLON
```

### 1.3 Tratamento de Conflitos Shift-Reduce

#### A) Precedência de Operadores
```yacc
%left PLUS MINUS
%left MUL DIV
%left LT LE GT GE EQ NE
```

**Conflitos Resolvidos:**
- ✅ Operadores aritméticos: `*` e `/` têm precedência sobre `+` e `-`
- ✅ Operadores de comparação: mesma precedência, associatividade à esquerda
- ✅ Parênteses: maior precedência via regra `LPAREN expr RPAREN`

#### B) Makefile com Detecção de Conflitos
```makefile
$(Y_C) $(Y_HDR): $(Y_SRC)
    $(BISON) -d -o $(Y_C) $(Y_SRC) -Werror=conflicts-sr -Werror=conflicts-rr
```

**Funcionalidades:**
- ✅ Detecção automática de conflitos shift-reduce
- ✅ Detecção automática de conflitos reduce-reduce
- ✅ Compilação falha se houver conflitos não resolvidos
- ✅ Arquivo `parser.output` gerado para análise

#### C) Exemplo de Resolução de Conflito
**Entrada problemática:**
```
x <- y + z * w
```

**Resolução:**
1. Scanner: `x` `<-` `y` `+` `z` `*` `w`
2. Parser: Precedência resolve como `x <- (y + (z * w))`
3. Ação: Shift `*` em vez de reduce `y + z`

## 2. Variáveis

### 2.1 Variáveis Omitidas - Detecção de Erros

#### A) Implementação da Tabela de Símbolos
```c
const char *lookupSymbol(const char *name) {
    for (Sym *s = symbols; s; s = s->next) {
        if (strcmp(s->name, name) == 0) {
            return s->type;
        }
    }
    return "Int"; // Retorna tipo padrão - LIMITAÇÃO ATUAL
}
```

**Status Atual:**
- ⚠️ **LIMITAÇÃO IDENTIFICADA**: Não detecta variáveis não declaradas
- ⚠️ Retorna "Int" como padrão em vez de erro
- ✅ Tabela de símbolos funcional
- ✅ Inserção e busca implementadas

#### B) Melhoria Necessária
```c
const char *lookupSymbol(const char *name) {
    for (Sym *s = symbols; s; s = s->next) {
        if (strcmp(s->name, name) == 0) {
            return s->type;
        }
    }
    fprintf(stderr, "ERRO: Variável '%s' não declarada na linha %d\n", name, yylineno);
    exit(1);
}
```

### 2.2 Variáveis Duplicadas no Mesmo Escopo

#### A) Status Atual
```c
void insertSymbol(const char *name, const char *type) {
    Sym *s = malloc(sizeof *s);
    s->name = strdup(name);
    s->type = strdup(type);
    s->next = symbols;
    symbols = s;
}
```

**Limitações:**
- ⚠️ **LIMITAÇÃO IDENTIFICADA**: Não verifica duplicação
- ⚠️ Permite inserção de símbolos duplicados
- ✅ Inserção funciona corretamente

#### B) Melhoria Necessária
```c
void insertSymbol(const char *name, const char *type) {
    // Verifica se já existe
    for (Sym *s = symbols; s; s = s->next) {
        if (strcmp(s->name, name) == 0) {
            fprintf(stderr, "ERRO: Variável '%s' já declarada na linha %d\n", name, yylineno);
            exit(1);
        }
    }
    // Insere novo símbolo
    Sym *s = malloc(sizeof *s);
    s->name = strdup(name);
    s->type = strdup(type);
    s->next = symbols;
    symbols = s;
}
```

### 2.3 Variáveis em Escopos Distintos

#### A) Limitação Atual
- ⚠️ **LIMITAÇÃO IDENTIFICADA**: Compilador não implementa escopos aninhados
- ⚠️ Tabela de símbolos é global
- ⚠️ Não há stack de escopos

#### B) Implementação Necessária para Escopos
```c
typedef struct ScopeStack {
    Sym *symbols;
    struct ScopeStack *outer;
} ScopeStack;

static ScopeStack *current_scope = NULL;

void pushScope() {
    ScopeStack *new_scope = malloc(sizeof(ScopeStack));
    new_scope->symbols = NULL;
    new_scope->outer = current_scope;
    current_scope = new_scope;
}

void popScope() {
    if (current_scope) {
        ScopeStack *old_scope = current_scope;
        current_scope = current_scope->outer;
        // Liberar símbolos do escopo
        // ... código de liberação
        free(old_scope);
    }
}
```

## 3. Expressões

### 3.1 Coerções e Compatibilização de Tipos

#### A) Mapeamento de Tipos Implementado
```c
const char* map_type(const char* o) {
    if (strcmp(o, "Int") == 0) return "int";
    if (strcmp(o, "Float") == 0) return "float";
    if (strcmp(o, "Unit") == 0) return "void";
    if (strcmp(o, "Rational") == 0) return "rational_t";
    if (strcmp(o, "Matrix") == 0) return "matrix_t*";
    if (strcmp(o, "BST") == 0) return "TreeNode*";
    return "void";
}
```

**Funcionalidades:**
- ✅ Mapeamento correto de tipos
- ✅ Tipos especializados suportados
- ✅ Geração de código C apropriado

#### B) Limitações na Verificação de Tipos
```yacc
expr: expr PLUS expr { 
    char *s=cat("(", $1->code, " + ", $3->code, ")"); 
    $$=createRecord(s,$1->opt1); // Usa tipo do operando esquerdo
    free(s); freeRecord($1); freeRecord($3); 
}
```

**Status Atual:**
- ⚠️ **LIMITAÇÃO IDENTIFICADA**: Não verifica compatibilidade de tipos
- ⚠️ Assume tipo do operando esquerdo
- ⚠️ Não implementa coerção automática

#### C) Melhoria Necessária
```c
char* checkTypeCompatibility(const char* type1, const char* type2, const char* op) {
    if (strcmp(type1, type2) == 0) {
        return strdup(type1); // Tipos iguais
    }
    
    // Coerção Int -> Float
    if ((strcmp(type1, "Int") == 0 && strcmp(type2, "Float") == 0) ||
        (strcmp(type1, "Float") == 0 && strcmp(type2, "Int") == 0)) {
        return strdup("Float");
    }
    
    // Tipos incompatíveis
    fprintf(stderr, "ERRO: Tipos incompatíveis %s e %s para operação %s\n", 
            type1, type2, op);
    exit(1);
}
```

### 3.2 Mistura de Tipos Incompatíveis

#### A) Exemplo de Detecção Necessária
```
Int x <- 5;
Matrix m <- create_matrix(2, 2);
Int result <- x + m;  // ERRO: tipos incompatíveis
```

**Implementação Necessária:**
```c
// Na regra expr PLUS expr
if (!areTypesCompatible($1->opt1, $3->opt1, "+")) {
    yyerror("Tipos incompatíveis na operação");
    YYERROR;
}
```

## 4. Passagem de Parâmetros

### 4.1 Transmissão Correta de Parâmetros

#### A) Passagem por Valor (Implementado)
```yacc
param: type ID {
    char *s = cat($1->code, " ", $2, "", "");
    $$ = createRecord(s, $1->opt1);
    free(s); freeRecord($1); free($2);
}
```

**Funcionalidades:**
- ✅ Passagem por valor implementada
- ✅ Tipos corretos gerados
- ✅ Código C válido

#### B) Passagem por Referência (Implementado)
```yacc
param: REF type ID {
    const char* c_type = map_type($2->code);
    char* ptr_type = cat(c_type, "*", "", "", "");
    char* param_decl = cat(ptr_type, " ", $3, "", "");
    char* lang_type = cat("ref", $2->opt1, "", "", "");
    $$ = createRecord(param_decl, lang_type);
    free(ptr_type); free(param_decl); free(lang_type);
    freeRecord($2); free($3);
}
```

**Funcionalidades:**
- ✅ Passagem por referência implementada
- ✅ Conversão para ponteiros em C
- ✅ Sintaxe `ref` reconhecida

### 4.2 Operadores de Referência

#### A) Operador de Endereço (Implementado)
```yacc
expr: AMPERSAND ID {
    char* addr_expr = cat("&", $2, "", "", "");
    const char* base_type = lookupSymbol($2);
    char* ptr_type_name = cat("ref", base_type, "", "", "");
    $$ = createRecord(addr_expr, ptr_type_name);
    free(addr_expr); free(ptr_type_name); free($2);
}
```

#### B) Operador de Desreferenciamento (Implementado)
```yacc
lvalue: MUL ID {
    char* deref_code = cat("*", $2, "", "", "");
    const char* ptr_type = lookupSymbol($2);
    char* base_type = strdup(ptr_type ? ptr_type + 3 : "Unknown");
    $$ = createRecord(deref_code, base_type);
    free(deref_code); free(base_type); free($2);
}
```

**Funcionalidades:**
- ✅ Operador `&` para endereço
- ✅ Operador `*` para desreferenciamento
- ✅ Tipos de ponteiro rastreados

## 5. Testes de Validação

### 5.1 Casos de Teste Implementados

#### A) Erro Léxico
```
// Arquivo: teste_erro_lexico.txt
Int x @ 5;
```

#### B) Erro Sintático
```
// Arquivo: teste_erro_sintatico.txt
Int x <- ;
```

#### C) Passagem por Referência
```
// Arquivo: teste_referencia.txt
Unit incrementa(ref Int x) {
    x <- x + 1;
}

Unit main() {
    Int a <- 5;
    incrementa(&a);
    print a;  // Deve imprimir 6
}
```

### 5.2 Limitações Identificadas

#### A) Verificação de Tipos
- ⚠️ Não verifica compatibilidade de tipos em operações
- ⚠️ Não implementa coerção automática
- ⚠️ Não detecta mistura de tipos incompatíveis

#### B) Verificação de Variáveis
- ⚠️ Não detecta variáveis não declaradas
- ⚠️ Não detecta declarações duplicadas
- ⚠️ Não implementa escopos aninhados

#### C) Análise de Fluxo
- ⚠️ Não verifica caminhos de retorno
- ⚠️ Não detecta código inacessível
- ⚠️ Não verifica inicialização de variáveis

## 6. Conclusão e Recomendações

### 6.1 Aspectos Funcionais
- ✅ Estrutura sintática robusta
- ✅ Geração de código C funcional
- ✅ Tratamento de erros léxicos e sintáticos
- ✅ Passagem por referência implementada
- ✅ Tipos especializados suportados

### 6.2 Melhorias Necessárias
1. **Implementar verificação de variáveis não declaradas**
2. **Adicionar detecção de declarações duplicadas**
3. **Implementar verificação de compatibilidade de tipos**
4. **Adicionar suporte a escopos aninhados**
5. **Melhorar mensagens de erro**

### 6.3 Prioridades para Avaliação
1. **Alta**: Detecção de variáveis não declaradas
2. **Alta**: Verificação de tipos em expressões
3. **Média**: Detecção de duplicações
4. **Baixa**: Escopos aninhados (não essencial para funcionalidade básica)

O compilador está funcional e atende aos principais requisitos, mas algumas verificações semânticas avançadas precisam ser implementadas para uma avaliação completa.
