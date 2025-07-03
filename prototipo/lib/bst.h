#ifndef BST_H
#define BST_H

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdarg.h> // Necessário para funções com argumentos variáveis

// --- Definição da Estrutura ---

// Estrutura para um nó da árvore binária de busca
typedef struct TreeNode {
    int key;
    struct TreeNode* left;
    struct TreeNode* right;
} TreeNode;


// --- Protótipos das Funções da Biblioteca ---

/**
 * A) Cria uma árvore binária de busca a partir de uma sequência de inteiros.
 * Usa argumentos variáveis para receber a sequência.
 * @param count O número de elementos na sequência.
 * @param ... A sequência de inteiros a serem inseridos.
 * @return Um ponteiro para o nó raiz da árvore criada.
 */
TreeNode* create_bst_from_sequence(int count, ...);

/**
 * B) Encontra a chave mínima na árvore.
 * @param root Ponteiro para o nó raiz da árvore.
 * @return O valor da chave mínima. Retorna -1 se a árvore estiver vazia.
 */
int get_min_value(TreeNode* root);

/**
 * B) Encontra o nível da chave mínima na árvore (raiz está no nível 0).
 * @param root Ponteiro para o nó raiz da árvore.
 * @return O nível da chave mínima. Retorna -1 se a árvore estiver vazia.
 */
int get_min_level(TreeNode* root);

/**
 * C) Encontra a chave máxima na árvore.
 * @param root Ponteiro para o nó raiz da árvore.
 * @return O valor da chave máxima. Retorna -1 se a árvore estiver vazia.
 */
int get_max_value(TreeNode* root);

/**
 * C) Encontra o nível da chave máxima na árvore (raiz está no nível 0).
 * @param root Ponteiro para o nó raiz da árvore.
 * @return O nível da chave máxima. Retorna -1 se a árvore estiver vazia.
 */
int get_max_level(TreeNode* root);

/**
 * D) Imprime a árvore na saída padrão, um nível por linha.
 * @param root Ponteiro para o nó raiz da árvore.
 */
void print_bst_by_level(TreeNode* root);

/**
 * Libera toda a memória alocada para a árvore.
 * @param root Ponteiro para o nó raiz da árvore a ser liberada.
 */
void free_bst(TreeNode* root);

#endif // BST_H
