#!/bin/bash

INPUT_FILE=$1
CLANGD_FILE=.clangd

if [ -z $INPUT_FILE ];then
    echo -e "Please input param!!(filename)"
    exit 0
fi

if [ -z $CLANGD_FILE ];then
    echo -e ".clangd not exits, will create .clangd file!"
    echo "$(pwd)"
    touch $(pwd)/.clangd
fi

# remove autoconf.h 1~6 line
# sed -i '1,6d' $1
echo "CompileFlags:                     # Tweak the parse settings" > $CLANGD_FILE
echo "  Add: [" >> $CLANGD_FILE

count=1
while read line; do
# set -x
    result=`echo $line | grep "define"`
    if [ "$result" = "" ];then
        sed -i '1d' $INPUT_FILE
        continue
    fi
    # set +x
    result=`echo ${line/\#define\ /\-D}`
    result=`echo ${result/\ /\=} | tr "\n" ", "`
    echo $result >> $CLANGD_FILE
    count=$(expr $count + 1)
done < $1

echo "     ]" >> $CLANGD_FILE