
# modify right kernel PATH for your system
BASEINCLUDE ?= /home/ubuntu/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux
#BASEINCLUDE ?= /labs/linux-lab/output/aarch64/linux-v5.3.9-virt
#BASEINCLUDE ?= /lib/modules/`uname -r`/build
DESTDIR=/home/ubuntu/workspace/BiscuitOS/hostshare/lib/modules/5.15.0+/

mm_info-objs := get_mm_info.o

obj-m	:=   mm_info.o
all :
	$(MAKE) -C $(BASEINCLUDE) M=$(PWD) modules;

install: all
	install -v mm_info.ko $(DESTDIR)
clean:
	$(MAKE) -C $(BASEINCLUDE) SUBDIRS=$(PWD) clean;
	rm -f *.ko;


