// symbol_table.h
#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

typedef struct Sym {
  char *name;
  char *type;
  int scope;
  int line;
  struct Sym *next;
} Sym;

void enter_scope();
void exit_scope();
void initSymbolTable(void);
// A função insertSymbol foi corrigida para aceitar a linha onde o símbolo foi declarado.
int insertSymbol(const char *name, const char *type, int line);
Sym *lookupSymbol(const char *name);
void freeSymbolTable(void);

#endif
