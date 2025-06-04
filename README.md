# Como Testar o Projeto - Analisador Léxico

Este guia descreve os passos necessários para gerar, compilar e executar o analisador léxico utilizando **Flex** e **GCC**.

## Requisitos

Certifique-se de ter os seguintes pacotes instalados em seu sistema:

- [Flex](https://github.com/westes/flex)
- [GCC](https://gcc.gnu.org/)

## Passo a Passo

### 1. Gere o Código C com o Flex

Utilize o Flex para gerar o código-fonte C a partir do arquivo de definição léxica `scanner.l`:

```bash
flex scanner.l
```

### 2. Gere a tabela com o bison

Utilize o bison 
 `parser.y`:

```bash
bison -d parser.y
```

### 3. Compile o Analisador Léxico com o GCC

Compile os arquivos com gcc:

```bash
gcc lex.yy.c parser.tab.c -o parsertest
```

### 4. Execute o arquivo

Execute o analisador direcionando a entrada a partir de um arquivo. Substitua `test.txt` pelo nome do seu arquivo de entrada, se for diferente:

```bash
./parsertest.exe < test.txt
```
