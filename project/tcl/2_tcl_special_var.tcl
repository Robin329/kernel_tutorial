#!/usr/bin/tclsh

puts $tcl_version;
puts $env(PATH);
puts $tcl_pkgPath;
puts $tcl_library;
puts $tcl_patchLevel;
puts $tcl_precision;
puts $tcl_rcFileName;

# var type
set myVariable 18
puts "myVariable is $myVariable";

set myVariable "hello world"
puts $myVariable
set myVariable {hello world}
puts $myVariable

# list
set myVariable {red green blue}
puts [lindex $myVariable 2]
set myVariable "red green blue"
puts [lindex $myVariable 1]

# arrays

set  marks(english) 80
puts $marks(english)
set  marks(mathematics) 90
puts $marks(mathematics)

# variable name
set variableA 10
set {variable B} test
puts $variableA
puts ${variable B}

