
# modify right kernel PATH for your system
HOST=$(shell ls /home/)
$(warning "HOST NAME:${HOST}")
$(warning "kernel release:$(KERNELRELEASE)")
$(warning "find str:$(findstring rk3399, $(PWD))")
ifeq ($(findstring rk3399, $(PWD)),)
    BASEINCLUDE ?= /home/$(HOST)/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux/out
	DESTDIR=/home/$(HOST)/workspace/BiscuitOS/hostshare/lib/modules/5.15.0+/
else
    BASEINCLUDE ?= /home/robin/workspace/project/rk3399/rk3399-roc-pc/out
	DESTDIR=/home/robin/nfs_rootfs/lib/modules/5.17.0-g18a8639f6726-dirty/kernel/
endif

obj-m	+= kobject_create_demo.o
obj-m	+= kobject_get_demo.o
obj-m   += kobject_sysfs_init.o

all :
	$(MAKE) -C $(BASEINCLUDE) M=$(PWD) modules;

install: all
	install -v kobject_create_demo.ko $(DESTDIR)
	install -v kobject_get_demo.ko $(DESTDIR)
	install -v kobject_sysfs_init.ko $(DESTDIR)
clean:
	@rm -rf *.ko *.o *.mod.o *.mod.c *.symvers *.order \
               .*.o.cmd .tmp_versions *.ko.cmd .*.ko.cmd *.mod


