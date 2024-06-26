`timescale 1ns / 1ps
// ********************************************************************
//	FileName	: fifo_sync.v
//	Author		：hpy
//	Email		：yuan_hp@qq.com
//	Date		：2020年10月29日
//	Description	：简单同步FIFO
// --------------------------------------------------------------------
module fifo_sync #(
	parameter DEPTH = 16 ,  //FIFO深度
	parameter WIDTH = 8   //FIFO数据位宽
)(
	input clk, 
	input rst_n,
	input fifo_wr_en,
	input fifo_rd_en,
	input [WIDTH - 1 : 0 ]fifo_wr_data,
	output reg [WIDTH - 1 :0 ]fifo_rd_data,
	output fifo_full,
	output fifo_empty
);

// 求计数器位宽
function integer clog2(input integer in);
	for(clog2 = 0;in > 0;clog2 = clog2 + 1)
		in = in >>1;
endfunction

reg [WIDTH -1 : 0] fifo_mem [0:DEPTH - 1] ; //数据缓存器
reg [clog2(DEPTH) - 1 :0 ] wr,rd; //读写数据指针
//数据计数器
reg [clog2(DEPTH) - 1 : 0 ] cnt;
assign fifo_empty = (cnt == 'd0) ? 1 : 0 ; //空输出1 否则输出0
assign fifo_full  = (cnt == DEPTH)? 1 : 0;
//FIFO缓存数据数量更新
always@(posedge clk or negedge rst_n)begin
	if( !rst_n ) cnt <= 'd0;
	else if(fifo_wr_en &fifo_rd_en) cnt <= cnt;
	else if(fifo_wr_en & (~fifo_full)) cnt <= cnt + 1'b1;
	else if(fifo_rd_en & (~fifo_empty)) cnt <= cnt - 1'b1;
	else cnt <= cnt;
end
 
 //写地址
always @(posedge clk or negedge rst_n)begin
	if( !rst_n) wr <= 'd0;
	else if( fifo_wr_en & (~fifo_full)) wr <= wr + 1'b1;
	else wr <= wr;
end

 //读地址
always @(posedge clk or negedge rst_n)begin
	if( !rst_n) rd <= 'd0;
	else if( fifo_rd_en & (~fifo_empty)) rd <= rd + 1'b1;
	else rd <= rd;
end

//写数据
always@(posedge clk or negedge rst_n)begin
	if (!rst_n) fifo_mem[wr] <= 0;
	else if(fifo_wr_en & (~fifo_full)) fifo_mem[wr] <= fifo_wr_data;
	else fifo_mem[wr] <=  fifo_mem[wr];
end
//读数据
always@(posedge clk or negedge rst_n)begin
	if (!rst_n) fifo_rd_data <= 0;
	else if(fifo_rd_en & (~fifo_empty))  fifo_rd_data <= fifo_mem[rd];
	else fifo_rd_data <= fifo_rd_data;
end
endmodule
