#!/bin/bash
#
# Start config linux-lab enviroment.
#

set -u
VIM_DIR=/labs/linux-lab/workspace/configs/vim/vim
TOP_DIR=/home/ubuntu
WORK_DIR=/labs/linux-lab/workspace/configs
UP_DIR=/labs/linux-lab/workspace/configs/up
	echo -e "Start copy .vim ..."
	cp -rfa $VIM_DIR/.vim $TOP_DIR/
	echo -e "Start copy .vimrc ..."
	cp -rfa $VIM_DIR/.vimrc $TOP_DIR/
	echo -e
	echo -e "Copy vim env done ..."

echo -e "Start config color host name ..."
PS=`grep PS1 $TOP_DIR/.bashrc`

if [ ! -e $TOP_DIR/.config/up/up.sh ];then
	cp -rf $UP_DIR $TOP_DIR/.config/
fi

cp -raf $WORK_DIR/.bashrc ~/

up=`grep up.sh $TOP_DIR/.bashrc`
echo -e "$up is exit in bashrc ..."

if [ ! -n "$up" ];then
	echo -e "Start config up scripts in bashrc ..."
	echo "source  ~/.config/up/up.sh" >> $TOP_DIR/.bashrc
fi

source ~/.bashrc
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg -i /labs/linux-lab/workspace/tool/fd_7.5.0_amd64.deb
sudo dpkg -i /labs/linux-lab/workspace/tool/ripgrep_12.0.0_amd64.deb
sudo apt-get install man -y
