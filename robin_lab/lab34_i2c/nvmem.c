#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <stdbool.h>
#include <linux/input.h>

#define FILE_PATH "/sys/bus/nvmem/devices/1-00500/nvmem"

int main()
{
	int fd;
	int size;

	char data[512] = { 0 };
	char r_data[64] = { 0 };
	char *w_data = "Hello World!Good Day!\n";
	fd = open(FILE_PATH, O_RDWR);
	if (fd < 0) {
		printf("Can't open file %s\r\n", FILE_PATH);
		return -1;
	}

	lseek(fd, 0, SEEK_SET);
	write(fd, data, sizeof(data)); //erase eeprom
	lseek(fd, 0, SEEK_SET);
	write(fd, w_data, strlen(w_data));
	lseek(fd, 0, SEEK_SET);
	size = read(fd, r_data, sizeof(r_data));
	printf("read data==%s\n", r_data);
	close(fd);
	return 0;
}
