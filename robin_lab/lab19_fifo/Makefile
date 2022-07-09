
# modify right kernel PATH for your system
HOST=$(shell cat /etc/hostname)
$(warning "HOST NAME:${HOST}")
$(warning "kernel release:$(KERNELRELEASE)")
ifneq ($(HOST),ubuntu)
    BASEINCLUDE ?= /home/ubuntu/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux/out
	DESTDIR=/home/ubuntu/workspace/BiscuitOS/hostshare/lib/modules/5.15.0+/
else
    BASEINCLUDE ?= /home/robin/workspace/project/rk3399/rk3399-roc-pc/out
	DESTDIR=/home/robin/nfs_rootfs/lib/modules/5.17.0-g18a8639f6726-dirty/kernel/
endif

obj-m	+=   kfifo_demo.o

all :
	$(MAKE) -C $(BASEINCLUDE) M=$(PWD) modules;

install: all
	install -v tasklet_demo.ko $(DESTDIR)

clean:
	@rm -rf *.ko *.o *.mod.o *.mod.c *.symvers *.order \
               .*.o.cmd .tmp_versions *.ko.cmd .*.ko.cmd *.mod


