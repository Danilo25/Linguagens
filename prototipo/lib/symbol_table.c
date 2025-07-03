// symbol_table.c
#include "symbol_table.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

// Uma lista simples de pares nome→tipo
typedef struct Sym {
    char *name;
    char *type;
    struct Sym *next;
} Sym;

static Sym *symbols = NULL;

void initSymbolTable(void) {
    symbols = NULL;
}

void insertSymbol(const char *name, const char *type) {
    Sym *s = malloc(sizeof *s);
    s->name = strdup(name);
    s->type = strdup(type);
    s->next = symbols;
    symbols = s;
}

const char *lookupSymbol(const char *name) {
    for (Sym *s = symbols; s; s = s->next) {
        if (strcmp(s->name, name) == 0) {
            return s->type;
        }
    }
    return "Int"; // default ou erro
}

void freeSymbolTable(void) {
    while (symbols) {
        Sym *next = symbols->next;
        free(symbols->name);
        free(symbols->type);
        free(symbols);
        symbols = next;
    }
}
