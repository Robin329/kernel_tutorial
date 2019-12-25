/*
 * =====================================================================================
 *
 *       Filename:  gdb_demo.c
 *
 *    Description: GDB test demo. 
 *
 *        Version:  1.0
 *        Created:  2019年11月28日 14时23分33秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  jiangrenbin (), 
 *   Organization:  
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <stdlib.h>

void swapper(int *a, int *b)
{
	int c = *a;
	*a = *b;
	*b = c;
	printf("swapped!\n");
}

int main(int argc, char * argv[])
{
	int i = 4, j = 6;
	printf("i = %d, j = %d\n", i, j);
	swapper(&i, &j);
	printf("After swapped ===>>\n");
	printf("i = %d, j = %d\n", i, j);
	int n = 65535;

	while (n--)
		printf("n: %d\n", n);

	printf("finish\n");

	return 0;
}
