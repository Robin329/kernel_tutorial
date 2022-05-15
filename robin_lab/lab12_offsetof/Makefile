#
# BiscuitOS
#
# (C) 2019.10.01 BuddyZhang1 <buddy.zhang@aliyun.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
ifneq ($(KERNELRELEASE),)

# SRC
obj-m	:= core.o

else
BSROOT=/home/robin
CROSS_TOOLS=aarch64-linux-gnu
ARCH=arm64

# Don't Edit
KERNELDIR=$(BSROOT)/workspace/project/rk3399/rk3399-roc-pc/out
CROSS_COMPILE_PATH=$(BSROOT)/workspace/project/rk3399/ToolChain-6.3.1/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin
CROSS_COMPILE=$(CROSS_COMPILE_PATH)/$(CROSS_TOOLS)-
INCLUDEDIR=$(KERNELDIR)/include
ARCHINCLUDEDIR=$(KERNELDIR)/arch/$(ARCH)/include
INSTALLDIR=$(BSROOT)/nfs_rootfs

# Compile
AS		= $(CROSS_COMPILE)as
LD		= $(CROSS_COMPILE)ld
CC		= $(CROSS_COMPILE)gcc
CPP		= $(CC) -E
AR		= $(CROSS_COMPILE)ar
NM		= $(CROSS_COMPILE)nm
STRIP		= $(CROSS_COMPILE)strip
OBJCOPY		= $(CROSS_COMPILE)objcopy
OBJDUMP		= $(CROSS_COMPILE)objdump

# FLAGS
CFLAGS += -I$(INCLUDEDIR) -I$(ARCHINCLUDEDIR)

# Target
obj-m	+= core.o

all: $(OBJS)
	make -C $(KERNELDIR) M=$(PWD) ARCH=$(ARCH) \
                CROSS_COMPILE=$(CROSS_COMPILE) modules

install:
	make -C $(KERNELDIR) M=$(PWD) ARCH=$(ARCH) \
		INSTALL_MOD_PATH=$(INSTALLDIR) modules_install

clean:
	@rm -rf *.ko *.o *.mod.o *.mod.c *.symvers *.order \
               .*.o.cmd .tmp_versions *.ko.cmd .*.ko.cmd

endif
