
# modify right kernel PATH for your system
HOST=$(shell cat /etc/os-release 2>/dev/null | grep ^ID= | cut -d'=' -f2)
$(warning "HOST NAME:${HOST}")
$(warning "kernel release:$(KERNELRELEASE)")
ifeq ($(HOST),ubuntu)
    BASEINCLUDE ?= /home/ubuntu/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux/out
	DESTDIR=/home/ubuntu/workspace/BiscuitOS/hostshare/lib/modules/5.15.0+/
else ifeq ($(HOST),debian)
    BASEINCLUDE ?= /data/workspace/rock5a/kernel/build
	DESTDIR=/data/nfs_rootfs/lib/modules/5.10.160-ga2c6058d51d9-dirty//kernel/
endif

obj-m	+=   timer_demo.o
obj-m	+=   simple_timer_demo.o

all :
	$(MAKE) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -C $(BASEINCLUDE) M=$(PWD) modules;

install: all
	install -v timer_demo.ko $(DESTDIR)
	install -v simple_timer_demo.ko $(DESTDIR)
clean:
	@rm -rf *.ko *.o *.mod.o *.mod.c *.symvers *.order \
               .*.o.cmd .tmp_versions *.ko.cmd .*.ko.cmd *.mod


