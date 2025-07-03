#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "lib/rational.h"
#include "lib/matrix.h"
#include "lib/bst.h"

/* Stub de leitura */
float read() { float v; if (scanf("%f", &v)!=1) return -1.0f; return v;}

int main() {
    TreeNode* arvore = create_bst_from_sequence(7, 50, 30, 70, 20, 40, 60, 80);
    print_bst_by_level(arvore);
    int min_val = get_min_value(arvore);
    int min_lvl = get_min_level(arvore);
    printf("%d\n", min_val);
    printf("%d\n", min_lvl);
    int max_val = get_max_value(arvore);
    int max_lvl = get_max_level(arvore);
    printf("%d\n", max_val);
    printf("%d\n", max_lvl);
    free_bst(arvore);
}

