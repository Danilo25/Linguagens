#ifndef RATIONAL_H
#define RATIONAL_H

#include <stdbool.h>
#include <stdio.h>

// Definição do tipo rational_t
typedef struct {
    int numerador;
    int denominador;
} rational_t;

// Protótipos das funções da biblioteca
rational_t create_rational(int a, int b);
bool are_equal(rational_t r1, rational_t r2);
rational_t add(rational_t r1, rational_t r2);
rational_t negate(rational_t r);
rational_t subtract(rational_t r1, rational_t r2);
rational_t multiply(rational_t r1, rational_t r2);
rational_t inverse(rational_t r);
rational_t divide(rational_t r1, rational_t r2);

// Função auxiliar para impressão
void print_rational(rational_t r);

#endif // RATIONAL_H
