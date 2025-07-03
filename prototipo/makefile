# Makefile para o protótipo

CC        = gcc
FLEX      = flex
BISON     = bison
CFLAGS    = -Wall -g
LDFLAGS   =
TARGET    = compiler

# Fontes do analisador
LEX_SRC   = lex.yy.c
Y_SRC     = parser.tab.c
Y_HDR     = parser.tab.h

# Módulos auxiliares
LIBSRC    = ./lib/record.c ./lib/symbol_table.c

.PHONY: all clean

all: $(TARGET)

# Regra principal: gera o executável compiler
$(TARGET): $(LEX_SRC) $(Y_SRC) $(LIBSRC)
	$(CC) $(CFLAGS) $(LEX_SRC) $(Y_SRC) $(LIBSRC) -o $(TARGET)

# Gera lex.yy.c a partir do scanner.l
$(LEX_SRC): scanner.l
	$(FLEX) scanner.l

# Gera parser.tab.c e parser.tab.h a partir do parser.y
$(Y_SRC) $(Y_HDR): parser.y
	$(BISON) -d -v -o parser.tab.c parser.y

clean:
	rm -f $(LEX_SRC) $(Y_SRC) $(Y_HDR) $(TARGET) output.txt y.output
