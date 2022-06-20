#ifndef __UEVENT_H__
#define __UEVENT_H__
#include <stdbool.h>
#include <sys/socket.h>
#include <linux/netlink.h>
#include <iostream>
#include <stdbool.h>
#include <linux/socket.h>
#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <strings.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include <fcntl.h>
#include <poll.h>

#include <memory>
struct Uevent {
	std::string action;
	std::string path;
	std::string subsystem;
	std::string firmware;
	std::string partition_name;
	std::string device_name;
	std::string modalias;
	int partition_num;
	int major;
	int minor;
};

int uevent_open_socket(int buf_sz, bool passcred);
ssize_t uevent_kernel_multicast_recv(int socket, void *buffer, size_t length);
ssize_t uevent_kernel_multicast_uid_recv(int socket, void *buffer,
					 size_t length, uid_t *uid);
ssize_t uevent_kernel_recv(int socket, void *buffer, size_t length,
			   bool require_group, uid_t *uid);

#endif