#!/bin/bash

# Build system.
#
# (C) 2022.03.31 BiscuitOS <buddy.zhang@aliyun.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.

## boot from pflash, for the image offset, see tools/uboot/images.sh
function _size16b() {
	size=$1
	echo -n 0x$(echo "obase=16;$size" | bc)
}
function _size16b_m() {
	size=$1
	echo $(_size16b $((size * 1024 * 1024)))
}

HOST_NAME=$(ls /home/)
ROOT=/home/$HOST_NAME/workspace/BiscuitOS/output/linux-newest-arm64
QEMUT=/home/$HOST_NAME/workspace/BiscuitOS/output/linux-newest-arm64/qemu-system/qemu-system/aarch64-softmmu/qemu-system-aarch64
ARCH=arm64
BUSYBOX=/home/$HOST_NAME/workspace/BiscuitOS/output/linux-newest-arm64/busybox/busybox
OUTPUT=/home/$HOST_NAME/workspace/BiscuitOS/output/linux-newest-arm64
ROOTFS_NAME=ext4
CROSS_COMPILE=aarch64-linux-gnu
FS_TYPE=ext4
FS_TYPE_TOOLS=mkfs.ext4
ROOTFS_SIZE=150
FREEZE_SIZE=512
DL=/home/$HOST_NAME/workspace/BiscuitOS/dl
DEBIAN_PACKAGE=buster-base-arm64.tar.gz.N.bsp
RAM_SIZE=512
LINUX_DIR=${ROOT}/linux/linux/out/arch
HOSTSHARE=/home/$HOST_NAME/workspace/BiscuitOS/hostshare
NET_CFG=${ROOT}/package/networking
ROUTE=$(ifconfig | awk '{print $2}' | sed -n '2p')
CMDLINE="earlycon root=/dev/vda rw rootfstype=${FS_TYPE} console=ttyAMA0 init=/linuxrc loglevel=8 route=192.168.88.136 iface=eth0 rw fsck.repair=yes  rootwait sharetag=hostshare sharedir=/hostshare"

#------------------------------------------------------
U_ROOT_IMAGE=/home/ubuntu/workspace/BiscuitOS/output/linux-newest-arm64/buildroot-master/output/images
ROOT_IMAGE=${U_ROOT_IMAGE}
DTB_IMAGE=${LINUX_DIR}/${ARCH}/boot/dts/qemu/qemu_virt.dtb
KERNEL_IMAGE=${LINUX_DIR}/${ARCH}/boot/Image
IMAGES_DIR=${ROOT}
PFLASH_IMG=${ROOT}/pflash.img
SD_IMG=${ROOT}/sd.img
ENV_IMG=${ROOT}/env.img
# Get DRAM start & size via `bdinfo`
KRN_ADDR="0x40400000"
KRN_SIZE=20
RDK_ADDR="-"
RDK_SIZE=6
DTB_ADDR="0x40000000"
DTB_SIZE=2
PFLASH_SIZE=64
BOOTDEV=flash
# Boot images from pflash
##
## cp 0x40000000 0x60003000 0x500000;
## cp 0x40500000 0x60900000 0x400000;
## cp 0x40900000 0x60500000 0x100000;
##
# get FLASH info from `flinfo`: 64M pflash0@0x00000000, 64M pflash1@0x04000000
# The first one is used for -bios, the second one for environment, dtb and ramdisk if required
PFLASH_BASE="0x4000000"
PFLASH_SIZE=64
PFLASH_BS=512
# Environment Offset, see CONFIG_ENV_OFFSET in $UCONFIG
ENV_OFFSET=0
ENV_SIZE=1
ENVDEV=pflash
if [ "${ENV_DEV}" = "flash" ]; then
	ENV_ADDR=0x4000000
else
	ENV_ADDR=0x49000000
fi
# Get the real address if not specified
[ -z "$ENV_ADDR" ] && ENV_ADDR=$(_size16b $(($PFLASH_BASE + $ENV_OFFSET)))

[ -z "$ENV_SIZE" ] && ENV_SIZE=0
_ENV_SIZE=$(_size16b_m $ENV_SIZE)
_KRN_SIZE=$(_size16b_m $KRN_SIZE)
_RDK_SIZE=$(_size16b_m $RDK_SIZE)
_DTB_SIZE=$(_size16b_m $DTB_SIZE)

echo "_ENV_SIZE:${_ENV_SIZE}"
echo "_KRN_SIZE:${_KRN_SIZE}"
echo "_RDK_SIZE:${_RDK_SIZE}"
echo "_DTB_SIZE:${_DTB_SIZE}"

