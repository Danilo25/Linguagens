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

### 2. Gere as regras com o  bison

Compile o arquivo gerado com o GCC, garantindo que a biblioteca do Flex seja vinculada com a flag -lfl:

```bash
bison -d parser.y
```

### 3. Compile o Analisador sintático com o GCC

Compile os arquivos gerados com o GCC

```bash
gcc parser.tab.c lex.yy.c -o {nome do executavél} -lfl
```

### 4. Execute o Analisador Léxico

Execute o analisador direcionando a entrada a partir de um arquivo. Substitua `showcaselang.txt` pelo nome do seu arquivo de entrada, se for diferente:

```bash
./{nome do executavél}  teste4.txt
```
