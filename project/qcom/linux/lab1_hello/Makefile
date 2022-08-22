# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.

$(warning "kernel release:$(KERNELRELEASE)")

BSROOT=/home/robin
CROSS_TOOLS=aarch64-linux-gnu
ARCH=arm64
# Don't Edit
KERNELDIR=$(BSROOT)/workspace/project/android11_kernel_msm/out/android-msm-pixel-4.9/private/msm-google
CROSS_COMPILE=$(CROSS_TOOLS)-
INCLUDEDIR=$(KERNELDIR)/include
ARCHINCLUDEDIR=$(KERNELDIR)/arch/$(ARCH)/include

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


# Target
obj-m	+= hello.o

all:
	make -C $(KERNELDIR) M=$(PWD) ARCH=$(ARCH) \
                modules

install:
	make -C $(KERNELDIR) M=$(PWD) ARCH=$(ARCH) \
		INSTALL_MOD_PATH=$(INSTALLDIR) modules_install

clean:
	@rm -rf *.ko *.o *.mod.o *.mod.c *.symvers *.order \
               .*.o.cmd .tmp_versions *.ko.cmd .*.ko.cmd *.mod