KERNEL_BASE=$(_size16b $(($PFLASH_BASE + $_ENV_SIZE)))
RAMDISK_BASE=$(_size16b $(($PFLASH_BASE + $_ENV_SIZE + $_KRN_SIZE)))
DTB_BASE=$(_size16b $(($PFLASH_BASE + $_ENV_SIZE + $_KRN_SIZE + $_RDK_SIZE)))

BOOTARGS="setenv bootargs '${CMDLINE}';"

BOOTX=booti
[ "$DTB_ADDR" == "-" ] && DTB_ADDR=""
BOOTM="$BOOTX $KRN_ADDR $RDK_ADDR $DTB_ADDR"

PFLOAD_KERNEL="cp $KERNEL_BASE $KRN_ADDR $_KRN_SIZE;"
[ "$RDK_ADDR" != "-" ] && PFLOAD_RAMDISK="cp $RAMDISK_BASE $RDK_ADDR $_RDK_SIZE;"
[ "$DTB_ADDR" != "-" ] && PFLOAD_DTB="cp $DTB_BASE $DTB_ADDR $_DTB_SIZE;"
PFLOADS="$PFLOAD_KERNEL $PFLOAD_RAMDISK $PFLOAD_DTB"
BOOT_PFLASH="$BOOTARGS $PFLOADS  $BOOTM"
boot_cmd=$BOOT_PFLASH

do_ubootimg() {
	if [ "${BOOTDEV}" == "pflash" -o "${BOOTDEV}" == "flash" ]; then
		echo "** U-BOOT img **"
		[ -f $PFLASH_IMG ] && rm -rf $PFLASH_IMG

		truncate -s $(($PFLASH_SIZE * 1024))K $PFLASH_IMG

		# Save env to the last 1M of pflash
		if [ -n "$ENV_IMG" ]; then
			truncate -s 1M $ENV_IMG
			echo "boot_cmd: $boot_cmd"
			echo -e -n "bootcmdx=${boot_cmd}\0" >$ENV_IMG
			hexdump -C $ENV_IMG
			[ ! -f $PFLASH_IMG ] && truncate -s $(($PFLASH_SIZE * 1024))K $PFLASH_IMG
			dd if=$ENV_IMG of=$PFLASH_IMG bs=1M seek=$ENV_OFFSET conv=notrunc status=none
		fi

		[ -n "$KERNEL_IMAGE" -a -f "$KERNEL_IMAGE" ] && dd if=$KERNEL_IMAGE of=$PFLASH_IMG status=none seek=$(($ENV_SIZE * 1024 / $PFLASH_BS)) conv=notrunc bs=${PFLASH_BS}K
		echo "kernel image seek:$(($ENV_SIZE * 1024 / $PFLASH_BS))"
		echo "KERNEL_IMAGE:${KERNEL_IMAGE} DTB_IMAGE:${DTB_IMAGE}"

		[ -n "$DTB_IMAGE" -a -f "$DTB_IMAGE" ] && dd if=$DTB_IMAGE of=$PFLASH_IMG status=none conv=notrunc seek=$((($ENV_SIZE + $KRN_SIZE) * 1024 / $PFLASH_BS)) bs=${PFLASH_BS}K
		echo "dtb seek:$((($ENV_SIZE + $KRN_SIZE) * 1024 / $PFLASH_BS))"

		sync
	fi

}
#------------------------------------------------------

