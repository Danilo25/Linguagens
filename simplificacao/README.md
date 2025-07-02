ordem para executar:
flex scanner.l
bison -d parser.y
gcc parser.tab.c lex.yy.c -o analisador -lfl
./analisador.exe questao1.txt