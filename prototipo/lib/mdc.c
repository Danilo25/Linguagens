#include <stdio.h>

/**
 * @brief Calcula o Maior Divisor Comum (MDC) entre dois números.
 * @param n O primeiro número (passado por valor).
 * @param m O segundo número (passado por valor).
 * @param r Ponteiro para a variável onde o resultado será armazenado (passado por referência).
 */
void mdc(int n, int m, int* r) {
    if (m % n == 0) {
        *r = n; // n é o MDC
        return;
    }
    if (n % m == 0) {
        *r = m; // m é o MDC
        return;
    }
    if (m > n) {
        // Chamada recursiva com n e o resto de m/n
        mdc(n, m % n, r);
    } else { // n > m
        // Chamada recursiva com m e o resto de n/m
        mdc(m, n % m, r);
    }
}
