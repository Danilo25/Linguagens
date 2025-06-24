Manual de Uso do Analisador Sintático da Linguagem LingEL
1. Introdução
Este manual descreve o uso do analisador sintático para a linguagem LingEL, uma linguagem de programação simples projetada para fins educacionais. O analisador verifica se um programa fonte está sintaticamente correto conforme as regras da linguagem.
A linguagem LingEL suporta:

Declarações de variáveis (Int, Float, String)
Estruturas de controle (if-else, for, while)
Funções com parâmetros e retorno
Arrays
Expressões aritméticas, lógicas e relacionais

2. Instalação
Para usar o analisador, instale as seguintes ferramentas:

Flex: Gerador de analisadores léxicos
Bison: Gerador de analisadores sintáticos
GCC: Compilador C

No Ubuntu, use:
sudo apt-get install flex bison gcc

3. Compilação
Compile o analisador com os seguintes passos:

Gere o parser:
bison -d parser.y

Isso cria parser.tab.c e parser.tab.h.

Gere o scanner:
flex scanner.l

Isso cria lex.yy.c.

Compile tudo:
gcc -o parser lex.yy.c parser.tab.c -lfl

O executável parser será gerado.


4. Uso
Analise um arquivo fonte com:
./parser arquivo.lang


Se correto, a saída será:Parsing completed successfully!
Se houver erro, uma mensagem indicará o problema, como:SYNTAX ERROR: syntax error at line 2 near 'print'

5. Exemplos
Exemplo 1: Programa Correto
Arquivo test1.lang:
Int x = 5;
print x;

Comando:
./parser test1.lang

Saída:
Parsing completed successfully!

Exemplo 2: Programa com Erro
Arquivo error.lang:
Int x = 5
print x;  // Falta ponto e vírgula

Comando:
./parser error.lang

Saída:
SYNTAX ERROR: syntax error at line 2 near 'print'

Exemplo 3: Fatorial
Arquivo factorial.lang:
Int factorial(Int n) {
    Int result = 1;
    for (Int i = 1; i <= n; i++) {
        result = result * i;
    }
    return result;
}

Int f = factorial(5);
print f;  // Deve imprimir 120

Comando:
./parser factorial.lang

Saída:
Parsing completed successfully!

6. Solução de Problemas

"command not found": Verifique se o parser foi gerado. Repita a compilação.
Erro de sintaxe: Veja a linha indicada na mensagem de erro e corrija (ex.: falta de ;).
Erro na compilação: Confirme que lex.yy.c e parser.tab.c foram criados.

7. Referência da Linguagem

Variáveis: Int x = 5;, Float y = 3.14;, String z = "texto";
Controle: if (cond) {...}, for (Int i = 0; i < n; i++) {...}, while (cond) {...}
Funções: Int nome(tipo param) {... return valor;}
Arrays: Int[] arr = [1, 2, 3];, arr[0] = 5;
