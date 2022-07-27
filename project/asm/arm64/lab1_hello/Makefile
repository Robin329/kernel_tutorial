#
# Assemble Project
#
# (C) 2022.07.29 robin.jiang <jiangrenbin329@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.

## Target
ifeq ("$(origin TARGETA)", "command line")
TARGET			:= $(TARGETA)
else
TARGET			:= hello_world
endif
$(warning "ARCH = $(ARCH)")
## Source Code
SRC			+= hello_world.c

## CFlags
# LCFLAGS			+= -DDEBUG
## Header
# LCFLAGS			+= -I./ -I$(PWD)/include

DOT			:= -
## X86/X64 Architecture
ifeq ($(ARCH), i386)
CROSS_COMPILE	=
LCFLAGS		+= -m32
DOT		:=
else ifeq ($(ARCH), x86_64)
CROSS_COMPILE   :=
DOT		:=
else ifeq ($(ARCH), arm64)
CROSS_COMPILE   := aarch64-linux-gnu
DOT		:= -
endif

# Compile
B_AS		= $(CROSS_COMPILE)$(DOT)as
B_LD		= $(CROSS_COMPILE)$(DOT)ld
B_CC		= $(CROSS_COMPILE)$(DOT)gcc
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

TARGET_A ?= $(TARGET).S
TARGET_P ?= $(TARGET).i
TARGET_O ?= $(TARGET).o

all:
	# $(B_CC) $(LCFLAGS) -o $(TARGET_P) -E $(SRC)
	# $(B_CC) $(LCFLAGS) -o $(TARGET_A) -S $(TARGET_P)
	# $(B_CC) $(LCFLAGS) -o $(TARGET_O) -c $(TARGET_A)
	$(B_CC) $(LCFLAGS) -o $(TARGET) $(SRC)

install:
	@cp -rfa $(TARGET) $(INSTALL_PATH)

clean:
	@rm -rf $(TARGET) *.o
