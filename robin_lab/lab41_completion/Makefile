
# modify right kernel PATH for your system
HOST=$(shell ls /home/)
$(warning "HOST NAME:${HOST}")
$(warning "kernel release:$(KERNELRELEASE)")
$(warning "find str:$(findstring rk3399, $(PWD))")
ROOT_DIR=
ifneq ($(findstring rock, $(HOST)),)
	ROOT_DIR=/data
else
	ROOT_DIR=$(HOME)
endif
$(warning "ROOT_DIR=$(ROOT_DIR)")
ifeq ($(findstring rk3399, $(PWD)),)
    BASEINCLUDE ?= $(ROOT_DIR)/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux/build
	INCLUDEDIR   = $(ROOT_DIR)/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux/include
	DESTDIR      = $(ROOT_DIR)/workspace/BiscuitOS/hostshare/
else
    BASEINCLUDE ?= $(ROOT_DIR)/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux/out
	INCLUDEDIR   = $(ROOT_DIR)/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux/include
	DESTDIR      = $(ROOT_DIR)/data/nfs_rootfs/mnt/

endif

obj-m	+= completion.o

all:comp install

install: all
	install -v completion.ko $(DESTDIR)

comp:
	$(MAKE) -C $(BASEINCLUDE) M=$(PWD) modules;

ccflags-y += -I$(INCLUDEDIR)




clean:
	@rm -rf *.ko *.o *.mod.o *.mod.c *.symvers *.order \
               .*.o.cmd .tmp_versions *.ko.cmd .*.ko.cmd *.mod
