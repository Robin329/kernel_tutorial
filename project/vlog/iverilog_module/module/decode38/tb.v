`timescale 1ns / 1ps

module tb;
parameter ClockPeriod=4;
reg BITVAL,Enable,clk,RST;
reg [2:0]sw;

decode38  decode38(.sw(sw),.code());

initial begin
    $dumpfile("wave.lxt2");
    $dumpvars(0, tb);
end

initial begin
clk=1'b0;
forever clk =#(ClockPeriod /2) ~clk;
end

initial begin
RST=0;
#10 RST=1;
#8 RST=0;
end

initial begin
   Enable=0;
   #18 Enable=1; //1
   #410 Enable=0;
end

initial begin

BITVAL=0;
   sw=0;
   delay;
   repeat(50) @(posedge clk) sw=sw+1;
   //$display ("crc is %b",CRC);

   $dumpflush;
   $stop;
end

task delay;
   repeat(10)@(posedge clk);
endtask

endmodule
