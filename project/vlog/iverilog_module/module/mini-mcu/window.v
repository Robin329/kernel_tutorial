
//特地用来观察变量的
module window(
    input       clk,            //系统时钟
    input       rst_n,          //复位  0 --> 复位
    input [11:0]address,       //程序取址地址
    input  [17:0]instruction,   //指令输入   
    input [7:0]      in_port,        //输入口
    input       read_strobe,    //输入口使能     
    input [7:0] port_id,        //io口地址
    input [7:0] out_port,       //输出口
    input       write_strobe,   //输出口写使能  
    input interrupt_ack,
    input interrupt,
    input Z,
    input C,
    input jp,
    input [17:0]pc,
    input [7:0]sA,
    input [7:0]sB,
    input [7:0]sC,
    input [7:0]sD,
    input [4:0]st,
    input [11:0]stack_0,
    input [11:0]stack_1,
    input [11:0]stack_2,
    input [7:0]s0,
    input [7:0]s1,
    input [7:0]s2,
    input [7:0]s3,
    input [7:0]s4,
    input [7:0]s5,
    input [7:0]s6,
    input [7:0]s7
);


endmodule