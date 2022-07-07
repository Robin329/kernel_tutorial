
# modify right kernel PATH for your system
$(warning "kernel release:$(KERNELRELEASE)")

ifneq ($(KERNELRELEASE),)
# SRC
obj-m := memory_barrier.o
obj-m := memory_reordering.o

else


CROSS_TOOLS=aarch64-linux-gnu
ARCH=arm64
CROSS_COMPILE=$(CROSS_TOOLS)-

ifeq ($(HOST),ubuntu)
# Don't Edit
BSROOT=/home/robin
KERNELDIR=$(BSROOT)/workspace/project/rk3399/rk3399-roc-pc/out
INSTALLDIR=$(BSROOT)/nfs_rootfs/lib/modules/5.17.0-g18a8639f6726-dirty/kernel/
# CROSS_COMPILE_PATH=$(BSROOT)/workspace/project/rk3399/ToolChain-6.3.1/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin
else
BSROOT=/home/ubuntu
KERNELDIR=$(BSROOT)/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux/out
INSTALLDIR=$(BSROOT)/workspace/BiscuitOS/hostshare/lib/modules/5.15.0+/
endif

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

# FLAGS
CFLAGS += -I$(INCLUDEDIR) -I$(ARCHINCLUDEDIR)

# Target
obj-m	+=   memory-barrier.o
obj-m	+=   memory-reordering.o

$(warning "kernel CFLAGS:$(CFLAGS)")
all: $(OBJS)
	make -C $(KERNELDIR) M=$(PWD) ARCH=$(ARCH) \
                CROSS_COMPILE=$(CROSS_COMPILE) modules

install:all
	install -v memory_barrier.ko $(INSTALLDIR)
	install -v memory_reordering.ko $(INSTALLDIR)

clean:
	@rm -rf *.ko *.o *.mod.o *.mod.c *.symvers *.order \
               .*.o.cmd .tmp_versions *.ko.cmd .*.ko.cmd *.mod

endif