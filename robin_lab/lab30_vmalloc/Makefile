
# modify right kernel PATH for your system
HOST=$(shell ls /home/)
$(warning "HOST NAME:${HOST}")
$(warning "kernel release:$(KERNELRELEASE)")
$(warning "find str:$(findstring rk3399, $(PWD))")
$(warning "find str:$(findstring pi, $(HOST))")
$(warning "filter str:$(filter pi, $(HOST))")
$(warning "filter-out str:$(filter-out pi, $(HOST))")
ifneq ($(findstring rk3399, $(PWD)),)
    BASEINCLUDE ?= /home/$(HOST)/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux/out
	DESTDIR=/home/$(HOST)/workspace/BiscuitOS/hostshare/lib/modules/5.15.0+/
else
	ifneq ($(filter pi, $(HOST)),)
		BASEINCLUDE ?= /home/pi/workspace/raspberrypi-linux/out
		DESTDIR=/lib/modules/5.17.15-v8+/
	else
		BASEINCLUDE ?= /home/robin/workspace/project/rk3399/rk3399-roc-pc/out
		DESTDIR=/home/robin/nfs_rootfs/lib/modules/5.17.0-g18a8639f6726-dirty/kernel/
	endif
endif
ccflags-y += -O0 -g

obj-m	+= vmalloc_api_demo.o
obj-m   += vmalloc_api_test.o

all :
	$(MAKE) -C $(BASEINCLUDE) M=$(PWD) modules;

install: all
	install -v vmalloc_api_demo.ko $(DESTDIR)
	install -v vmalloc_api_test.ko $(DESTDIR)

clean:
	@rm -rf *.ko *.o *.mod.o *.mod.c *.symvers *.order \
               .*.o.cmd .tmp_versions *.ko.cmd .*.ko.cmd *.mod


