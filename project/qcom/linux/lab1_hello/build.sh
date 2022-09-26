#!/bin/bash
set -e
# rel_path <to> <from>
# Generate relative directory path to reach directory <to> from <from>
function rel_path() {
	local to=$1
	local from=$2
	local path=
	local stem=
	local prevstem=
	[ -n "$to" ] || return 1
	[ -n "$from" ] || return 1
	to=$(readlink -e "$to")
	from=$(readlink -e "$from")
	[ -n "$to" ] || return 1
	[ -n "$from" ] || return 1
	stem=${from}/
	while [ "${to#$stem}" == "${to}" -a "${stem}" != "${prevstem}" ]; do
		prevstem=$stem
		stem=$(readlink -e "${stem}/..")
		[ "${stem%/}" == "${stem}" ] && stem=${stem}/
		path=${path}../
	done
	echo ${path}${to#$stem}
}

export ROOT_DIR=/home/robin/workspace/project/android11_kernel_msm
export MAKE_ARGS=$*
# Save environment parameters before being overwritten by sourcing
# BUILD_CONFIG.
CC_ARG="${CC}"

# ------------------------------------------
# source "${ROOT_DIR}/build/_setup_env.sh"
# ------------------------------------------
ARCH=arm64
BRANCH=android-msm-pixel-4.9
CROSS_COMPILE=aarch64-linux-android-
CROSS_COMPILE_ARM32=arm-linux-androideabi-
EXTRA_CMDS=''
CLANG_PREBUILT_BIN=prebuilts-master/clang/host/linux-x86/clang-r353983c/bin/
LD_LIBRARY_PATH=${ROOT_DIR}/prebuilts-master/clang/host/linux-x86/clang-r353983c/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH
LINUX_GCC_CROSS_COMPILE_PREBUILTS_BIN=prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin
LINUX_GCC_CROSS_COMPILE_ARM32_PREBUILTS_BIN=prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin
LZ4_PREBUILTS_BIN=prebuilts-master/misc/linux-x86/lz4
DTC_PREBUILTS_BIN=prebuilts-master/misc/linux-x86/dtc
LIBUFDT_PREBUILTS_BIN=prebuilts-master/misc/linux-x86/libufdt
CC=clang
CLANG_TRIPLE=aarch64-linux-gnu-
# -------------------------------------------

export CLANG_TRIPLE CROSS_COMPILE CROSS_COMPILE_COMPAT CROSS_COMPILE_ARM32 ARCH SUBARCH MAKE_GOALS

# Restore the previously saved CC argument that might have been overridden by
# the BUILD_CONFIG.
[ -n "${CC_ARG}" ] && CC="${CC_ARG}"

# CC=gcc is effectively a fallback to the default gcc including any target
# triplets. An absolute path (e.g., CC=/usr/bin/gcc) must be specified to use a
# custom compiler.
[ "${CC}" == "gcc" ] && unset CC && unset CC_ARG

TOOL_ARGS=()

if [ -n "${CC}" ]; then
	TOOL_ARGS+=("CC=${CC}" "HOSTCC=${CC}")
fi

if [ -n "${LD}" ]; then
	TOOL_ARGS+=("LD=${LD}")
fi

if [ -n "${NM}" ]; then
	TOOL_ARGS+=("NM=${NM}")
fi

if [ -n "${OBJCOPY}" ]; then
	TOOL_ARGS+=("OBJCOPY=${OBJCOPY}")
fi

# Allow hooks that refer to $CC_LD_ARG to keep working until they can be
# updated.
CC_LD_ARG="${TOOL_ARGS[@]}"
KERNEL_DIR=/home/robin/workspace/project/android11_kernel_msm/out/android-msm-pixel-4.9/private/msm-google
EXT_MODULES=$(pwd)
EXT_MOD_REL=$(rel_path ${EXT_MODULES} ${KERNEL_DIR})
set -x
echo "-----------------"
echo "MAKE_ARGS:${MAKE_ARGS}"
echo "EXT_MOD_REL:${EXT_MOD_REL}"
echo "KERNEL_DIR:${KERNEL_DIR}"
echo "TOOL_ARGS:${TOOL_ARGS}"
echo "-----------------"
make -C ${EXT_MODULES} M=${EXT_MOD_REL} KERNEL_SRC=${KERNEL_DIR} \
	"${TOOL_ARGS[@]}" ${MAKE_ARGS}
set +x
