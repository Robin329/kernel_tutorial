`timescale 1ns / 1ps

module tb_led;
parameter ClockPeriod=4;
reg CLK,RST;
wire led;

top  top(.clk(CLK),.rst_n(RST),.led0(led));

initial begin
    $dumpfile("wave.lxt2");
    $dumpvars(0, tb_led);
end

initial begin
   CLK=1'b0;
   forever CLK =#(ClockPeriod /2) ~CLK;
end
integer fd;
initial begin
   fd=$fopen("ans.txt","w");
   RST = 1;
   #1 RST = 0;
   #1 RST = 1;
   $fwrite(fd,"%6s %6s %6s\n","rst","clk","led");
   repeat(64) @(CLK)begin 
      $write("%0d ",led);
      $fwrite(fd,"%b %b %b\n",RST,CLK,led);
   end
   $fclose(fd);
   $display;
   $dumpflush;
   $stop;
end


endmodule
