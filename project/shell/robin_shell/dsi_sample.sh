#!/bin/sh

INPUT_FILE=$1
OUTPUT_FILE=$2


function usage() {
    echo -e
    echo "------------------------------------------------"

    echo "extract_file.sh [input file] [output file]"

    echo "------------------------------------------------"
    echo -e
}


sample_num=1
if [ ! -z $INPUT_FILE ];then

# cat $INPUT_FILE | grep -wn "Pixel" | awk '{print $7,$12}' > ./.pixel_point
    echo -e
    echo "==== Begain Extract Data ==== "
    cat $INPUT_FILE |grep -wn "Data sample received"|awk '{print $10}' > $OUTPUT_FILE
else
 echo "Usage:"
    usage

fi
