#include "matrix.h"

// --- Implementação das Funções ---

/**
 * @brief Aloca dinamicamente uma nova matriz com as dimensões especificadas.
 * Todos os elementos são inicializados com 0.0.
 * @param rows O número de linhas.
 * @param cols O número de colunas.
 * @return Um ponteiro para a nova matriz alocada, ou NULL se a alocação falhar.
 */
matrix_t* create_matrix(int rows, int cols) {
    // Aloca memória para a estrutura da matriz
    matrix_t* m = (matrix_t*) malloc(sizeof(matrix_t));
    if (m == NULL) return NULL;

    m->rows = rows;
    m->cols = cols;

    // Aloca memória para o array de ponteiros (as linhas)
    m->data = (float**) malloc(rows * sizeof(float*));
    if (m->data == NULL) {
        free(m);
        return NULL;
    }

    // Aloca memória para cada linha individualmente e inicializa com 0
    for (int i = 0; i < rows; i++) {
        m->data[i] = (float*) calloc(cols, sizeof(float)); // calloc já inicializa com 0
        if (m->data[i] == NULL) {
            // Em caso de falha, libera toda a memória já alocada
            for (int j = 0; j < i; j++) free(m->data[j]);
            free(m->data);
            free(m);
            return NULL;
        }
    }
    return m;
}

/**
 * @brief Libera toda a memória associada a uma matriz.
 * @param m Ponteiro para a matriz a ser liberada.
 */
void free_matrix(matrix_t* m) {
    if (m == NULL) return;
    for (int i = 0; i < m->rows; i++) {
        free(m->data[i]);
    }
    free(m->data);
    free(m);
}

/**
 * @brief Define o valor de um elemento específico na matriz.
 * @param m Ponteiro para a matriz.
 * @param row Índice da linha.
 * @param col Índice da coluna.
 * @param value O valor a ser definido.
 */
void set_element(matrix_t* m, int row, int col, float value) {
    if (m != NULL && row < m->rows && col < m->cols) {
        m->data[row][col] = value;
    }
}

/**
 * @brief Imprime a matriz no console de forma formatada.
 * @param m Ponteiro para a matriz a ser impressa.
 */
void print_matrix(const matrix_t* m) {
    if (m == NULL) {
        printf("Matriz nula (operação inválida).\n");
        return;
    }
    printf("[\n");
    for (int i = 0; i < m->rows; i++) {
        printf("  ");
        for (int j = 0; j < m->cols; j++) {
            printf("%8.2f", m->data[i][j]);
        }
        printf("\n");
    }
    printf("]\n");
}

/**
 * @brief Soma duas matrizes.
 * @param m1 Ponteiro para a primeira matriz.
 * @param m2 Ponteiro para a segunda matriz.
 * @return Um ponteiro para uma nova matriz contendo o resultado,
 * ou NULL se a soma for impossível.
 */
matrix_t* add_matrices(const matrix_t* m1, const matrix_t* m2) {
    // Verifica se as dimensões são compatíveis para a soma
    if (m1->rows != m2->rows || m1->cols != m2->cols) {
        printf("Erro: Matrizes com dimensões incompatíveis para soma.\n");
        return NULL;
    }

    // Cria a matriz de resultado
    matrix_t* result = create_matrix(m1->rows, m1->cols);
    if (result == NULL) return NULL;

    // Realiza a soma elemento a elemento
    for (int i = 0; i < result->rows; i++) {
        for (int j = 0; j < result->cols; j++) {
            result->data[i][j] = m1->data[i][j] + m2->data[i][j];
        }
    }
    return result;
}

/**
 * @brief Multiplica duas matrizes.
 * @param m1 Ponteiro para a primeira matriz.
 * @param m2 Ponteiro para a segunda matriz.
 * @return Um ponteiro para uma nova matriz contendo o resultado,
 * ou NULL se a multiplicação for impossível.
 */
matrix_t* multiply_matrices(const matrix_t* m1, const matrix_t* m2) {
    // Verifica se as dimensões são compatíveis para a multiplicação
    if (m1->cols != m2->rows) {
        printf("Erro: Dimensões de matriz incompatíveis para multiplicação.\n");
        return NULL;
    }

    // Cria a matriz de resultado com as dimensões corretas (m1->rows x m2->cols)
    matrix_t* result = create_matrix(m1->rows, m2->cols);
    if (result == NULL) return NULL;

    // Realiza a multiplicação
    for (int i = 0; i < result->rows; i++) {
        for (int j = 0; j < result->cols; j++) {
            for (int k = 0; k < m1->cols; k++) {
                result->data[i][j] += m1->data[i][k] * m2->data[k][j];
            }
        }
    }
    return result;
}
