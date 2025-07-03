#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "lib/rational.h"
#include "lib/matrix.h"
#include "lib/bst.h"

/* Stub de leitura */
float read() { float v; if (scanf("%f", &v)!=1) return -1.0f; return v;}

int main() {
    matrix_t* A = create_matrix(2, 2);
    set_element(A, 0, 0, 1.000000);
    set_element(A, 0, 1, 2.000000);
    set_element(A, 1, 0, 3.000000);
    set_element(A, 1, 1, 4.000000);
    print_matrix(A);
    matrix_t* B = create_matrix(2, 2);
    set_element(B, 0, 0, 5.000000);
    set_element(B, 0, 1, 6.000000);
    set_element(B, 1, 0, 7.000000);
    set_element(B, 1, 1, 8.000000);
    print_matrix(B);
    matrix_t* Soma = add_matrices(A, B);
    print_matrix(Soma);
    matrix_t* Produto = multiply_matrices(A, B);
    print_matrix(Produto);
    matrix_t* C = create_matrix(3, 2);
    set_element(C, 0, 0, 1.000000);
    set_element(C, 1, 1, 1.000000);
    set_element(C, 2, 0, 1.000000);
    print_matrix(C);
    matrix_t* SomaInvalida = add_matrices(A, C);
    print_matrix(SomaInvalida);
    matrix_t* ProdutoInvalido = multiply_matrices(A, C);
    print_matrix(ProdutoInvalido);
    free_matrix(A);
    free_matrix(B);
    free_matrix(C);
    free_matrix(Soma);
    free_matrix(Produto);
    free_matrix(SomaInvalida);
    free_matrix(ProdutoInvalido);
}

