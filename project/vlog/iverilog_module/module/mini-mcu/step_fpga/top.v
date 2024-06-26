/***************************************************************
* mini-mcuʾ����Ŀ��led��ˮ�ƺ�����ܼ����������ļ�
* mini-mcuԴ�ļ���ַ:https://gitee.com/yuan_hp/mini-mcu.git
* Email : yuan_hp@qq.com
* Author : hpy
***************************************************************/
module top
(
	input clk_in,             //����ϵͳ12MHzʱ��
	//4bit���뿪������
	input [3:0] sw,
	input [3:0] key, //��������
	//�����
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
reg rst_n_in;          //��λ�ź�
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

//----------- mini-mcu ���------------
wire [11:0]address;
wire [17:0] instruction;
wire bram_enable, read_strobe, write_strobe;
reg [7:0] in_port;
wire [7:0] port_id, out_port;
//----------- ����� ���------------
reg[3:0] seg_data_1, seg_data_2;
//������� 
always @(posedge clk )begin
		if(write_strobe)begin
			case(port_id)
				8'h00:{seg_data_1,seg_data_2} <= out_port;//bcd�����2�������
				8'h01:out <= out_port;  //LED����
				8'h02:rgb <= out_port[2:0];  //rgb
				default:out <=out;
			endcase
		end else out <= out;
end
//��������

always@(*)begin
	//if(read_strobe) begin
		case(port_id)
				8'h00: in_port = {key[3:0],sw[3:0]};   //���� 4bit���뿪������
				
		endcase
	//end 
end	

/**********************************
* ����mini-mcu
**********************************/
mcu mcu(
    .clk(clk),            //ϵͳʱ��
    .rst_n(	rst_n_in),          //��λ  0 --> ��λ
    .address(	address),       //����ȡַ��ַ
    .instruction(	instruction),   //ָ������
    .bram_enable(	bram_enable),   //����romʹ�� 1-->ʹ��    
    .in_port(	in_port),        //�����
    .read_strobe(	read_strobe),    //�����ʹ��     
    .port_id( port_id),        //io�ڵ�ַ
    .out_port(	out_port),       //�����
    .write_strobe(	write_strobe),   //�����дʹ�� 
    .interrupt(	interrupt)     //�ж�����
);

rom rom(
    .clk(	clk),
    .address(	address),       //����ȡַ��ַ
    .instruction( 	instruction),   //ָ������
    .enable( 	bram_enable)   //����romʹ�� 1-->ʹ�� 
);
/**********************************
*�������ʾ ��bcd�� 
**********************************/
seg_display seg_display(
	.seg_data_1(seg_data_1),
	.seg_data_2(seg_data_2),
	.seg_led_1(seg_led_1),
	.seg_led_2(seg_led_2)
);

endmodule