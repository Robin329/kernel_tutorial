/*
 * =====================================================================================
 *
 *       Filename:  test.c
 *
 *    Description: pahole 
 *
 *        Version:  1.0
 *        Created:  2019年12月20日 15时00分52秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  jiangrenbin (), 
 *   Organization:  
 *
 * =====================================================================================
 */

#include <stdio.h>

struct test {
	char a;
	short b;
};

struct test t[2];

int main(int argc, char *argv[])
{
	int i = 0;
	printf("sizeof struct test is %u\n", sizeof(struct test));
	printf("sizeof struct t[2] is %u\n", sizeof(t));
here:
	i++;
	if (i < 5)
		goto here;
	return 0;
}

