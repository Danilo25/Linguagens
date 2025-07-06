#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "lib/rational.h"
#include "lib/matrix.h"
#include "lib/bst.h"

/* Stub de leitura */
float read() { float v; if (scanf("%f", &v)!=1) return -1.0f; return v;}

int main() {
    int i = 1;
    printf("%d\n", i);
    i = (i + 1);
    printf("%d\n", i);
    i = (i + 1);
    printf("%d\n", i);
    int x = 10;
    int y = 20;
    printf("%d\n", x);
    printf("%d\n", y);
}

