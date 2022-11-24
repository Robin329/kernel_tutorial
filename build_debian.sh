#!/bin/sh

kernel_build=/home/robin/nfs_rootfs/usr/src/linux/
kernel_out=/home/robin/workspace/project/rk3399/rk3399-roc-pc/out
rootfs_path=$PWD/rootfs_debian_arm64

prepare_rootfs() {
    if [ ! -d $rootfs_path ]; then
			echo "decompressing rootfs..."
			# split -d -b 80m rootfs_debian_arm64.tar.xz -- rootfs_debian_arm64.part
			cat rootfs_debian_arm64.part0* > rootfs_debian_arm64.tar.xz
			tar -Jxf rootfs_debian_arm64.tar.xz
	fi
}


build_kernel_devel() {
    kernver="$(make -s kernelrelease)"
    echo "kernel version: $kernver"

   sudo  rm -rf $kernel_build
   sudo  mkdir -p $kernel_build
   sudo  rm rootfs_debian_arm64/lib/modules/$kernver/build

   sudo cp -a include $kernel_build
   sudo cp Makefile .config Module.symvers System.map vmlinux $kernel_build
   sudo mkdir -p $kernel_build/arch/arm64/
   sudo mkdir -p $kernel_build/arch/arm64/kernel/

    cp -a arch/arm64/include $kernel_build/arch/arm64/
    cp -a arch/arm64/Makefile $kernel_build/arch/arm64/

    # cp from linux-kbuild-5.15 package
    cp -a rootfs_debian_arm64/usr/lib/linux-kbuild-5.15/scripts $kernel_build
    cp -a rootfs_debian_arm64/usr/lib/linux-kbuild-5.15/tools $kernel_build

    cp scripts/module.lds $kernel_build/scripts/

    # link to /lib/modules/xxx/build
    ln -s /usr/src/linux rootfs_debian_arm64/lib/modules/$kernver/build
}
prepare_rootfs
build_kernel_devel
