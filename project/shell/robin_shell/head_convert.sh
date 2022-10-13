#!/bin/sh

WIDTH=$1
HEIGHT=$2
INPUT_FILE=$3
OUTPUT_FILE=$4

function usage() {
    echo -e
    echo "------------------------------------------------"

    echo "extract_file.sh [width] [height] [input file] [output file]"

    echo "------------------------------------------------"
    echo -e
}
# set -x
if [ -z $INPUT_FILE ] || [ -z $WIDTH ] || [ -z $HEIGHT ];then
    echo "Usage:"
    usage
    exit 1
fi

echo -e
echo "input file: $INPUT_FILE"
echo "         W: $WIDTH"
echo "         H: $HEIGHT"
echo -e

START_LINE_NUM=`grep -n "{" $INPUT_FILE | cut -d ":" -f1`
echo "start line num:$START_LINE_NUM"
COUNT=0
OLD_IFS=$IFS
# Maybe change
IFS=", "
li=0
cl=0
while read line
do
    COUNT=$(expr $COUNT + 1)
    # echo "count:$COUNT"
    if [ $COUNT -gt $START_LINE_NUM ];then
        total=0
        # str=`echo $line | awk -F $IFS '{print $2}'`
        str_array=(${line//$IFS/})
        for item in $line
        do

            if [ 4 -gt $total ];then
                pixel=${item:0:8}
                echo  "($li,$cl) = ${pixel}" >> $OUTPUT_FILE
                let li++
                if [ $li -gt $(($WIDTH - 1)) ];then
                    let cl++
                    li=0
                fi
            fi
            let total++
        done

    fi
done < $INPUT_FILE