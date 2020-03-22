#!/bin/sh
#
# set Linux-lab env for Robin
# Version:
#		2020.01.09 add base enviroments with vim .bashrc.
#
# export ARCH=arm64
# export CROSS_COMPILE=aarch64-linux-gnu-
apt update -y
apt upgrade -y
apt install man -y
apt install python3-dev libssl-dev -y
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp -rvf /labs/linux-lab/workspace/configs/.vim ~/
cp -rvf /labs/linux-lab/workspace/configs/.bashrc ~/
cp -rvf /labs/linux-lab/workspace/configs/.vimrc ~/
