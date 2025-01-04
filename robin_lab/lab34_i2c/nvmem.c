#include <errno.h>
#include <fcntl.h>
#include <linux/input.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define FILE_PATH "/sys/bus/nvmem/devices/6-00501/nvmem"
#define AT24C256_SIZE_BYTE 32768
#define PAGE_SIZE 4096

int main() {
  int fd;
  int size;
  int i, j = 0;
  int count = 0;
  char data[512] = {0};
  char r_data[AT24C256_SIZE_BYTE] = {0};
  // char *w_data = "Hello World!Good Day!\n";
  // char *w_data = "renbin.jiang\n";
  char w_data[AT24C256_SIZE_BYTE] = {0};
  fd = open(FILE_PATH, O_RDWR);
  if (fd < 0) {
    printf("Can't open file %s\r\n", FILE_PATH);
    return -1;
  }
  memset(w_data, 0x1, sizeof(w_data));
  //   lseek(fd, 0, SEEK_SET);
  //   write(fd, data, sizeof(data)); //erase eeprom
  for (i = 0; i < (AT24C256_SIZE_BYTE / PAGE_SIZE); i++) {
    lseek(fd, i * PAGE_SIZE, SEEK_SET);
    write(fd, &w_data[i * PAGE_SIZE], PAGE_SIZE);
  }

  for (j = 0; j < (AT24C256_SIZE_BYTE / PAGE_SIZE); j++) {
    lseek(fd, j * PAGE_SIZE, SEEK_SET);
    size = read(fd, &r_data[j * PAGE_SIZE], PAGE_SIZE);
    for (i = 0; i < size; i++) {
      printf("read data[%d]==%#x\n", i + j * PAGE_SIZE, r_data[i]);
    }
  }
  close(fd);
  return 0;
}
