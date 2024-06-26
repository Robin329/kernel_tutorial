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
//Modulenamme top (rst,clk);
//
reg wr,rd;
wire fifo_empty, fifo_full;
parameter WIDTH = 8;
reg [WIDTH - 1 : 0 ] data;
fifo_sync #(
	.DEPTH (16) ,  //FIFO深度
	.WIDTH(WIDTH)  //FIFO数据位宽
) fifo_buffer(
	.clk(clk),
	.rst_n(rst),
	.fifo_wr_en(wr),
	.fifo_rd_en(rd),
	.fifo_full(fifo_full),
	.fifo_empty(fifo_empty),
	.fifo_wr_data(data)
);


/****************** BEGIN END module inst ******************/

initial begin
    $dumpfile("wave.lxt2");
    $dumpvars(0, tb);   //dumpvars(深度, 实例化模块1，实例化模块2，.....)
end

reg [31:0] times;
initial begin
   	rst = 1;
	wr = 0;
	rd = 0;
    #(NCLK) rst=0;
    #(NCLK) rst=1; //复位信号
	times = 0;
	repeat(16) @(posedge clk)begin
		wr = 1;
		times = times + 1;
		data = $random;
	end
	repeat(16) @(posedge clk)begin
		rd = 1;
		wr = 0;
	end
	times = 0;
	repeat(10) @(posedge clk) begin 
		times = times  + 1;
			rd = 0;
	end
	#10;
	$display("运行结束！");
	$dumpflush;
	$finish;
	$stop;	
end 
endmodule
