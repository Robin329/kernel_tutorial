`timescale 1ns / 1ps

module tb;
parameter ClockPeriod=4;
reg RST,CLK;

breath_led top(.clk(CLK),.rst(RST));
initial begin
    $dumpfile("wave.lxt2");
    $dumpvars(0, tb);
end

initial begin
   CLK=1'b0;
   forever CLK =#(ClockPeriod /2) ~CLK;
end

initial begin
   RST = 1;
   #2 RST=0;
   #1 RST=1;
   repeat(10000) begin 
      @(posedge CLK);
      // $display("111");
   end
   $display;
   $dumpflush;
   $stop;
end


endmodule
