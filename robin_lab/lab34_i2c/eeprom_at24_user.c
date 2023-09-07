#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <linux/i2c-dev.h>
#include <errno.h>
#include <time.h>

//teeprom device value size
#define EEPROM_SIZE 262144
#define PAGE_SIZE 4096
#define EEPROM_PAGES (EEPROM_SIZE / PAGE_SIZE)
int main(int argc, char *argv[])
{
	int num, value;
	int fd, pFile, page_index = 0;
	char *device_name, *buff, *out_buf;
	struct timespec time_0, time_1, time_2;

	printf("Please input as:");
	printf("teeprom device_name value size\n");
	fflush(stdout);

	if (argc < 3) {
		printf("arg error\n");
		return -1;
	}

	device_name = argv[1];
	value = atoi(argv[2]);
	num = atoi(argv[3]);

	buff = calloc(sizeof(char), num);
	if (buff < 0) {
		printf("alloc failed\n");
		return -1;
	}
	memset(buff, value, num);

	out_buf = calloc(sizeof(char), EEPROM_SIZE);

	fd = open(device_name, O_RDWR);
	if (fd < 0) {
		printf("device open failed\n");
		return -1;
	}
	clock_gettime(CLOCK_MONOTONIC, &time_0);
	printf("%8d.%8d Write %d to 0x00 for %d bytes.\n", time_0.tv_sec,
	       time_0.tv_nsec, value, num);
	write(fd, buff, num);

	clock_gettime(CLOCK_MONOTONIC, &time_1);
	printf("%8d.%8d Read from 0x00 for %d bytes.\n", time_1.tv_sec,
	       time_1.tv_nsec, EEPROM_SIZE);
	lseek(fd, 0, SEEK_SET);
	for (page_index = 0; page_index < EEPROM_PAGES; page_index++) {
		read(fd, out_buf, PAGE_SIZE);
	}
	close(fd);

	clock_gettime(CLOCK_MONOTONIC, &time_2);
	printf("%8d.%8d Write to eeprom.bin.\n", time_2.tv_sec, time_2.tv_nsec);
	pFile = fopen("eeprom.bin", "wb");
	if (pFile < 0) {
		printf("device open failed\n");
		return -1;
	}
	fwrite(out_buf, EEPROM_SIZE, 1, pFile);
	fclose(pFile);

	return 0;
}