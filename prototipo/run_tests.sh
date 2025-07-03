#!/bin/bash

set -e  # para o script se algum comando falhar

# Compilar o compilador
echo "🛠️ Compilando o compilador..."
make

# Criar diretórios de testes
mkdir -p tests/problema1
mkdir -p tests/problema2

# Teste do problema 1
echo "⚙️ Gerando e compilando problema1..."
./compiler problema1.txt tests/problema1/saida1.c
gcc tests/problema1/saida1.c -o tests/problema1/teste1.exe
echo "📤 Executando problema1:"
./tests/problema1/teste1.exe

# Teste do problema 2
echo "⚙️ Gerando e compilando problema2..."
./compiler problema2.txt tests/problema2/saida2.c
gcc tests/problema2/saida2.c -o tests/problema2/teste2.exe
echo "📤 Executando problema2 com entrada2.txt:"
./tests/problema2/teste2.exe < entrada2.txt

echo "✅ Todos os testes executados com sucesso!"
