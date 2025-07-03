#include "rational.h"
#include <stdio.h>
#include <stdlib.h>

// --- Funções Auxiliares ---

// Máximo Divisor Comum (Algoritmo de Euclides)
static int mdc(int a, int b) {
    while (b != 0) {
        int temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}

// Simplifica um número racional
static rational_t simplify(rational_t r) {
    if (r.denominador == 0) {
        fprintf(stderr, "Erro: Denominador não pode ser zero.\n");
        exit(1);
    }
    
    // Garante que o sinal fique no numerador
    if (r.denominador < 0) {
        r.numerador = -r.numerador;
        r.denominador = -r.denominador;
    }
    
    int divisor = mdc(abs(r.numerador), r.denominador);
    r.numerador /= divisor;
    r.denominador /= divisor;
    return r;
}

// --- Implementação dos Subprogramas ---

// A) Cria um rational_t
rational_t create_rational(int a, int b) {
    rational_t r = {a, b};
    return simplify(r);
}

// B) Compara dois racionais
bool are_equal(rational_t r1, rational_t r2) {
    // Como ambos são simplificados, a comparação é direta.
    return (r1.numerador == r2.numerador && r1.denominador == r2.denominador);
}

// C) Operações
rational_t add(rational_t r1, rational_t r2) {
    int num = r1.numerador * r2.denominador + r2.numerador * r1.denominador;
    int den = r1.denominador * r2.denominador;
    return create_rational(num, den);
}

rational_t negate(rational_t r) {
    return create_rational(-r.numerador, r.denominador);
}

rational_t subtract(rational_t r1, rational_t r2) {
    return add(r1, negate(r2));
}

rational_t multiply(rational_t r1, rational_t r2) {
    return create_rational(r1.numerador * r2.numerador, r1.denominador * r2.denominador);
}

rational_t inverse(rational_t r) {
    return create_rational(r.denominador, r.numerador);
}

rational_t divide(rational_t r1, rational_t r2) {
    return multiply(r1, inverse(r2));
}

void print_rational(rational_t r) {
    printf("%d/%d\n", r.numerador, r.denominador);
}
