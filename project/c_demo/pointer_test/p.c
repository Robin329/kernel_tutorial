/*
 * =====================================================================================
 *
 *       Filename:  p.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2019年12月17日 14时48分42秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  jiangrenbin (), 
 *   Organization:  
 *
 * =====================================================================================
 */

#include <stdio.h>

int main(int argc, char * argv[])
{
	int a[5] = {1, 2, 3, 4, 5};
	int *ptr1 = (int *)(&a + 1);
	int *ptr2 = (int *)(a + 1);
	int *ptr3 = (int *)((void *)a + 1);

	printf("(void *)a = %p, &a = %d\n", (void *)a, *a);
	printf("%x, %x, %x \n", ptr1[-1], *ptr2, *ptr3);

	return 0;
}
