`timescale 1ns / 1ps

module tb;
parameter ClockPeriod=4;
reg CLK,RST;
wire led;

flashled top(.clk(CLK),.rst(RST));

initial begin
    $dumpfile("wave.lxt2");
    $dumpvars(0, tb); //设置向下找3层
end

initial begin
   CLK=1'b0;
   forever CLK =#(ClockPeriod /2) ~CLK;
end
integer fd;
initial begin
   RST = 1;
   #5 RST = 0;
   #5 RST = 1;
   repeat(64) @(posedge CLK);

   $dumpflush;
   $stop;
end


endmodule
