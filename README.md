# workspace
linux-lab or BiscuitOS workspace

#### Step 1
You need move `workspace` directory under the kernel source code directory.

#### Step 2
~# sudo ln -s $(pwd)/linux_stable/driver/biscuitos   $(pwd)/../driver/biscuitos

#### Step 3
* 1. add `source "drivers/biscuitos/Kconfig"` in `driver/Kconfig` file.
* 2. add `obj-$(CONFIG_BISCUITOS) 	+= biscuitos/` in `driver/Makefile` file.

#### Step final
Normal compile kernel, please see ../README.md
