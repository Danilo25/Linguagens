#ifndef MATRIX_H
#define MATRIX_H

#include <stdio.h>
#include <stdlib.h>

// --- Definição da Estrutura ---

// Define a estrutura para representar uma matriz dinâmica.
// Armazena as dimensões e um ponteiro para os dados.
typedef struct {
    int rows;
    int cols;
    float** data; // Ponteiro para um array de ponteiros (matriz 2D)
} matrix_t;


// --- Protótipos das Funções da Biblioteca ---

// Funções de Gerenciamento de Memória e Acesso
matrix_t* create_matrix(int rows, int cols);
void free_matrix(matrix_t* m);
void set_element(matrix_t* m, int row, int col, float value);
void print_matrix(const matrix_t* m);

// Funções de Operação (para o Problema 3)
matrix_t* add_matrices(const matrix_t* m1, const matrix_t* m2);
matrix_t* multiply_matrices(const matrix_t* m1, const matrix_t* m2);

#endif // MATRIX_H
