`timescale 1ns / 1ps

module tb;
parameter ClockPeriod=4;
reg CLK,RST;
reg [1:0]in;
wire out;

saler_3always top(RST,CLK,in,out);

initial begin
    $dumpfile("wave.lxt2");
    $dumpvars(2, tb);
   // $vcdpluson;
end



initial begin
   CLK=1'b0;
   forever CLK =#(ClockPeriod /2) ~CLK;
end
integer sum;
initial begin
   RST = 1;
   in = 0;
   sum = 0;
   #5 RST = 0;
   #5 RST = 1;
   repeat(1000)@(posedge CLK)begin
      in = $random;
   end

   $dumpflush;
   $stop;
end

initial begin
   forever @(out)begin
      if(out)$display("交易成功",);
   end
end

endmodule
