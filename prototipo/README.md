# Compilador para Linguagem Funcional com Tipos Especializados

## Visão Geral
Este projeto implementa um compilador completo para uma linguagem de programação funcional que suporta tipos especializados como números racionais, matrizes e árvores de busca binária (BST). O compilador traduz código fonte para C, permitindo execução eficiente.

## Características da Linguagem
- **Tipos básicos**: Int, Float, Unit (void)
- **Tipos especializados**: Rational, Matrix, BST
- **Operador de atribuição**: `<-` (seta esquerda)
- **Estruturas de controle**: if, while
- **Funções**: com suporte a passagem por referência (`ref`)
- **Comentários**: `//` (linha)

## Estrutura do Projeto
```
prototipo/
├── scanner.l              # Analisador léxico (Flex)
├── parser.y               # Analisador sintático (Bison)
├── makefile               # Automação de compilação
├── compiler.exe           # Compilador executável
├── lib/                   # Bibliotecas auxiliares
│   ├── symbol_table.h/c   # Tabela de símbolos
│   ├── record.h/c         # Estruturas de dados
│   ├── rational.h/c       # Operações com racionais
│   ├── matrix.h/c         # Operações com matrizes
│   └── bst.h/c           # Árvores de busca binária
├── tests/                 # Arquivos de teste
├── problema[1-6].txt      # Exemplos de programas
└── DOCUMENTACAO_*.md      # Documentação detalhada
```

## Compilação e Uso

### 1. Compilar o Compilador
```bash
make
```
Ou manualmente:
```bash
bison -d parser.y
flex scanner.l
gcc -o compiler.exe parser.tab.c lex.yy.c lib/*.c
```

### 2. Usar o Compilador
```bash
./compiler.exe <arquivo_entrada> <arquivo_saida>
```

### 3. Compilar e Executar o Código Gerado
```bash
gcc <arquivo_saida>.c -o programa_final
./programa_final
```

## Exemplo Completo

### Código Fonte (exemplo.txt)
```
Unit main() {
    Float x <- 2.5;
    Float y <- 1.2;
    Int c <- 3;
    
    Float resultado <- (x * x) - y + c;
    print resultado;
}
```

### Execução
```bash
./compiler.exe exemplo.txt saida.c
gcc saida.c -o exemplo_final
./exemplo_final
```

## Arquivos de Teste
- `problema1.txt`: Operações aritméticas básicas
- `problema2.txt`: Estruturas de controle (if/while)
- `problema3.txt`: Operações com matrizes
- `problema4.txt`: Números racionais
- `problema5.txt`: Árvores de busca binária
- `problema6.txt`: Funções e referências

## Testes de Avaliação Específicos
- `teste_erro_lexico.txt`: Validação de detecção de erros léxicos
- `teste_erro_sintatico.txt`: Validação de detecção de erros sintáticos
- `teste_precedencia.txt`: Validação de precedência de operadores
- `teste_referencia.txt`: Validação de passagem por referência
- `teste_tipos_especializados.txt`: Validação de tipos especializados
- `teste_estruturas_controle.txt`: Validação de estruturas de controle
- `teste_avaliacao.sh`: Script para executar todos os testes de avaliação

## Executar Testes de Avaliação
```bash
# Executar todos os testes de avaliação
chmod +x teste_avaliacao.sh
./teste_avaliacao.sh

# Executar teste específico
./compiler.exe teste_erro_lexico.txt saida_teste.c
```

## Documentação Completa
- `DOCUMENTACAO_COMPILADOR.md`: Documentação completa do compilador
- `DOCUMENTACAO_SCANNER.md`: Documentação do analisador léxico
- `DOCUMENTACAO_PARSER.md`: Documentação do analisador sintático
- `AVALIACAO_TECNICA.md`: Análise técnica dos aspectos de avaliação
- `GUIA_AVALIACAO.md`: Guia completo para avaliação do projeto

## Requisitos do Sistema
- GCC ou compilador C equivalente
- Flex (gerador de analisadores léxicos)
- Bison/Yacc (gerador de analisadores sintáticos)
- Make (opcional, para automação)

## Autores
Desenvolvido como projeto acadêmico para disciplina de Compiladores.
