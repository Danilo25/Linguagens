#include "bst.h"

// --- Funções Auxiliares (privadas ao módulo) ---

// Aloca e inicializa um novo nó
static TreeNode* create_node(int key) {
    TreeNode* newNode = (TreeNode*)malloc(sizeof(TreeNode));
    if (newNode) {
        newNode->key = key;
        newNode->left = NULL;
        newNode->right = NULL;
    }
    return newNode;
}

// Insere um novo nó na árvore, mantendo as propriedades da BST
static TreeNode* insert_node(TreeNode* root, int key) {
    // Se a árvore/subárvore está vazia, cria o nó raiz
    if (root == NULL) {
        return create_node(key);
    }
    // Insere na subárvore direita se a chave for maior
    if (key > root->key) {
        root->right = insert_node(root->right, key);
    }
    // Insere na subárvore esquerda se a chave for menor ou igual
    else {
        root->left = insert_node(root->left, key);
    }
    return root;
}

// Estrutura de Fila para a impressão por nível
typedef struct QueueNode {
    TreeNode* tree_node;
    struct QueueNode* next;
} QueueNode;

typedef struct Queue {
    QueueNode *front, *rear;
} Queue;

// Funções da Fila
static Queue* create_queue() {
    Queue* q = (Queue*)malloc(sizeof(Queue));
    q->front = q->rear = NULL;
    return q;
}

static void enqueue(Queue* q, TreeNode* tree_node) {
    QueueNode* temp = (QueueNode*)malloc(sizeof(QueueNode));
    temp->tree_node = tree_node;
    temp->next = NULL;
    if (q->rear == NULL) {
        q->front = q->rear = temp;
        return;
    }
    q->rear->next = temp;
    q->rear = temp;
}

static TreeNode* dequeue(Queue* q) {
    if (q->front == NULL) return NULL;
    QueueNode* temp = q->front;
    TreeNode* tree_node = temp->tree_node;
    q->front = q->front->next;
    if (q->front == NULL) q->rear = NULL;
    free(temp);
    return tree_node;
}


// --- Implementação das Funções da Biblioteca ---

// A) Cria a árvore a partir de uma sequência
TreeNode* create_bst_from_sequence(int count, ...) {
    va_list args;
    va_start(args, count);
    
    TreeNode* root = NULL;
    for (int i = 0; i < count; i++) {
        int value = va_arg(args, int);
        root = insert_node(root, value);
    }
    
    va_end(args);
    return root;
}

// B) Funções para o mínimo
int get_min_value(TreeNode* root) {
    if (root == NULL) return -1; // Indicador de erro
    TreeNode* current = root;
    while (current->left != NULL) {
        current = current->left;
    }
    return current->key;
}

int get_min_level(TreeNode* root) {
    if (root == NULL) return -1;
    TreeNode* current = root;
    int level = 0;
    while (current->left != NULL) {
        current = current->left;
        level++;
    }
    return level;
}

// C) Funções para o máximo
int get_max_value(TreeNode* root) {
    if (root == NULL) return -1;
    TreeNode* current = root;
    while (current->right != NULL) {
        current = current->right;
    }
    return current->key;
}

int get_max_level(TreeNode* root) {
    if (root == NULL) return -1;
    TreeNode* current = root;
    int level = 0;
    while (current->right != NULL) {
        current = current->right;
        level++;
    }
    return level;
}

// D) Imprime a árvore por nível
void print_bst_by_level(TreeNode* root) {
    if (root == NULL) {
        printf("(Árvore vazia)\n");
        return;
    }

    Queue* q = create_queue();
    enqueue(q, root);

    while (q->front != NULL) {
        int level_nodes = 0;
        QueueNode* temp = q->front;
        while(temp != NULL) {
            level_nodes++;
            temp = temp->next;
        }

        if (level_nodes == 0) break;

        // Processa todos os nós do nível atual
        for (int i = 0; i < level_nodes; i++) {
            TreeNode* current = dequeue(q);
            printf("%d ", current->key);

            if (current->left != NULL) enqueue(q, current->left);
            if (current->right != NULL) enqueue(q, current->right);
        }
        printf("\n"); // Nova linha para o próximo nível
    }
    free(q);
}

// Libera a memória da árvore (percurso em pós-ordem)
void free_bst(TreeNode* root) {
    if (root == NULL) return;
    free_bst(root->left);
    free_bst(root->right);
    free(root);
}
