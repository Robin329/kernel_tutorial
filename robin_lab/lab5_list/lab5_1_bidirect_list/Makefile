
# modify right kernel PATH for your system
HOST=$(shell cat /etc/hostname)
$(shell export ARCH=arm64)
$(shell export CROSS_COMPILE=aarch64-linux-gnu-)
$(warning "HOST NAME:${HOST}")
$(warning "kernel release:$(KERNELRELEASE)")
ifneq ($(HOST),ubuntu)
	ifeq ($(HOST),DESKTOP-QO02B48)
		BASEINCLUDE ?= /home/bst/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux/out
		DESTDIR=/home/bst/workspace/BiscuitOS/hostshare/lib/modules/5.17.0+/
	else
		BASEINCLUDE ?= /home/ubuntu/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux/out
		DESTDIR=/home/ubuntu/workspace/BiscuitOS/hostshare/lib/modules/5.15.0+/
	endif
else

endif
ifeq ($(HOST),rock-5b)
	BASEINCLUDE =  /usr/src/linux-headers-$(shell uname -r)/
	# /lib/modules/$(shell uname -r)/build
else
    BASEINCLUDE = /home/robin/workspace/project/rk3399/rk3399-roc-pc/out
	DESTDIR=/home/robin/nfs_rootfs/lib/modules/5.17.0-g18a8639f6726-dirty/kernel/
endif

obj-m	+=   bidirect_list.o

all :
	$(MAKE) -C $(BASEINCLUDE) M=$(PWD) modules

install: all
	install -v bidirect_list.ko $(DESTDIR)
clean:
	@rm -rf *.ko *.o *.mod.o *.mod.c *.symvers *.order \
               .*.o.cmd .tmp_versions *.ko.cmd .*.ko.cmd *.mod


