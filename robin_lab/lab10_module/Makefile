
# modify right kernel PATH for your system

HOST=$(shell ls /home/)
HOST_NAME=$(shell cat /etc/hostname)
$(warning "HOST:${HOST}, HOST_NAME:$(HOST_NAME)")
ifeq ($(HOST),ubuntu)
    BASEINCLUDE ?= /home/$(HOST)/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux/out
	DESTDIR=/home/$(HOST)/workspace/BiscuitOS/hostshare/lib/modules/5.15.0+/
else
ifeq ($(HOST_NAME),rock-5b)
	BASEINCLUDE ?=  /usr/src/linux-headers-$(shell uname -r)/
	# /lib/modules/$(shell uname -r)/build
else
    BASEINCLUDE ?= /home/robin/workspace/project/rk3399/rk3399-roc-pc/out
	DESTDIR=/home/robin/nfs_rootfs/lib/modules/5.17.0-g18a8639f6726-dirty/kernel/
endif
endif

# BASEINCLUDE ?= /home/ubuntu/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux/out
# #BASEINCLUDE ?= /lib/modules/`uname -r`/build
# DESTDIR=/home/ubuntu/workspace/BiscuitOS/hostshare/lib/modules/5.15.0+/


module_demo-objs := modules.o

obj-m	:=  module_demo.o
ccflags-y	:= -DDEBUG=1

all :
	$(MAKE) -C $(BASEINCLUDE) M=$(PWD) modules;
install: all
	install -v module_demo.ko $(DESTDIR)
clean:
	$(MAKE) -C $(BASEINCLUDE) SUBDIRS=$(PWD) clean;
	rm -f *.ko,*.o;
