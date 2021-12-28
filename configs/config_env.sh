#!/bin/bash
#
# Start config linux-lab enviroment.
#

#set -u
#VIM_DIR=/labs/linux-lab/workspace/configs/vim/vim
#TOP_DIR=/home/ubuntu
#WORK_DIR=/labs/linux-lab/workspace/configs
#UP_DIR=/labs/linux-lab/workspace/configs/up
#	echo -e "Start copy .vim ..."
#	cp -rfa $VIM_DIR/.vim $TOP_DIR/
#	echo -e "Start copy .vimrc ..."
#	cp -rfa $VIM_DIR/.vimrc $TOP_DIR/
##	echo -e
#	echo -e "Copy vim env done ..."

#echo -e "Start config color host name ..."
#PS=`grep PS1 $TOP_DIR/.bashrc`

#if [ ! -e $TOP_DIR/.config/up/up.sh ];then
#	cp -rf $UP_DIR $TOP_DIR/.config/
#fi

#cp -raf $WORK_DIR/.bashrc ~/

#up=`grep up.sh $TOP_DIR/.bashrc`
#echo -e "$up is exit in bashrc ..."

#if [ ! -n "$up" ];then
echo -e "Start config up scripts in bashrc ..."
echo "source  ~/.config/up/up.sh" >> $TOP_DIR/.bashrc
echo "source ~/.config/z.sh" >> ~/.bashrc
echo "[ -f ~/.fzf.bash ] && source ~/.fzf.bash" >> ~/.bashrc
#fi

source ~/.bashrc
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install man -y
sudo apt-get install pkg-config fd-find bison libncurses-dev gcc make flex libssl-dev  net-tools ssh  ripgrep  fzf -y
sudo apt-get install -y qemu gcc make gdb git figlet
sudo apt-get install -y libncurses5-dev iasl wget
sudo apt-get install -y device-tree-compiler
sudo apt-get install -y flex bison libssl-dev libglib2.0-dev
sudo apt-get install -y libfdt-dev libpixman-1-dev
sudo apt-get install -y python pkg-config u-boot-tools intltool xsltproc
sudo apt-get install -y gperf libglib2.0-dev libgirepository1.0-dev
sudo apt-get install -y gobject-introspection
sudo apt-get install -y python2.7-dev python-dev bridge-utils
sudo apt-get install -y uml-utilities net-tools
sudo apt-get install -y libattr1-dev libcap-dev
sudo apt-get install -y kpartx libsdl2-dev libsdl1.2-dev
sudo apt-get install -y debootstrap bsdtar
sudo apt-get install -y libelf-dev gcc-multilib g++-multilib
sudo apt-get install -y libcap-ng-dev
sudo apt-get install -y libmount-dev libselinux1-dev libffi-dev libpulse-dev
sudo apt-get install -y liblzma-dev python-serial
sudo apt-get install -y libnuma-dev libnuma1 ninja-build
sudo apt-get install -y libtool libsysfs-dev
git config --global user.name "robin.jiang"
git config --global user.email "jrb1441144759@gmail.com"
