#!/usr/bin/tclsh
#生成时钟模块代码


puts "生成时钟模块代码"
puts ""

proc clk_module {clk rst c} {
    puts "always @(posedge $clk or negedge $rst)"
    puts "begin"
    puts "   if(rst==1'b0)begin"
    puts ""
    puts "   end"
    puts "   else begin"
    puts ""
    puts "   end "
    puts "end"
}

clk_module clk rst_n c