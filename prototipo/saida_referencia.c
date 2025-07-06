#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "lib/rational.h"
#include "lib/matrix.h"
#include "lib/bst.h"

/* Stub de leitura */
float read() { float v; if (scanf("%f", &v)!=1) return -1.0f; return v;}

void teste() {
    int x = 10;
    printf("%d\n", x);
}


int main() {
    int a = 5;
    printf("%d\n", a);
    teste();
}

