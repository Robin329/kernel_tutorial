#include "uevent.h"
#include <stdio.h>

#define UEVENT_MSG_LEN 1024

int main(int argc, char *argv[])
{
	int device_fd;
	char msg[UEVENT_MSG_LEN + 2];
	int n;
	int i;

	device_fd = uevent_open_socket(64 * 1024, true);
	if (device_fd < 0)
		return -1;

	while ((n = uevent_kernel_multicast_recv(device_fd, msg,
						 UEVENT_MSG_LEN)) > 0) {
		msg[n] = '\0';
		msg[n + 1] = '\0';

		for (i = 0; i < n; i++)
			if (msg[i] == '\0')
				msg[i] = ' ';

		printf("%s\n", msg);
	}

	return 0;
}
