#!/usr/bin/env bash
## 将汇编生成的hex文件写入到ROM文件中去
export PATH=$PATH:./tools/bin/

#hex2rom tmp/test.hex 
hexfile="tmp/$(ls tmp | grep "\.hex")"
i=0 
cnt=0
intr_flag=0
while read line
do
    line=$(echo ${line:0:5})
    if [[ $line == "00000" ]] ;then
        if [ $cnt -lt 3 ] ;then
            cnt=$[cnt+1]
        else
            break
        fi 
    else
        if [ $cnt -gt 0 ] ;then
            cnt=0
        fi
    fi
    
    echo  "            12'd$i : y <= 18'h$line ;"  
    if [[ ${line:0:2} == "28" ]] ;then
        intr_flag=1    #检测到代码中有使用中断函数
    fi 
    i=$[i+1]
done < $hexfile

#检测是否开启中断
if [ $intr_flag -eq 1 ] ;then 
    intr_addr=$i   #动态设置硬件中的实际中断入口地址
    echo "\`define ISR_ADDR $intr_addr" > tmp/isr.txt   #将入口地址a保存到 "isr.txt"文件
    fileT="/tmp/$(date +%Y%m%d%H%M%S).txt"
    cat $hexfile | tail -n +1024 > $file1 
    while read line
    do
        line=$(echo ${line:0:5})
        if [[ $line == "00000" ]] ;then
            if [ $cnt -lt 3 ] ;then
                cnt=$[cnt+1]
            else
                break
            fi 
        else
            if [ $cnt -gt 0 ] ;then
                cnt=0
            fi
        fi
        
        echo  "            12'd$i : y <= 18'h$line ;"  
        i=$[i+1]
    done < $fileT
    rm $fileT
fi 
