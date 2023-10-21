
# modify right kernel PATH for your system
HOST=$(shell ls /home/)
$(warning "HOST NAME:${HOST}")
$(warning "kernel release:$(KERNELRELEASE)")
$(warning "find str:$(findstring rk3399, $(PWD))")

    BASEINCLUDE ?= /data/workspace/rk3399-roc-pc/build
	INCLUDEDIR =  /data/workspace/rk3399-roc-pc/include
	DESTDIR=/data/nfs_rootfs/lib/modules/5.17.0-g18a8639f6726-dirty/kernel/


obj-m	+= ssd1306.o

ccflags-y += -I$(INCLUDEDIR)
all :
	$(MAKE) -C $(BASEINCLUDE) M=$(PWD) modules;

install: all
	install -v ssd1306.ko $(DESTDIR)

clean:
	@rm -rf *.ko *.o *.mod.o *.mod.c *.symvers *.order \
               .*.o.cmd .tmp_versions *.ko.cmd .*.ko.cmd *.mod


