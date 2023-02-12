
# modify right kernel PATH for your system
$(warning "kernel release:$(KERNELRELEASE)")
# SRC
kthreadDemo-objs := kthread_demo.o
kthreadPlus-objs := kthread_plus.o
kthreadLed-objs  := kthread_led.o

BSROOT=/home/robin
CROSS_TOOLS=aarch64-linux-gnu-
ARCH=arm64

# Don't Edit
#KERNELDIR=$(BSROOT)/workspace/project/rk3399/rk3399-roc-pc/out
ifeq ($(shell cat /etc/hostname),rock-5b)
	KERNELDIR ?=  /usr/src/linux-headers-$(shell uname -r)/
	# /lib/modules/$(shell uname -r)/build
else
    KERNELDIR ?= /home/robin/workspace/project/rk3399/rk3399-roc-pc/out
endif

# CROSS_COMPILE_PATH=$(BSROOT)/workspace/project/rk3399/ToolChain-6.3.1/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin
# CROSS_COMPILE=$(CROSS_COMPILE_PATH)/$(CROSS_TOOLS)-
INCLUDEDIR=$(KERNELDIR)/include
ARCHINCLUDEDIR=$(KERNELDIR)/arch/$(ARCH)/include
INSTALLDIR=$(BSROOT)/nfs_rootfs/lib/modules/5.17.0-g18a8639f6726-dirty/kernel/

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
obj-m	+=   kthreadDemo.o
obj-m	+=   kthreadPlus.o
obj-m	+=   kthreadLed.o
$(warning "kernel CFLAGS:$(CFLAGS)")
all: $(OBJS)
	make -C $(KERNELDIR) M=$(PWD) ARCH=$(ARCH) \
                CROSS_COMPILE=$(CROSS_COMPILE) modules

install:all
	install -v kthreadDemo.ko $(INSTALLDIR)
	install -v kthreadPlus.ko $(INSTALLDIR)
	install -v kthreadLed.ko $(INSTALLDIR)
clean:
	@rm -rf *.ko *.o *.mod.o *.mod.c *.symvers *.order \
               .*.o.cmd .tmp_versions *.ko.cmd .*.ko.cmd *.mod
