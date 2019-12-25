/*
 * =====================================================================================
 *
 *       Filename:  bio.c
 *
 *    Description: bio demo. 
 *
 *        Version:  1.0
 *        Created:  2019年12月23日 15时32分08秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  jiangrenbin (), 
 *   Organization:  
 *
 * =====================================================================================
 */
#include <unistd.h>
#include <fcntl.h>
 


int main(void)
{
	int fd;
	char buf[4096];

	sleep(30); /* run ./funtion.sh to trace vfs_read of this process */

	fd = open("file", O_RDONLY);
	read(fd, buf, 4096);
	read(fd, buf, 4096);

	return 0;
}