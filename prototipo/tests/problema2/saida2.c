#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

/* Stub de leitura */
float read() { float v; if (scanf("%f", &v)!=1) return -1.0f; return v;}

int main() {
    int c1 = 0;
    int c2 = 0;
    int c3 = 0;
    int c4 = 0;
    float in = read();
L7:
    if (!((in >= 0))) goto L8;
    if (!((in <= 25))) goto L0;
    c1 = (c1 + 1);

L0:
    if (!((in > 25))) goto L2;
    if (!((in <= 50))) goto L1;
    c2 = (c2 + 1);

L1:

L2:
    if (!((in > 50))) goto L4;
    if (!((in <= 75))) goto L3;
    c3 = (c3 + 1);

L3:

L4:
    if (!((in > 75))) goto L6;
    if (!((in <= 100))) goto L5;
    c4 = (c4 + 1);

L5:

L6:
    in = read();

    goto L7;
L8:
    printf("%d\n", c1);
    printf("%d\n", c2);
    printf("%d\n", c3);
    printf("%d\n", c4);
}

