#ifndef TABELA_SIMBOLOS_H
#define TABELA_SIMBOLOS_H

// Estrutura para representar um símbolo, variavel, função, etc
typedef struct Symbol {
    char *name;
    char *type;
    int scope;
    int line;
    struct Symbol *next;
} Symbol;

// Inicia um novo escopo
void enter_scope();

// Finaliza o escopo atual
void exit_scope();

// Adiciona um novo símbolo na tabela no escopo atual.
// Retorna 1 se teve sucesso, 0 se o símbolo já existe no escopo.
int add_symbol(const char *name, const char *type, int line);

// Procura por um símbolo em todos os escopos, do atual para o global.
// Retorna o símbolo se encontrado, NULL caso contrário.
Symbol* find_symbol(const char *name);

// Inicializa a tabela. Deve ser chamada no início do programa.
void init_table();

// Libera toda a memória alocada pela tabela.
void free_table();

#endif