do_running() {
	SUPPORT_DEBUG=N
	SUPPORT_NET=N
	set -x
	[ ${1}X = "debug"X -o ${2}X = "debug"X ] && ARGS+="-s -S "
	if [ ${1}X = "net"X -o ${2}X = "net"X ]; then
		ARGS+="-net tap "
		ARGS+="-device virtio-net-device,netdev=bsnet0,"
		ARGS+="mac=E0:FE:D0:3C:2E:EE "
		ARGS+="-netdev tap,id=bsnet0,ifname=bsTap0 "
	fi
	if [ ${1}X = "uboot"X ]; then
		# Load pflash for booting with uboot every time
		# pflash is at least used as the env storage
		# unit=1 means the second pflash, the first one is unit=0
		KERNEL_BOOT=" -bios /home/ubuntu/workspace/BiscuitOS/output/BiscuitOS-uboot/u-boot/u-boot/u-boot.bin -device loader,file=${ENV_IMG},addr=0x49000000 -drive if=pflash,file=${PFLASH_IMG},format=raw,unit=1 -drive if=none,file=${ROOT_IMAGE}/rootfs.ext4,format=raw,id=virtio-vda -device virtio-blk-device,drive=virtio-vda "
		APPEND=
		U_CMDLINE=
		sudo ${QEMUT} ${ARGS} \
			-M virt \
			-m ${RAM_SIZE}M \
			-cpu cortex-a57 \
			-smp 2 \
			${KERNEL_BOOT} ${APPEND} ${U_CMDLINE} \
			-nographic \
			-fsdev local,path=${HOSTSHARE},security_model=passthrough,id=fsdev0 -device virtio-9p-device,fsdev=fsdev0,mount_tag=hostshare
	else
		KERNEL_BOOT=" -kernel ${KERNEL_IMAGE} -dtb ${DTB_IMAGE} -device virtio-blk-device,drive=hd1 -drive if=none,file=${ROOT}/Freeze.img,format=raw,id=hd1 -device virtio-blk-device,drive=hd0 -drive if=none,file=${ROOT}/BiscuitOS.img,format=raw,id=hd0 "

		U_CMDLINE=${CMDLINE}
		APPEND="-append"
		sudo ${QEMUT} ${ARGS} \
			-M virt \
			-m ${RAM_SIZE}M \
			-cpu cortex-a57 \
			-smp 2 \
			${KERNEL_BOOT} ${APPEND} "${U_CMDLINE}" \
			-nographic \
			-fsdev local,path=${HOSTSHARE},security_model=passthrough,id=fsdev0 -device virtio-9p-device,fsdev=fsdev0,mount_tag=hostshare
	fi

}

do_package() {
	sudo cp ${BUSYBOX}/_install/* ${OUTPUT}/rootfs/${ROOTFS_NAME} -raf
	sudo chown root.root ${OUTPUT}/rootfs/${ROOTFS_NAME}/* -R
	dd if=/dev/zero of=${OUTPUT}/rootfs/ramdisk bs=1M count=${ROOTFS_SIZE}
	${FS_TYPE_TOOLS} -E lazy_itable_init=1,lazy_journal_init=1 -F ${OUTPUT}/rootfs/ramdisk
	mkdir -p ${OUTPUT}/rootfs/tmpfs
	sudo mount -t ${FS_TYPE} ${OUTPUT}/rootfs/ramdisk \
		${OUTPUT}/rootfs/tmpfs/ -o loop
	sudo cp -raf ${OUTPUT}/rootfs/${ROOTFS_NAME}/* ${OUTPUT}/rootfs/tmpfs/
	sudo umount ${OUTPUT}/rootfs/tmpfs
	mv ${OUTPUT}/rootfs/ramdisk ${OUTPUT}/BiscuitOS.img
	rm -rf ${OUTPUT}/rootfs/tmpfs
}

do_mount() {
	mkdir -p ${ROOT}/FreezeDir
	mountpoint -q ${ROOT}/FreezeDir
	[ $? = 0 ] && echo "FreezeDir has mount!" && exit 0
	## Mount Image
	sudo mount -t ${FS_TYPE} ${ROOT}/Freeze.img ${ROOT}/FreezeDir -o loop >>/dev/null 2>&1
	sudo chown ${USER}.${USER} -R ${ROOT}/FreezeDir
	echo "=============================================="
	echo "FreezeDisk: ${ROOT}/Freeze.img"
	echo "MountDiret: ${ROOT}/FreezeDir"
	echo "=============================================="
}

do_umount() {
	mountpoint -q ${ROOT}/FreezeDir
	[ $? = 1 ] && return 0
	sudo umount ${ROOT}/FreezeDir >/dev/null 2>&1
}

# Lunching BiscuitOS
case $1 in
"pack")
	# Package BiscuitOS.img
	do_package
	;;
"debug")
	# Debugging BiscuitOS
	do_umount
	do_running debug
	;;
"net")
	# Establish Netwroking
	sudo ${NET_CFG}/bridge.sh
	sudo cp -rf ${NET_CFG}/qemu-ifup /etc
	sudo cp -rf ${NET_CFG}/qemu-ifdown /etc
	do_umount
	do_running net
	;;
"mount")
	# Mount Freeze Disk
	do_mount
	;;
"umount")
	# Umount Freeze Disk
	do_umount
	;;
*)
	# Default Running BiscuitOS
	if [ "$1" = "uboot" ]; then
		do_ubootimg
	fi
	do_umount
	do_running $1 $2
	;;
esac
