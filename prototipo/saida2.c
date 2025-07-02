#include <stdio.h>

int soma(int x, int y)
{
	int value;
	value = (x + y);
	return value;
}


int main()
{
	int x = 4;
	int y = 5;
	int resultado;
	resultado = soma(x, y);
	printf("%d\n", resultado);
}

