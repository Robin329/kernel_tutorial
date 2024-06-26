`timescale 1ns / 1ps
module tb ;
reg clk,rst_n;

//生成始时钟
parameter NCLK = 20;  //此时时钟为50MHz
initial begin
	clk=0;
	forever clk=#(NCLK/2) ~clk; 
end 

/******************  ADD module inst ******************/
parameter N = 32;
parameter M = 8;
reg [N-1:0] dividend;
reg [M-1:0] divisor ;
div8 #(
    .N(N),  //被除数位宽
    .M(M)    //除数位宽  满足 N>=M
) div_inst ( 
    .dividend( dividend ), //被除数
    .divisor(   divisor) //除数位宽  满足 N>=M
);
/******************  --- module inst ******************/

initial begin
    $dumpfile("wave.lxt2");
    $dumpvars(0, tb);   //dumpvars(深度, 实例化模块1，实例化模块2，.....)
end

initial begin
   	rst_n = 0;
    #(NCLK) rst_n=0;
    #(NCLK) rst_n=1; //复位信号

	repeat(100) @(posedge clk)begin
		# 1 ; //作为延时时间
		dividend <= $random;
		divisor  <= $random;
	end
	$display("运行结束！");
	$dumpflush;
	$finish;
	$stop;	
end 
endmodule
