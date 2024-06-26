`timescale 1ns / 1ps

module tb;
parameter ClockPeriod=4;
reg BITVAL,Enable,CLK,RST;
integer i=0;
wire [6:0] 	CRC;

reg [39:0] cmd=40'b01_010001_00000000000000000000000000000000;
CRC_7  crc7(BITVAL, Enable, CLK, RST, CRC);

initial begin
    $dumpfile("wave.lxt2");
    $dumpvars(0, tb);
end

initial begin
CLK=1'b0;
forever CLK =#(ClockPeriod /2) ~CLK;
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
   #10 ;
   for(i=39;i>=0;i=i-1)
   #10 BITVAL= cmd[i];
   $display ("crc is %b",CRC);

   $dumpflush;
   $stop;
end

endmodule
