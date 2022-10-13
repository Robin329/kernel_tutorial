#!/bin/sh
# rsync -av $1

params=$#
index=1
host=${@: -1}
dir_name=$PWD
username=renbin.jiang
function usage() {
    echo
    echo "rsync.sh [dir] [file] ... [file] [file] [232/234/235/236]"
    echo
}


if [ -z "$2" ];then
    echo "-----------------------"
    usage
fi

echo "Need sync dir:$dir_name"



function rsync_cur_dir_func() {
    for arg in $*
    do
        if [ $index -eq $params ];then
            echo "== Copy end =="
            exit 0
        fi
        echo "host:10.10.11.$host"
        rsync -av $username@10.10.11.$host:$dir_name/$arg .
        let index+=1
    done
}


while getopts ":hlcd:" opt
do
    case $opt in
        h)
        usage
        ;;
        c)
        rsync_cur_dir_func $*
        ;;
        d)
        DIR=$OPTARG
        echo "DIR:$OPTARG"
        rsync -av $username@10.10.11.$host:$DIR .
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
         exit 1;;
    esac

done

