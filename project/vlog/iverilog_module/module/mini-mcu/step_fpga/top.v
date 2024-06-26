/***************************************************************
* mini-mcu示例项目：led流水灯和数码管计数器顶层文件
* mini-mcu源文件地址:https://gitee.com/yuan_hp/mini-mcu.git
* Email : yuan_hp@qq.com
* Author : hpy
***************************************************************/
module top
(
	input clk_in,             //输入系统12MHz时钟
	//4bit拨码开关输入
	input [3:0] sw,
	input [3:0] key, //按键输入
	//数码管
	output [8:0] seg_led_1,
	output [8:0] seg_led_2,
	//rgb
	output reg[2:0]rgb,
	//led
	output led1,              
	output led2,
	output led3,
	output led4,
	output led5,
	output led6,
	output led7,
	output led8
); 

wire clk ,clko,rst;
reg [7:0] out;
assign {led8,led7,led6,led5,led4,led3,led2,led1} = out;
assign clk = clk_in;
reg rst_n_in;          //复位信号
reg [31:0]cnt ;
always @(posedge clk) begin
		if(cnt>=32'd12000000)begin
			rst_n_in <= 1'b1;
		end else if(cnt<32'd100)begin
			rst_n_in <= 1'b1;
			cnt <= cnt +1;
		end
		else begin
		    cnt <= cnt +1;
			rst_n_in <= 0;
		end
end 

wire interrupt;
divide #(
	.N(12000000)
) u1 (
	.clk(clk),
	.rst_n(rst_n_in),
	.clkout(interrupt)
); 

//----------- mini-mcu 相关------------
wire [11:0]address;
wire [17:0] instruction;
wire bram_enable, read_strobe, write_strobe;
reg [7:0] in_port;
wire [7:0] port_id, out_port;
//----------- 数码管 相关------------
reg[3:0] seg_data_1, seg_data_2;
//输出引脚 
always @(posedge clk )begin
		if(write_strobe)begin
			case(port_id)
				8'h00:{seg_data_1,seg_data_2} <= out_port;//bcd编码的2个数码管
				8'h01:out <= out_port;  //LED控制
				8'h02:rgb <= out_port[2:0];  //rgb
				default:out <=out;
			endcase
		end else out <= out;
end
//输入引脚

always@(*)begin
	//if(read_strobe) begin
		case(port_id)
				8'h00: in_port = {key[3:0],sw[3:0]};   //按键 4bit拨码开关输入
				
		endcase
	//end 
end	

/**********************************
* 例化mini-mcu
**********************************/
mcu mcu(
    .clk(clk),            //系统时钟
    .rst_n(	rst_n_in),          //复位  0 --> 复位
    .address(	address),       //程序取址地址
    .instruction(	instruction),   //指令输入
    .bram_enable(	bram_enable),   //程序rom使能 1-->使能    
    .in_port(	in_port),        //输入口
    .read_strobe(	read_strobe),    //输入口使能     
    .port_id( port_id),        //io口地址
    .out_port(	out_port),       //输出口
    .write_strobe(	write_strobe),   //输出口写使能 
    .interrupt(	interrupt)     //中断输入
);

rom rom(
    .clk(	clk),
    .address(	address),       //程序取址地址
    .instruction( 	instruction),   //指令输入
    .enable( 	bram_enable)   //程序rom使能 1-->使能 
);
/**********************************
*数码管显示 是bcd码 
**********************************/
seg_display seg_display(
	.seg_data_1(seg_data_1),
	.seg_data_2(seg_data_2),
	.seg_led_1(seg_led_1),
	.seg_led_2(seg_led_2)
);

endmodule