/*
finite state machine----FSM
testbench file for Detector110.v
有限状态机的实例
2012/05/22
Iverilog + GTKWave on linux
*/

`timescale 1ns/100ps

module tb;
    reg aa, clk, rst;
    wire ww;
    Detector110 tb(aa, clk, rst, ww);
    
    initial begin
        $dumpfile("wave.lxt2");
        $dumpvars(0, tb);
    end
    initial
        begin
            aa = 0;
            clk = 0;
            rst = 1;
        end
    
    initial
        repeat (44) #7 clk = ~clk;
    
    initial
        repeat (15) #23 aa = ~aa;
    
    initial
        begin
            #31 rst = 1;
            #23 rst = 0;
        end
    
    always @ (ww)
        if(ww == 1)
            $display("A 1 was detector on w at time = %t,",$time);
            

endmodule