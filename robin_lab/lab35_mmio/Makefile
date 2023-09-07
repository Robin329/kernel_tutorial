
# modify right kernel PATH for your system
HOST=$(shell cat /etc/hostname)
$(warning "HOST NAME:${HOST}")
$(warning "kernel release:$(KERNELRELEASE)")

BASEINCLUDE ?= /data/workspace/rk3399-roc-pc/build/
DESTDIR=/data/nfs_rootfs/mnt/


obj-m	+=   mmio_addr.o

all :
	$(MAKE) -C $(BASEINCLUDE) M=$(PWD) modules;

install: all
	install -v mmio_addr.ko $(DESTDIR)

clean:
	@rm -rf *.ko *.o *.mod.o *.mod.c *.symvers *.order \
               .*.o.cmd .tmp_versions *.ko.cmd .*.ko.cmd *.mod


