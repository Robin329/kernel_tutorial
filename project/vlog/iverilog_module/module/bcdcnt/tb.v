`timescale 1ns / 1ps
module tb ;
reg clk,rst;

//生成始时钟
parameter NCLK = 4;
initial begin
	clk=0;
	forever clk=#(NCLK/2) ~clk; 
end 

/****************** BEGIN ADD module inst ******************/
//bcd码计数器
parameter place = 4;

parameter max = 16'h8275;
wire [place*4 - 1 : 0 ]q;
bcd_cnt#(
	.place(place),
	.max(max)
) bcd_cnt(
	.clk(clk),
	.rst_n(rst),
	.q(q)
);

initial begin
	$monitor("q=%8h",q);
end
/****************** BEGIN END module inst ******************/

initial begin
    $dumpfile("wave.lxt2");
    $dumpvars(0, tb);   //dumpvars(深度, 实例化模块1，实例化模块2，.....)
end

initial begin
   	rst = 1;
    	#(NCLK) rst=0;
    	#(NCLK) rst=1; //复位信号

	repeat(10000) @(posedge clk)begin

	end
	//$display("运行结束！");
	$dumpflush;
	$finish;
	$stop;	
end 
endmodule
