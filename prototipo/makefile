# Makefile para o protótipo

CC      = gcc
FLEX    = flex
BISON   = bison
CFLAGS  = -Wall -g
TARGET  = compiler

# Fontes
Y_SRC   = parser.y
Y_HDR   = parser.tab.h
Y_C     = parser.tab.c
LEX_SRC = scanner.l
LEX_C   = lex.yy.c

LIBSRC  = ./lib/record.c ./lib/symbol_table.c

.PHONY: all clean

all: $(TARGET)

# 1) Gera parser.tab.c e parser.tab.h a partir de parser.y
$(Y_C) $(Y_HDR): $(Y_SRC)
	$(BISON) -d -v -o $(Y_C) $(Y_SRC)

# 2) Gera lex.yy.c a partir de scanner.l, após parser.tab.h existir
$(LEX_C): $(LEX_SRC) $(Y_HDR)
	$(FLEX) -o $(LEX_C) $(LEX_SRC)

# 3) Linka tudo e gera o executável
$(TARGET): $(Y_C) $(LEX_C) $(LIBSRC)
	$(CC) $(CFLAGS) $(Y_C) $(LEX_C) $(LIBSRC) -o $(TARGET)

clean:
	rm -f $(TARGET) $(Y_C) $(Y_HDR) $(LEX_C) y.output
