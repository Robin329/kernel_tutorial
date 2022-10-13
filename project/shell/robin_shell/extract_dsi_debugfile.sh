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


if [ ! -z $INPUT_FILE ];then
    echo -e
    echo "==== Begain Extract Data ==== "
    cat $INPUT_FILE | grep -wn "Pixel" | awk '{print $7,$12,$13}' > $OUTPUT_FILE
else
 echo "Usage:"
    usage

fi
