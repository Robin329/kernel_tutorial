#!/usr/bin/tclsh

#生成模块代码的引导


#进入用户选择的文件夹后读取当前文件夹下面的.tcl脚本
set file_tcl [glob *.tcl]
set file_count [llength $file_tcl] ;#获取脚本数量
set index 0 ;#初始化遍历序号
set dis_index 0
puts ""
puts "---------------------func----------------------"
for {set index 0} {$index < $file_count} {incr index 1} {
    set fd [open [lindex $file_tcl $index] r];#读模式打开文件
    #读取第一行，不进行操作，直接读取第二行
    gets $fd line
    #读取第二行
    if {([gets $fd line]>=0) && ([string length $line] > 0)} {
        set line [string replace $line 0 0]
        lappend list [lindex $file_tcl $index] ;#将文件名添加到新的list中
        puts "$dis_index.$line"
        incr dis_index 1 ;#自加1
    }
    #关闭文件
    close $fd 
}

puts ""
puts "请输入你想要执行功能的序号或者输入exit退出:"
set count [llength $list]
set in [gets stdin]
if {[string equal $in "exit"]} {
    puts "退出引导脚本！"
    exit
} elseif { ($in < 0) || ($in >= $count) } {
    puts "输入的指令有误！将退出脚本！"
    exit
} else {
    #执行选中的脚本
    set fd [open [lindex $list $in] r]
    set cmd [read $fd]
    close $fd
    eval $cmd
}


