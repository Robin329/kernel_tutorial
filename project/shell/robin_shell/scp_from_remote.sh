#!/bin/sh
#
# Sync files from remote server.
#

params=$#
index=1
host=${@: -1}
dir_name=$PWD
username=renbin.jiang
function usage() {
    echo
    echo "scp.sh [file] [file] ... [file] [file] [232/234/235/236]"
    echo "       -l [232/../236] - list target server directory."
    echo "       -h - help information."
    echo "       "
    echo
}

if [ -z "$2" ];then
    echo "-----------------------"
    usage
fi
echo $dir_name
# set -x
function scp_from_remote_func() {
    for arg in $*
    do
        echo "arg:$arg"
        if [ $index -eq $params ];then
            echo "== Copy end =="
            exit 0
        fi
        echo "host:10.10.11.$host"
        scp -r $username@10.10.11.$host:$dir_name/$arg $PWD
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
        ?)
         echo "Error input params!!!"
         echo -e
        ;;
    esac
done

scp_from_remote_func $*