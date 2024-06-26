`timescale 1ns / 1ps
// ********************************************************************
//	FileName	: monopulse.v
//	Author		：hpy
//	Email		：yuan_hp@qq.com
//	Date		：2020年8月5日
//	Description	：单脉冲发生器
// --------------------------------------------------------------------
module monopulse #(
    parameter N = 3 //设置单脉冲维持高电平的时间 N×Tclk 
)(
    input clk ,
    input rst_n,
	input start, //触发信号
	output reg y

);
//计算所需计数器位宽
function integer clogb2(input integer depth);
begin
	for(clogb2=0;depth>0;clogb2 = clogb2 + 1)
		depth = depth >> 1;
end
endfunction

reg [2:0] cst,nst;
reg[ clogb2(N) - 1 : 0 ] cnt;

localparam IDEL = 3'b001;
localparam S1   = 3'b010;
localparam DONE = 3'b100;

reg start_diff1,start_diff2;
wire start_p;
//提取上升沿
assign start_p = start_diff1 & ~start_diff2;
always@(posedge clk)
begin
	if(!rst_n)begin
		start_diff1 <= 1'b0;
		start_diff2 <= 1'b0;
	end
	else begin
		start_diff1 <= start;
		start_diff2 <= start_diff1;
	end
end

//状态跳转
always@(posedge clk)
	cst <= (!rst_n) ? IDEL : nst;

//状态转换
always@(*)
begin
	nst = IDEL;
	case(cst)
		IDEL:begin
			nst = (start_p) ? S1 : IDEL;
		end
		S1:begin
			nst = ( cnt < N)? S1 : DONE ; 
		end
		DONE:begin
			nst = IDEL;
		end
		default: nst = IDEL ;
	endcase
end

//输出

always@(posedge clk)
begin
	if(!rst_n)begin
		y <= 1'b0;
		cnt <= 'd0;
	end
	else begin
		if(nst==IDEL)begin
			y <= 1'b0;
			cnt <= 'd0;
		end
		else if(nst==S1)begin
			y <= 1'b1;
			cnt <= cnt + 1'b1;
		end
		else if(nst==DONE)begin 
			y <= 1'b0;
		end
		else begin
			y <= 1'b0;
			cnt <= 'd0;
		end

	end
end


endmodule
