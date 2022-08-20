
# modify right kernel PATH for your system
HOST=$(shell cat /etc/hostname)
$(warning "HOST NAME:${HOST}")
$(warning "kernel release:$(KERNELRELEASE)")
BASEINCLUDE ?= /home/robin/workspace/project/android11_kernel_msm/out/android-msm-pixel-4.9/private/msm-google

obj-m	+=   dsi_ctrl_demo.o

all :
	$(MAKE) -C $(BASEINCLUDE) M=$(PWD) modules;

install: all
	install -v dsi_ctrl_demo.ko $(DESTDIR)

clean:
	@rm -rf *.ko *.o *.mod.o *.mod.c *.symvers *.order \
               .*.o.cmd .tmp_versions *.ko.cmd .*.ko.cmd *.mod


