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
reg start;
initial begin
	start = 0;
	forever start = #(30*NCLK) ~start;
end

monopulse #(.N(5)) monopulse(
	.clk(clk),
	.rst_n(rst),
	.start(start)
);
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
        $display("运行结束！");
        $dumpflush;
        $finish;
        $stop;
end 
endmodule
