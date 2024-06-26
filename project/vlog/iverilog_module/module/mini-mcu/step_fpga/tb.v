`timescale 1ns / 100ps

module tb ;
reg clk,rst_n;

//生成时钟
parameter NCLK = 2;
initial begin
	clk=0;
	forever clk=#(NCLK/2) ~clk; 
end 

reg interrupt ; //中断触发信号
reg [7:0]isr_flag;  //中断标志
reg [2:0] isr_id;
initial begin
	interrupt=0;
	forever begin
        interrupt = #(NCLK*80) ~interrupt;
    end
end 

reg [2:0]int_f; 
assign int_p = int_f[0] & ~int_f[1];
always@(posedge clk)begin
    if(!rst_n) begin
        int_f <= 3'd0;
    end else begin
        int_f <= {int_f[1:0] , interrupt };
    end
end
always@(*)begin
    isr_id = (int_p)? $random:isr_id;
end

/****************** BEGIN ADD module inst ******************/

//查看输出的


//-----------------------
wire [11:0]address;
wire [17:0] instruction;
wire bram_enable, read_strobe, write_strobe;
reg [7:0] in_port;
wire [7:0] port_id, out_port;
wire interrupt_ack ;

mcu mcu(
    .clk(clk),            //系统时钟
    .rst_n(	rst_n),          //复位  0 --> 复位
    .address(	address),       //程序取址地址
    .instruction(	instruction),   //指令输入
    .bram_enable(	bram_enable),   //程序rom使能 1-->使能    
    .in_port(	in_port),        //输入口
    .read_strobe(	read_strobe),    //输入口使能     
    .port_id( port_id),        //io口地址
    .out_port(	out_port),       //输出口
    .write_strobe(	write_strobe),   //输出口写使能  
    .interrupt(interrupt),     //中断触发信号
    .interrupt_ack(interrupt_ack)  //中断响应信号
);

rom rom(
    .clk(	clk),
    .address(	address),       //程序取址地址
    .instruction( 	instruction),   //指令输入
    .enable( 	bram_enable)   //程序rom使能 1-->使能 
);

// 输出口
always@ (posedge clk) begin
    if(write_strobe)begin //
       case(port_id)
            8'hff: isr_flag <= out_port;   //清除中断标志
       endcase 
    end
    else begin  //中断来了，硬件置标志位
        if(int_p)begin 
            case(isr_id)
                3'd0: isr_flag <= isr_flag | 8'b0000_0001;
                3'd1: isr_flag <= isr_flag | 8'b0000_0010;
                3'd2: isr_flag <= isr_flag | 8'b0000_0100;
                3'd3: isr_flag <= isr_flag | 8'b0000_1000;
                3'd4: isr_flag <= isr_flag | 8'b0001_0000;
                3'd5: isr_flag <= isr_flag | 8'b0010_0000;
                3'd6: isr_flag <= isr_flag | 8'b0100_0000;
                3'd7: isr_flag <= isr_flag | 8'b1000_0000;
            endcase
        end 
    end
end
//输入口
always @(*)begin
    case(port_id)
        8'hff: in_port = isr_flag;
        default:in_port = 8'h40;
    endcase
end

window window(
    .clk(clk),            //系统时钟
    .rst_n(	rst_n),          //复位  0 --> 复位
    .address(	address),       //程序取址地址
    .instruction(	instruction),   //指令输入    
    .in_port(	in_port),        //输入口
    .read_strobe(	read_strobe),    //输入口使能     
    .port_id( port_id),        //io口地址
    .out_port(	out_port),       //输出口
    .write_strobe(	write_strobe),   //输出口写使能  
    .interrupt_ack( interrupt_ack), 
    .interrupt(  interrupt),
    .Z(mcu.Z),
    .C(mcu.C),
    .jp(mcu.jp),
    .pc(mcu.pc),
    .sA(mcu.s[10]),
    .sB(mcu.s[11]),
    .sC(mcu.s[12]),
    .sD(mcu.s[13]),
    .s0(mcu.s[0]),
    .s1(mcu.s[1]),
    .s2(mcu.s[2]),
    .s3(mcu.s[3]),
    .s4(mcu.s[4]),
    .s5(mcu.s[5]),
    .s6(mcu.s[6]),
    .s7(mcu.s[7]),
    .st(mcu.st),
    .stack_1(mcu.stack[1]),
    .stack_2(mcu.stack[2])
);
/****************** BEGIN END module inst ******************/

initial begin
    $dumpfile("wave.lxt2");
    $dumpvars(0, tb);   //dumpvars(深度, 实例化模块1，实例化模块2，.....)
end

initial begin
   	rst_n = 1;
    	#(NCLK*3) rst_n=0;
    	#(NCLK*3) rst_n=1; //复位信号

	repeat(10000) @(posedge clk)begin

	end
	$display("运行结束！");
	$dumpflush;
	$finish;
	$stop;	
end 
endmodule
