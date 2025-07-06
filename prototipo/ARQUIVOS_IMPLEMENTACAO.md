# Lista de Arquivos de Implementação do Compilador

## Arquivos Principais do Compilador

### 1. Analisador Léxico
- **scanner.l**: Definição do analisador léxico em Flex
  - Reconhecimento de tokens
  - Tratamento de comentários e espaços
  - Geração de valores semânticos

### 2. Analisador Sintático
- **parser.y**: Definição do analisador sintático em Bison/Yacc
  - Gramática da linguagem
  - Ações semânticas
  - Geração de código C

### 3. Bibliotecas Auxiliares (lib/)
- **symbol_table.h/c**: Implementação da tabela de símbolos
- **record.h/c**: Estruturas de dados para registros intermediários
- **rational.h/c**: Operações com números racionais
- **matrix.h/c**: Operações com matrizes
- **bst.h/c**: Implementação de árvores de busca binária
- **mdc.c**: Função para cálculo do máximo divisor comum
- **type_table.h/c**: Tabela de tipos (se presente)

### 4. Arquivos de Compilação
- **makefile**: Automação da compilação
- **compiler.exe**: Executável do compilador (gerado)

### 5. Arquivos Gerados (durante compilação)
- **parser.tab.c**: Código C do parser (gerado pelo Bison)
- **parser.tab.h**: Cabeçalho do parser (gerado pelo Bison)
- **lex.yy.c**: Código C do scanner (gerado pelo Flex)
- **parser.output**: Relatório de conflitos do parser (gerado pelo Bison)

### 6. Arquivos de Teste
- **problema1.txt**: Teste de operações aritméticas
- **problema2.txt**: Teste de estruturas de controle
- **problema3.txt**: Teste de operações com matrizes
- **problema4.txt**: Teste de números racionais
- **problema5.txt**: Teste de árvores de busca binária
- **problema6.txt**: Teste de funções avançadas
- **entrada2.txt**: Arquivo adicional de teste
- **run_tests.sh**: Script para executar todos os testes

### 7. Arquivos de Documentação
- **DOCUMENTACAO_COMPILADOR.md**: Documentação completa
- **DOCUMENTACAO_SCANNER.md**: Documentação do analisador léxico
- **DOCUMENTACAO_PARSER.md**: Documentação do analisador sintático
- **README.md**: Instruções de uso

### 8. Diretório de Testes (tests/)
```
tests/
├── problema1/
│   ├── saida1.c
│   └── teste1.exe
├── problema2/
│   ├── saida2.c
│   └── teste2.exe
├── problema3/
│   ├── saida3.c
│   └── teste3.exe
├── problema4/
│   ├── saida4.c
│   └── teste4.exe
├── problema5/
│   ├── saida5.c
│   └── teste5.exe
└── problema6/
    ├── saida6.c
    └── teste6.exe
```

## Dependências de Compilação

### Ferramentas Necessárias:
- **Flex**: Para compilar scanner.l
- **Bison/Yacc**: Para compilar parser.y
- **GCC**: Para compilar o código C resultante
- **Make**: Para automação (opcional)

### Processo de Compilação:
1. `bison -d parser.y` → Gera parser.tab.c e parser.tab.h
2. `flex scanner.l` → Gera lex.yy.c
3. `gcc -o compiler.exe parser.tab.c lex.yy.c lib/*.c` → Compila o executável

## Arquivos Essenciais para Avaliação

### Implementação (.l, .y, etc):
✓ **scanner.l** - Analisador léxico
✓ **parser.y** - Analisador sintático
✓ **lib/symbol_table.h** - Cabeçalho da tabela de símbolos
✓ **lib/symbol_table.c** - Implementação da tabela de símbolos
✓ **lib/record.h** - Estruturas de dados
✓ **lib/record.c** - Implementação das estruturas
✓ **lib/rational.h** - Operações com racionais
✓ **lib/rational.c** - Implementação de racionais
✓ **lib/matrix.h** - Operações com matrizes
✓ **lib/matrix.c** - Implementação de matrizes
✓ **lib/bst.h** - Árvores de busca binária
✓ **lib/bst.c** - Implementação de BST
✓ **makefile** - Automação de compilação

### Todos os arquivos listados estão presentes e funcionais no projeto.
