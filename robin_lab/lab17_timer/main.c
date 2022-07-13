#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define DEV_NAME "/dev/etx_device"

int main(int argc, char **argv) {
    int fd = open(DEV_NAME, O_RDWR);
    int ret = 0;
    char *read_buffer;
    char message[] = "Testing the virtual device";
    if (fd < 0) {
        printf("open %s ERROR\n", DEV_NAME);
        return -1;
    }

    ret = write(fd, message, sizeof(message));
    if (ret < 0)  {
        printf("write %s ERROR\n", DEV_NAME);
        return -1;
    }
    read_buffer = malloc(2 * sizeof(message));
    memset(read_buffer, 0, 2 * sizeof(message));
    ret = read(fd, read_buffer, sizeof(message) * 2);
    if (ret < 0) {
        printf("read %s ERROR\n", DEV_NAME);
        return -1;
    }
    printf("read buffer --> %s\n", read_buffer);
    close(fd);
    return 0;
}
