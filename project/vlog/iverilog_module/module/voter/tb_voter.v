`timescale 1ns / 1ps

module tb;
parameter ClockPeriod=4;
reg a,b,c ,CLK;
wire [2:0]num_led ;
wire result_led ;

voter top(.a(a),.b(b),.c(c));

initial begin
    $dumpfile("wave.lxt2");
    $dumpvars(0, tb);
end

initial begin
   CLK=1'b0;
   forever CLK =#(ClockPeriod /2) ~CLK;
end

initial begin

   repeat(100) begin 
      @(posedge CLK)begin
         a = $random % 2;
         b = $random % 2;
         c = $random % 2;
      end
   end
   $display;
   $dumpflush;
   $stop;
end


endmodule
