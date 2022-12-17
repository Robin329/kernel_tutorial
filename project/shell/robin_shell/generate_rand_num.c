#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <time.h>

#define LEN 960

int main(int argc, char **argv)
{
	if (argc < 2) {
		printf("Please input file name!\n");
		return -1;
	}
	printf("File name: %s\n", argv[1]);

	int a, i;
	FILE *fd = fopen(argv[1], "w+");
	if (fd != NULL) {
		fprintf(fd, "0x00000000\n");
		fprintf(fd, "0x0200000b\n");
		fprintf(fd, "0x0300000c\n");
		fprintf(fd, "0x0200000b\n");
		fprintf(fd, "0x24000f17\n");
		fprintf(fd, "0x392e2b3f\n");
		fprintf(fd, "0x332c3d31\n");
		fprintf(fd, "0x01020304\n");
		srand((unsigned)time(NULL));
		for (i = 0; i < LEN; i++) {
			a = rand();
			fprintf(fd, "0x%08x\n", a);
		}
		fclose(fd);
	}
	return 0;
}