ARCH = arm64
CROSS_COMPILE = aarch64-linux-gnu-
# modify right kernel PATH for your system
BASEINCLUDE ?= /labs/linux-lab/output/aarch64/linux-v5.3.9-virt
#BASEINCLUDE ?= /lib/modules/`uname -r`/build

slab_lab-objs := slab.o

obj-m	:= slab_lab.o
all :
	$(MAKE) -C $(BASEINCLUDE) M=$(PWD) modules;

clean:
	$(MAKE) -C $(BASEINCLUDE) SUBDIRS=$(PWD) clean;
	rm -f *.ko;


