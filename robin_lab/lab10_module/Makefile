
# modify right kernel PATH for your system
BASEINCLUDE ?= /labs/linux-lab/output/aarch64/linux-v5.3.9-virt
#BASEINCLUDE ?= /lib/modules/`uname -r`/build

module_demo-objs := modules.o

obj-m	:=  module_demo.o

ccflags-y	:= -DDEBUG=1

all :
	$(MAKE) -C $(BASEINCLUDE) M=$(PWD) modules;

clean:
	$(MAKE) -C $(BASEINCLUDE) SUBDIRS=$(PWD) clean;
	rm -f *.ko,*.o;
