#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "lib/rational.h"
#include "lib/matrix.h"
#include "lib/bst.h"

/* Stub de leitura */
float read() { float v; if (scanf("%f", &v)!=1) return -1.0f; return v;}

void mdc(int n, int m, void* r);


int main() {
    int resultado = 0;
    mdc(48, 18, &resultado);
    printf("%d\n", resultado);
    mdc(101, 10, &resultado);
    printf("%d\n", resultado);
    mdc(50, 25, &resultado);
    printf("%d\n", resultado);
}

