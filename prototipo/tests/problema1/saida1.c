#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "lib/rational.h"
#include "lib/matrix.h"
#include "lib/bst.h"

/* Stub de leitura */
float read() { float v; if (scanf("%f", &v)!=1) return -1.0f; return v;}

int main() {
    float x = 2.500000;
    float y = 1.200000;
    int c = 3;
    float resultado = (((x * x) - y) + c);
    printf("%f\n", resultado);
}

