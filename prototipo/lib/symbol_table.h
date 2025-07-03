// symbol_table.h
#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

void initSymbolTable(void);
void insertSymbol(const char *name, const char *type);
const char *lookupSymbol(const char *name);
void freeSymbolTable(void);

#endif
