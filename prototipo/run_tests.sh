#!/bin/bash

# Este script para a execução se qualquer comando falhar (set -e)
set -e

# --- ETAPA 1: Compilar o compilador ---
echo "🛠️  Compilando o compilador..."
make

# --- ETAPA 2: Preparar os diretórios de teste ---
echo "📁 Preparando diretórios de teste..."
mkdir -p tests/problema1
mkdir -p tests/problema2
mkdir -p tests/problema3
mkdir -p tests/problema4

# --- ETAPA 3: Executar os testes ---

# Teste do problema 1
echo ""
echo "⚙️  Gerando e compilando problema1..."
./compiler problema1.txt tests/problema1/saida1.c
# Adicionado -I. para que o gcc encontre os headers na pasta raiz
gcc -I. tests/problema1/saida1.c -o tests/problema1/teste1.exe
echo "📤 Executando problema1:"
./tests/problema1/teste1.exe

# Teste do problema 2
echo ""
echo "⚙️  Gerando e compilando problema2..."
./compiler problema2.txt tests/problema2/saida2.c
# Adicionado -I. para que o gcc encontre os headers na pasta raiz
gcc -I. tests/problema2/saida2.c -o tests/problema2/teste2.exe
echo "📤 Executando problema2 com entrada2.txt:"
./tests/problema2/teste2.exe < entrada2.txt

# Teste do problema 3 (Matrix)
echo ""
echo "⚙️  Gerando e compilando problema3..."
# 1. Usa seu compilador para traduzir problema3.txt para C
./compiler problema3.txt tests/problema3/saida3.c
# 2. Compila o código C gerado, linkando com a biblioteca de matrizes
# Adicionado -I. para que o gcc encontre os headers na pasta raiz
gcc -I. tests/problema3/saida3.c lib/matrix.c -o tests/problema3/teste3.exe
echo "📤 Executando problema3:"
./tests/problema3/teste3.exe

# Teste do problema 4 (Rational)
echo ""
echo "⚙️  Gerando e compilando problema4..."
# 1. Usa seu compilador para traduzir problema4.txt para C
./compiler problema4.txt tests/problema4/saida4.c
# 2. Compila o código C gerado, linkando com a biblioteca de racionais
# Adicionado -I. para que o gcc encontre os headers na pasta raiz
gcc -I. tests/problema4/saida4.c lib/rational.c -o tests/problema4/teste4.exe
echo "📤 Executando problema4:"
./tests/problema4/teste4.exe

echo ""
echo "✅ Todos os testes executados com sucesso!"
