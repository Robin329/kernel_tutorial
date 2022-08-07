`include "counter.v"
`timescale 1ns/1ns
module test;
  reg reset = 0;
  initial
    begin
      #17 reset = 1;
      #11 reset = 0;
//       #29 reset = 1;
//       #11 reset = 0;
      #1000 $stop;
    end

  reg clk = 0;
  always #5 clk = !clk;
  wire [7:0] value;
  counter c1(value, clk, reset);
  initial
    $monitor("At time %t, value = %h (%od)", $time, value, value);
  initial
    begin
      $dumpfile("test.vcd");
      $dumpvars(0, test);
    end
endmodule
