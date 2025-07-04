// symbol_table.c
#include "symbol_table.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

static Sym *symbols = NULL;
static int current_scope = 0;

void initSymbolTable(void) {
    symbols = NULL;
    current_scope = 0;
}

void enter_scope() {
    current_scope++;
}

void exit_scope() {
    Sym *current = symbols;
    while (current != NULL && current->scope == current_scope) {
        Sym *temp = current;
        current = current->next;
        free(temp->name);
        free(temp->type);
        free(temp);
    }
    symbols = current;
    current_scope--;
}

int insertSymbol(const char *name, const char *type, int line) {
    Sym *current = symbols;
    // Verifica se a variável já foi declarada no escopo atual.
    while (current != NULL && current->scope == current_scope) {
        if (strcmp(current->name, name) == 0) {
            fprintf(stderr, "Erro Semântico (linha %d): Variável '%s' já declarada neste escopo.\n", line, name);
            return 0; // Retorna 0 em caso de falha.
        }
        current = current->next;
    }

    Sym *new_symbol = (Sym *)malloc(sizeof(Sym));
    if (!new_symbol) {
        fprintf(stderr, "Falha ao alocar memória para novo símbolo.\n");
        exit(1);
    }

    new_symbol->name = strdup(name);
    new_symbol->type = strdup(type);
    new_symbol->scope = current_scope;
    new_symbol->line = line;
    new_symbol->next = symbols;
    symbols = new_symbol;
    
    return 1; // Retorna 1 em caso de sucesso.
}

// Corrigido o tipo do parâmetro 'name' de 'Sym*' para 'const char*'.
Sym *lookupSymbol(const char *name) {
    Sym *current = symbols;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

void freeSymbolTable(void) {
    Sym *current = symbols;
    while (current != NULL) {
        Sym *temp = current;
        current = current->next;
        free(temp->name);
        free(temp->type);
        free(temp);
    }
    symbols = NULL;
}
