#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <malloc.h>
#include <sys/ioctl.h>
#include <string.h>
#include <linux/i2c.h>
#include <linux/i2c-dev.h>

#define SLAVE_ADDRESS 0x50
#define I2C_WRITE_FLAG 0x00
#define I2C_READ_FLAG 0x01

#define USAGE "xxx -r address length\nxxx -w address data1 data2...\n"

void i2c_write_bytes(int fd, unsigned char address, unsigned char *data,
		     unsigned short len)
{
	struct i2c_rdwr_ioctl_data e2prom_write_data;
	int ret;

	e2prom_write_data.nmsgs = 1;
	e2prom_write_data.msgs =
		malloc(sizeof(struct i2c_msg) * e2prom_write_data.nmsgs);

	e2prom_write_data.msgs[0].addr = SLAVE_ADDRESS;
	e2prom_write_data.msgs[0].flags = I2C_WRITE_FLAG;
	e2prom_write_data.msgs[0].len = len + 1; //address datap
	e2prom_write_data.msgs[0].buf = malloc(e2prom_write_data.msgs[0].len);

	e2prom_write_data.msgs[0].buf[0] = address;

	memcpy(&(e2prom_write_data.msgs[0].buf[1]), data, (size_t)len);

again:
	// Using ioctl to write data
	ret = ioctl(fd, I2C_RDWR, (unsigned long)&e2prom_write_data);
	if (ret < 0)
			goto again;
	printf("Write data success, ret:%d\n", ret);

	if (e2prom_write_data.msgs != NULL) {
		free(e2prom_write_data.msgs);
		e2prom_write_data.msgs = NULL;
	}
}

void i2c_read_bytes(int fd, unsigned char address, unsigned char *buf,
		    unsigned short len)
{
	struct i2c_rdwr_ioctl_data e2prom_read_data;
	int ret;

	e2prom_read_data.nmsgs = 2; //Need writing address first, then reading
	e2prom_read_data.msgs =
		malloc(sizeof(struct i2c_msg) * e2prom_read_data.nmsgs);

	e2prom_read_data.msgs[0].addr = SLAVE_ADDRESS;
	e2prom_read_data.msgs[0].flags = I2C_WRITE_FLAG;
	e2prom_read_data.msgs[0].len = 1;
	e2prom_read_data.msgs[0].buf = malloc(e2prom_read_data.msgs[0].len);

	e2prom_read_data.msgs[0].buf[0] = address;

	e2prom_read_data.msgs[1].addr = SLAVE_ADDRESS;
	e2prom_read_data.msgs[1].flags = I2C_READ_FLAG;
	e2prom_read_data.msgs[1].len = len;
	e2prom_read_data.msgs[1].buf = malloc(e2prom_read_data.msgs[0].len);
	e2prom_read_data.msgs[1].buf[0] = 0x00;
again:
	// Using ioctl to read data
	ret = ioctl(fd, I2C_RDWR, (unsigned long)&e2prom_read_data);
	if (ret < 0)
		goto again;

	printf("e2prom_read_data.msgs[1].buf[0] = 0x%x, ret:%d\n",
	       e2prom_read_data.msgs[1].buf[0], ret);

	memcpy((void *)buf, (void *)(e2prom_read_data.msgs[1].buf),
	       (unsigned int)len);

	if (e2prom_read_data.msgs != NULL) {
		free(e2prom_read_data.msgs);
		e2prom_read_data.msgs = NULL;
	}
}

int main(int argc, char *argv[])
{
	int opt;
	int fd = -1;

	unsigned char address;
	unsigned short len = 0, i = 0;
	unsigned char buf[256] = { 0 };

	// Open device file
	fd = open("/dev/i2c-6", O_RDWR);
	if (fd < 0) {
		printf("Open file error\n");
		goto Exit;
	}

	while ((opt = getopt(argc, argv, "w:r:")) != -1) {
		switch (opt) {
		case 'w':
			printf("optarg = %s\n", optarg);
			printf("optind = %d\n", optind);
			printf("argc = %d\n", argc);
			printf("argv[optind] = %s\n", argv[optind]);

			address = (unsigned char)strtol(optarg, NULL, 0);
			printf("address = %x\n", address);

			for (len = 0; optind < argc; optind++, len++) {
				buf[len] = (unsigned char)strtol(argv[optind],
								 NULL, 0);
			}

			printf("len = %x\n", len);

			i2c_write_bytes(fd, address, buf, len);

			break;

		case 'r':
			printf("optarg = %s\n", optarg);
			printf("optind = %d\n", optind);
			printf("argv[optind] = %s\n", argv[optind]);

			address = (unsigned char)strtol(optarg, NULL, 0);
			printf("address = 0x%x\n", address);

			len = (unsigned short)strtol(argv[optind], NULL, 0);
			printf("len = 0x%x\n", len);

			i2c_read_bytes(fd, address, buf, len);

			printf("Read content:\n");
			printf("------------------\n");
			for (i = 0; i < len; i++) {
				printf("0x%x ", buf[i]);
			}
			printf("\n------------------\n");
			break;

		default:
			printf("Invalid parameter\n");
			printf(USAGE);
			break;
		}
	}

Exit:
	close(fd);

	return 0;
}