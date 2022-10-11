#!/bin/sh
#
# Monitor ZeBu usage.
#

IP=("10.10.11.232" "10.10.11.233" "10.10.11.234" "10.10.11.235" "10.10.11.236")
USER=renbin.jiang
REMOTE_CMD="ps -aux |grep zRci"

function usage() {
    echo
    echo "monitor.sh [option]:"
    echo "             -a: print all users."
    echo "             -l: list dst server current directory contents."
    echo "             -h: print help information."
    echo "             -u [name]: specific user."
    echo
}

function monitor_func() {
for ip in ${IP[*]}
    do
        echo -e "------------------------------------------"
        echo -e "\033[31m HOST $ip \033[0m"
        ssh -t $USER@$ip $REMOTE_CMD
        echo -e "------------------------------------------"
    done
}


while getopts ":hal:u:" opt
do
    case $opt in
        h)
        usage
        ;;
        l)
        for ip in ${IP[*]}
        do
            REMOTE_CMD="ls $dir_name -alh"
            echo -e "\033[31m HOST:$USER@$ip:$dir_name\033[0m"
            ssh -t $USER@$ip $REMOTE_CMD
        done
        exit 0
        ;;
        a)
        monitor_func $*
        ;;
        u)
        for ip in ${IP[*]}
        do
            REMOTE_CMD="ps -aux |grep $OPTARG|grep zRci"
            echo -e "\033[31m HOST:$USER@$ip:$dir_name\033[0m"
            ssh -t $USER@$ip $REMOTE_CMD
        done
        exit 0
        ;;
        ?)
         echo "Error input params!!!"
         echo -e
         exit 1;;
    esac

done
usage