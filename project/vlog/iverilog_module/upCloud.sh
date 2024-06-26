#!/usr/bin/env bash
#UFUNCTION=自动同步当前项目至gitee仓库
pwd
git status
git add .
    
if [ $# -gt 0 ];then
    git commit -m "$*"
else
    dat=$(date +%Y/%m/%d\ %H:%M:%S)
    git commit -m "$dat"
fi
git status
git push gitee master
