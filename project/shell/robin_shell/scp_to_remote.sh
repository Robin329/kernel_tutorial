#!/bin/sh

params=$#
index=1
host=${@: -1}
username=renbin.jiang
dir_name=$PWD
function usage() {
    echo
    echo "scp.sh [file] [file] ... [file] [file] [232/234/235/236]"
    echo
}

if [ -z "$2" ];then
    echo "-----------------------"
    usage
fi
echo $dir_name
# set -x
function scp_to_remote_func() {
    for arg in $*
    do
        echo "arg:$arg"
        if [ $index -eq $params ];then
            echo "== Copy end =="
            exit 0
        fi
        echo "host:10.10.11.$host"
        scp -r $arg renbin.jiang@10.10.11.$host:$dir_name
        let index+=1
    done
}


while getopts ":hl:" opt
do
    case $opt in
        h)
        usage
        ;;
        l)
        REMOTE_CMD="ls $dir_name -alh"
        echo "HOST:$username@10.10.11.$host:$dir_name$"
        ssh -t $username@10.10.11.$host $REMOTE_CMD
        exit 0
        ;;
        # ?)
        #  echo "Error input params!!!"
        #  echo -e
        #  exit 1;;
    esac

done

scp_to_remote_func $*