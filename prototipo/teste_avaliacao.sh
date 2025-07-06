#!/bin/bash

# Script para testar aspectos específicos de avaliação do compilador
# Uso: ./teste_avaliacao.sh

echo "=== TESTES DE AVALIAÇÃO DO COMPILADOR ==="
echo

# Verifica se o compilador existe
if [ ! -f "./analisador.exe" ] && [ ! -f "./compiler.exe" ] && [ ! -f "./compiler" ]; then
    echo "ERRO: Compilador não encontrado. Executáveis procurados: analisador.exe, compiler.exe, compiler"
    exit 1
fi

# Define o nome do executável do compilador
COMPILER="./analisador.exe"
if [ -f "./compiler.exe" ]; then
    COMPILER="./compiler.exe"
elif [ -f "./compiler" ]; then
    COMPILER="./compiler"
fi

# Contador de testes
total_tests=0
passed_tests=0

# Função para executar um teste
run_test() {
    local test_name=$1
    local test_file=$2
    local should_fail=$3
    
    echo "--- Teste: $test_name ---"
    ((total_tests++))
    
    # Verifica se o arquivo de teste existe
    if [ ! -f "$test_file" ]; then
        echo "ERRO: Arquivo $test_file não encontrado"
        return 1
    fi
    
    # Arquivo de saída
    local output_file="saida_${test_name}.c"
    local exe_file="teste_${test_name}"
    
    # Tenta compilar
    echo "Compilando $test_file..."
    $COMPILER "$test_file" "$output_file" 2>&1
    local compile_result=$?
    
    if [ $compile_result -eq 0 ]; then
        if [ "$should_fail" = "true" ]; then
            echo "❌ FALHA: Teste deveria falhar mas passou"
            return 1
        else
            echo "✅ Compilação bem-sucedida"
            
            # Como não há gcc disponível, vamos apenas verificar se o arquivo C foi gerado
            if [ -f "$output_file" ]; then
                echo "✅ Código C gerado com sucesso"
                echo "📄 Arquivo gerado: $output_file"
                
                # Mostra as primeiras linhas do código gerado
                echo "--- Primeiras linhas do código C gerado ---"
                head -10 "$output_file"
                echo "--- Fim da prévia ---"
                
                ((passed_tests++))
                echo "✅ Teste $test_name PASSOU"
            else
                echo "❌ Arquivo C não foi gerado"
                return 1
            fi
        fi
    else
        if [ "$should_fail" = "true" ]; then
            echo "✅ Teste falhou como esperado"
            ((passed_tests++))
            echo "✅ Teste $test_name PASSOU"
        else
            echo "❌ Falha na compilação"
            return 1
        fi
    fi
    
    # Limpa arquivos temporários
    # rm -f "$output_file" "$exe_file" "${exe_file}.exe"
    echo
    
    return 0
}

# 1. TESTES DE ESTRUTURA SINTÁTICA
echo "🔍 1. TESTES DE ESTRUTURA SINTÁTICA"
echo

# 1.A - Detecção de erros léxicos
run_test "erro_lexico" "teste_erro_lexico.txt" "true"

# 1.B - Detecção de erros sintáticos
run_test "erro_sintatico" "teste_erro_sintatico.txt" "true"

# 1.C - Precedência de operadores
run_test "precedencia" "teste_precedencia.txt" "false"

# 2. TESTES DE VARIÁVEIS
echo "🔍 2. TESTES DE VARIÁVEIS"
echo

# 2.A - Estruturas de controle (teste básico de variáveis)
run_test "estruturas_controle" "teste_estruturas_controle.txt" "false"

# 3. TESTES DE EXPRESSÕES
echo "🔍 3. TESTES DE EXPRESSÕES"
echo

# 3.A - Tipos especializados
run_test "tipos_especializados" "teste_tipos_especializados.txt" "false"

# 4. TESTES DE PASSAGEM DE PARÂMETROS
echo "🔍 4. TESTES DE PASSAGEM DE PARÂMETROS"
echo

# 4.A - Passagem por referência
run_test "referencia" "teste_referencia.txt" "false"

# 5. TESTES DOS PROBLEMAS ORIGINAIS
echo "🔍 5. TESTES DOS PROBLEMAS ORIGINAIS"
echo

# Executa os problemas originais
for i in $(seq 1 6); do
    if [ -f "problema${i}.txt" ]; then
        run_test "problema${i}" "problema${i}.txt" "false"
    fi
done

# Relatório final
echo "=== RELATÓRIO FINAL DE AVALIAÇÃO ==="
echo "Total de testes: $total_tests"
echo "Testes aprovados: $passed_tests"
echo "Testes falharam: $((total_tests - passed_tests))"
echo "Taxa de sucesso: $(((passed_tests * 100) / total_tests))%"

if [ $passed_tests -eq $total_tests ]; then
    echo "🎉 Todos os testes de avaliação passaram!"
    exit 0
else
    echo "⚠️  Alguns testes falharam. Verifique as implementações."
    exit 1
fi
