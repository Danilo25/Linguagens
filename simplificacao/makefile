COMPILER = analisador

C_SOURCES = y.tab.c lex.yy.c lib/tabela_simbolos.c

CC = gcc
CFLAGS = -Wall -g

all: $(COMPILER)

$(COMPILER): $(C_SOURCES)
	$(CC) $(CFLAGS) $^ -o $(COMPILER)

y.tab.c: parser.y
	bison -d -o y.tab.c parser.y

lex.yy.c: scanner.l
	flex -o lex.yy.c scanner.l

clean:
	rm -f $(COMPILER) y.tab.c y.tab.h lex.yy.c *.o y.output