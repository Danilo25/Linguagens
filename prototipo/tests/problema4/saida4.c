#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "lib/rational.h"

/* Stub de leitura */
float read() { float v; if (scanf("%f", &v)!=1) return -1.0f; return v;}

int main() {
    rational_t r1 = create_rational(5, 10);
    rational_t r2 = create_rational(1, 3);
    print_rational(r1);
    print_rational(r2);
    rational_t r3 = create_rational(2, 4);
    int iguais = are_equal(r1, r3);
    printf("%d\n", iguais);
    rational_t r_soma = add(r1, r2);
    print_rational(r_soma);
    rational_t r_sub = subtract(r1, r2);
    print_rational(r_sub);
    rational_t r_neg = negate(r1);
    print_rational(r_neg);
    rational_t r_mult = multiply(r1, r2);
    print_rational(r_mult);
    rational_t r_inv = inverse(create_rational(3, 5));
    print_rational(r_inv);
    rational_t r_div = divide(r1, r2);
    print_rational(r_div);
}

