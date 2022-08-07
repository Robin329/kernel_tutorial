#!/usr/bin/tclsh

puts [expr 3 + 2]; # print sum of the 3 and 2
puts [expr 1 + 6 + 9]

set a 3
puts $a

# Dynamic variables
set variableA "10"
puts $variableA
set sum [expr $variableA +20];
puts $sum

# Math expressions
set variableA "10"
set result [expr $variableA / 9];
puts $result
set result [expr $variableA / 9.0];
puts $result
set variableA "10.0"
set result [expr $variableA / 9];
puts $result

set variableA "10"
set tcl_precision 5
set result [expr $variableA / 9.0];
puts $result
