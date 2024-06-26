#!/usr/bin/tclsh
#将vfile.v文件转化为puts打印出上述格式的文件

#用于制作自动生成module代码的中间过程

set fd [open "vfile.v" r];#读模式打开文件
while {[gets $fd line]>=0} {
    puts "puts \"$line\""
}

close $fd 
