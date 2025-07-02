#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tabela_simbolos.h"

static Symbol *symbol_table_head = NULL;
static int current_scope = 0;

void init_table() {
    symbol_table_head = NULL;
    current_scope = 0;
}

void enter_scope() {
    current_scope++;
}

void exit_scope() {
    Symbol *current = symbol_table_head;

    while (current != NULL && current->scope == current_scope) {
        Symbol *temp = current;
        current = current->next;
        free(temp->name);
        free(temp->type);
        free(temp);
    }
    
    symbol_table_head = current;
    current_scope--;
}

int add_symbol(const char *name, const char *type, int line) {
    Symbol *current = symbol_table_head;
    while (current != NULL && current->scope == current_scope) {
        if (strcmp(current->name, name) == 0) {
            fprintf(stderr, "Erro Semântico (linha %d): Variável '%s' já declarada neste escopo.\n", line, name);
            return 0;
        }
        current = current->next;
    }

    Symbol *new_symbol = (Symbol *)malloc(sizeof(Symbol));
    if (!new_symbol) {
        fprintf(stderr, "Falha ao alocar memória para novo símbolo.\n");
        exit(1);
    }

    new_symbol->name = strdup(name);
    new_symbol->type = strdup(type);
    new_symbol->scope = current_scope;
    new_symbol->line = line;
    new_symbol->next = symbol_table_head;
    symbol_table_head = new_symbol;
    
    return 1;
}

Symbol* find_symbol(const char *name) {
    Symbol *current = symbol_table_head;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

void free_table() {
    Symbol *current = symbol_table_head;
    while (current != NULL) {
        Symbol *temp = current;
        current = current->next;
        free(temp->name);
        free(temp->type);
        free(temp);
    }
    symbol_table_head = NULL;
}
