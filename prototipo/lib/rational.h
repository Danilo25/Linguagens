#ifndef RATIONAL_H
#define RATIONAL_H

#include <stdbool.h> // Para usar os tipos 'true' e 'false'

// Definição do tipo rational_t (Problema 4)
typedef struct {
    int numerador;
    int denominador;
} rational_t;

/* --- SUBPROGRAMAS REQUISITADOS --- */

// A) Cria e retorna um rational_t a/b
rational_t create_rational(int a, int b);

// B) Compara se dois racionais são iguais
bool are_equal(rational_t r1, rational_t r2);

// C) Operações aritméticas
rational_t add(rational_t r1, rational_t r2);      // Soma
rational_t negate(rational_t r);                   // Negação (-r)
rational_t subtract(rational_t r1, rational_t r2); // Subtração
rational_t multiply(rational_t r1, rational_t r2); // Multiplicação
rational_t inverse(rational_t r);                  // Inverso (1/r)
rational_t divide(rational_t r1, rational_t r2);   // Divisão

/* --- FUNÇÕES AUXILIARES (NÃO REQUISITADAS, MAS ÚTEIS) --- */
void print_rational(rational_t r); // Para imprimir de forma legível no programa principal

#endif // RATIONAL_H
