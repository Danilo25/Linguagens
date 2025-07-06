#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "lib/rational.h"
#include "lib/matrix.h"
#include "lib/bst.h"

/* Stub de leitura */
float read() { float v; if (scanf("%f", &v)!=1) return -1.0f; return v;}

int main() {
    int a = 2;
    int b = 3;
    int c = 4;
    int resultado1 = (a + (b * c));
    printf("%d\n", resultado1);
    int resultado2 = ((a + b) * c);
    printf("%d\n", resultado2);
    int resultado3 = ((a + b) + c);
    printf("%d\n", resultado3);
}

