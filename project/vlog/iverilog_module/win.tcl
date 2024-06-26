#!/usr/bin/env wish
# tcl tk第一个程序

#编译当前工程
button .comp -text "compile" \
    -command {
    exec bash run -r
}

button .wave -text "wave" \
    -command {
    exec bash run
}

button .quit -text "quit" \
    -command {
    exit
}

pack .comp -padx 60 -pady 5
pack .wave -padx 60 -pady 5

pack .quit -padx 60 -pady 5
