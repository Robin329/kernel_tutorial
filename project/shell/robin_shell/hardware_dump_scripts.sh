#!/bin/bash
#
# MIPI CSITX Hardware dump file analyze
#

DUMP_FILE=$1

OUT_FILE=$2
DT_LINE=10

if [ -z "$OUT_FILE" ]; then
    OUT_FILE=out.txt
fi

function remove_sync_packet() {
    dt=$1
    case $1 in
    00)
        return 0
        ;;
    01) return 0 ;;
    02)
        return 0
        ;;
    03)
        return 0
        ;;
    esac
    return 1
}

count_line=0
data_type=0
WC=0
line_num_total=0
line_num=0
frame_line=0

SAVE_FILE=1

LINE=1280
COLUMN=720

packet=
declear -A one_line_data

echo -e
echo -e "Please input data type:"
echo -e "       1  - rgb24 [0x24]"
echo -e "       2  - rgb30 []"
echo -e "       3  - yuv420 nv12 8b [0x18]"
echo -e "       4  - yuv420 nv12 10b[0x19]"
echo -e "       5  - yuv422 yuyv 8b [0x1E]"
echo -e "       6  - yuv422 yuyv 10b[0x1F]"
echo -e "       7  - raw8   [0x2A]"
echo -e "       8  - raw12  [0x2C]"
echo -e "       9  - raw16  [0x2E]"
echo -e "       10 - raw20  [0x2F]"

read -p "   >" id

function data_type_func() {
    case $1 in
    1)
        data_type=0x24
        ;;
    2)
        data_type=
        ;;

    3)
        data_type=0x18
        ;;

    4)
        data_type=0x19
        ;;

    5) data_type=0x1E ;;

    6) data_type=0x1F ;;
    7) data_type=0x2A ;;
    8) data_type=0x2C ;;
    9) data_type=0x2E ;;
    10) data_type=0x2F ;;
    ?)
        echo "Invalid Input $id"
        ;;
    esac
}

function resolution_func() {
    echo -e
    echo -e "Please select a resolution:"
    echo -e "      0 - 640  x 480"
    echo -e "      1 - 1280 x 720"
    echo -e "      2 - 1920 x 1080"
    echo -e "      3 - 3840 x 2160"
    echo -e "      4 - 4096 x 2160"
    read -p "   >" index
    case "$index" in
    0)
        echo "640  x 480"
        LINE=640
        COLUMN=480
        ;;
    1)
        echo "1280 x 720"
        LINE=1280
        COLUMN=720
        ;;
    2)
        echo "1920 x 1080"
        LINE=1920
        COLUMN=1080
        ;;
    3)
        echo "3840 x 2160"
        LINE=3840
        COLUMN=2160
        ;;
    4)
        echo "4096 x 2160"
        LINE=4096
        COLUMN=2160
        ;;
    esac
}
# update date type
data_type_func $id
# Update resolution
resolution_func

while read line; do
    # if [ $count_line = 7 ]; then
    #     break
    # fi

    # set -x
    if [ $count_line -le $DT_LINE ]; then
        data_type_tmp=${line:2:2}
        remove_sync_packet $data_type_tmp
        if [ $? -eq 0 ]; then
            continue
        fi
        if [ "0x$data_type_tmp" = "$data_type" ]; then
            wordcount=${line:6:2}
            wordcount=0x$wordcount${line:4:2}
            WC=$(printf %d $wordcount)
            line_num_total=$(expr $WC / 4)
            continue
        fi
    fi
    # set -x
    #----------------------------------
    # Process the data type and wordcount
    #----------------------------------

    case $data_type in
    0x24)
        packet=${packet}${line:8:2}${line:6:2}${line:4:2}${line:2:2}
        if [ $line_num -eq $line_num_total ]; then
            one_line_data[$frame_line]=$packet
            echo "one_line_data:${one_line_data[0]}"
            frame_line=$(expr $frame_line + 1)
            break
        fi
        line_num=$(expr $line_num + 1)
        ;;

    esac

    count_line=$(expr $count_line + 1)
    set +x
done <$DUMP_FILE

if [ $SAVE_FILE = 1 ]; then
    if [ -z $OUT_FILE ]; then
        rm -rf $OUT_FILE
    fi
    for ((i = 0; i <= $frame_line; i++)); do
        echo ${one_line_data[$i]} >>$OUT_FILE
    done
fi
