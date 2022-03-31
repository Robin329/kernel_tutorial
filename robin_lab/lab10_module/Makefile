
# modify right kernel PATH for your system
BASEINCLUDE ?= /home/ubuntu/workspace/BiscuitOS/output/linux-newest-arm64/linux/linux
#BASEINCLUDE ?= /lib/modules/`uname -r`/build
DESTDIR=/home/ubuntu/workspace/BiscuitOS/hostshare/lib/modules/5.15.0+/

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
