#
# Application Project
#
# (C) 2020.02.02 BuddyZhang1 <buddy.zhang@aliyun.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.

## NDK Configuration
NDKROOT := /home/robin/Android/Sdk/ndk/21.4.7075529
SYSROOT=$(NDKROOT)/platforms/android-30/arch-arm64

TARGET			:= hello_make


## Source Code
SRC			+= hello.cpp

## CFlags
LCFLAGS			+= -DDEBUG -static-libstdc++
## Header
LCFLAGS			+= -I./ -I$(PWD)/include -g -O0

DOT			:=
CROSS_COMPILE := aarch64-linux-android-
CROSS_COMPILE_ARM32 := arm-linux-androideabi-



# Compile
B_AS		= $(CROSS_COMPILE)$(DOT)as
B_LD		= $(CROSS_COMPILE)$(DOT)ld
B_CC		= $(CROSS_COMPILE)$(DOT)gcc
B_CXX		= $(CROSS_COMPILE)$(DOT)g++
B_CPP		= $(CC) -E
B_AR		= $(CROSS_COMPILE)$(DOT)ar
B_NM		= $(CROSS_COMPILE)$(DOT)nm
B_STRIP		= $(CROSS_COMPILE)$(DOT)strip
B_OBJCOPY	= $(CROSS_COMPILE)$(DOT)objcopy
B_OBJDUMP	= $(CROSS_COMPILE)$(DOT)objdump

## Install PATH
ifeq ("$(origin INSPATH)", "command line")
INSTALL_PATH		:= $(INSPATH)
else
INSTALL_PATH		:= ./
endif

all:
	$(B_CXX) $(LCFLAGS) -o $(TARGET) $(SRC)

install:
	@cp -rfa $(TARGET) $(INSTALL_PATH)

clean:
	@rm -rf $(TARGET) *.o
