/*
 * =====================================================================================
 *
 *       Filename:  read.c
 *
 *    Description: page cache test. 
 *
 *        Version:  1.0
 *        Created:  2019年12月17日 14时28分03秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  jiangrenbin (), 
 *   Organization:  
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>

char buf[4096] = {0};

int main(int argc, char *argv[])
{
	int fd;
	if (argc != 2) {

		printf("argument error.\n");
		return -1;
	}

	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {

		perror("open failed:");
		return -1;
	}
	read(fd, buf, 4096);
	printf("buf ==> %s\n", buf);
	close(fd);

}
