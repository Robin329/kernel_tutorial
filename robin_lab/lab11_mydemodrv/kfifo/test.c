// SPDX-License-Identifier: GPL-2.0-only
/* 
 * Copyright (C) 2020 Jiang Robin <jiangrenbin329@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

//#define CONFIG_PID_DEBUG
#define LOG(fmt, args...) \
	printf("[%s]:%d: " fmt "\n", __func__, __LINE__, ##args)

#define DEMO_DEV_NAME "/dev/robin_demodrv"

int main(int argc, char **argv)
{
	char *buffer;
	int fd, ret, pid;
	size_t len, len_plus;
	char message[] = "Testing the virtual FIFO device";
	char fork_message[] = "Fork message";
	char *read_buffer, *read_buffer_plus;

	len = sizeof(message);
	len_plus = sizeof(fork_message);
	/* Available self PID */
	LOG("Self pid is [%d]\n", getpid());
	pid = fork();
	if (pid < 0) {
		LOG("[F]Fork FAILED!\n");
		return pid;
	}
	LOG("New Fork Pid = [%d], fork message = [%s]\n", pid, fork_message);
	if (pid == 0) {
		fd = open(DEMO_DEV_NAME, O_RDWR);
		if (fd < 0) {
			LOG("[F]Open device %s failed\n", DEMO_DEV_NAME);
		return -1;
	}
		LOG("[F] pid is [%d]\n", getpid());
/* 		ret = write(fd, fork_message, len_plus);
		if (ret != len_plus) {
			LOG("[F]Cannot write on device [%d], ret = %d\n", fd, ret);
			return -1;
		} */

		LOG("[F]fd = [%d] len [%ld]\n", fd, len_plus);
		read_buffer_plus = malloc(2 * len_plus);
		memset(read_buffer_plus, 0, 2 * len_plus);

		ret = read(fd, read_buffer_plus, 2 * len_plus);
		LOG("[F]Read %d bytes\n", ret);
		LOG("[F]Read buffer = %s\n", read_buffer_plus);

		close(fd);
		LOG("[F]Close fd[%d] and EXIT\n", fd);
		return 0;
	}
#ifdef CONFIG_PID_DEBUG
	fd = open(DEMO_DEV_NAME, O_RDWR);
	if (fd < 0) {
		LOG("Open device %s failed\n", DEMO_DEV_NAME);
		return -1;
	}

	/* 1. Write the message to device. */
	ret = write(fd, message, len);
	// ret = fwrite(fd, message, len);
	LOG("fd = [%d] len [%ld]\n", fd, len);
	if (ret != len) {
		LOG("Cannot write on device %d, ret = %d\n", fd, ret);
		return -1;
	}

	read_buffer = malloc(2 * len);
	memset(read_buffer, 0, 2 * len);

	ret = read(fd, read_buffer, 2 * len);
	LOG("Read %d bytes\n", ret);
	LOG("Read buffer = %s\n", read_buffer);

	close(fd);
#endif
	return 0;
}
