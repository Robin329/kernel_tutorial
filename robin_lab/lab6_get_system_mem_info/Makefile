
# modify right kernel PATH for your system
HOST=$(shell cat /etc/hostname)
$(warning "HOST NAME:${HOST}")
ifneq ($(HOST),ubuntu)
    BASEINCLUDE ?= /home/ubuntu/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux/out
	DESTDIR=/home/ubuntu/workspace/BiscuitOS/hostshare/lib/modules/5.15.0+/
else
    BASEINCLUDE ?= /home/robin/workspace/project/rk3399/rk3399-roc-pc/out
	DESTDIR=/home/robin/nfs_rootfs/lib/modules/5.17.0-g18a8639f6726-dirty/kernel/
endif
#BASEINCLUDE ?= /labs/linux-lab/output/aarch64/linux-v5.3.9-virt
#BASEINCLUDE ?= /lib/modules/`uname -r`/build

mm_info-objs := get_mm_info.o
mmu_demo-objs := mmu_demo.o

obj-m	+=   mm_info.o
obj-m	+=   mmu_test.o
all :
	$(MAKE) -C $(BASEINCLUDE) M=$(PWD) modules;

install: all
	install -v mm_info.ko $(DESTDIR)
	install -v mmu_demo.ko $(DESTDIR)
clean:
	@rm -rf *.ko *.o *.mod.o *.mod.c *.symvers *.order \
               .*.o.cmd .tmp_versions *.ko.cmd .*.ko.cmd *.mod


