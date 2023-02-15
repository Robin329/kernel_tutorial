
# modify right kernel PATH for your system
HOST=$(shell cat /etc/hostname)
$(shell export ARCH=arm64)
$(shell export CROSS_COMPILE=aarch64-linux-gnu-)
KERNELRELEASE=5.17.0-g615ce4b05b3d
HOST_NAME=$(shell cat /etc/hostname)
$(warning "HOST:${HOST}, HOST_NAME:$(HOST_NAME)")
$(warning "kernel release:$(KERNELRELEASE)")
ifeq ($(HOST),ubuntu)
	ifeq ($(HOST),DESKTOP-QO02B48)
		BASEINCLUDE ?= /home/bst/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux/out
		DESTDIR=/home/bst/workspace/BiscuitOS/hostshare/lib/modules/5.17.0+/
	else
		BASEINCLUDE ?= /home/ubuntu/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux/out
		DESTDIR=/home/ubuntu/workspace/BiscuitOS/hostshare/lib/modules/5.15.0+/
	endif
else
   ifeq ($(HOST_NAME),rock-5b)
        # BASEINCLUDE ?=  /usr/src/linux-headers-$(shell uname -r)/
        # /lib/modules/$(shell uname -r)/build
		BASEINCLUDE ?= /home/rock/workspace/rk3399-roc-pc/out
        DESTDIR=/home/rock/nfs_rootfs/lib/modules/$(KERNELRELEASE)/kernel/
	else
    	BASEINCLUDE ?= /home/robin/workspace/project/rk3399/rk3399-roc-pc/out
        DESTDIR=/home/robin/nfs_rootfs/lib/modules/5.17.0-g18a8639f6726-dirty/kernel/
	endif
endif

obj-m	+=   bidirect_list.o

all :
	$(MAKE) -C $(BASEINCLUDE) M=$(PWD) modules

install: all
	install -v bidirect_list.ko $(DESTDIR)
clean:
	@rm -rf *.ko *.o *.mod.o *.mod.c *.symvers *.order \
               .*.o.cmd .tmp_versions *.ko.cmd .*.ko.cmd *.mod


