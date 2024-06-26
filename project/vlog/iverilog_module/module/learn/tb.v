`timescale 1ns / 1ps
module tb ;
reg clk,rst;

//生成始时钟
parameter NCLK = 2;
parameter N_VOTE = 32;
parameter REREAT_TIMES = 100; //控制仿真时间
initial begin
        clk=0;
        forever clk=#(NCLK/2) ~clk; 
end 

/****************** 开始module inst ******************/
//Modulenamme top (rst,clk);
reg [1:0]sw;
reg [3:0]a,b,c,d;
reg [N_VOTE - 1 : 0]vote;
initial begin
repeat(REREAT_TIMES )@(posedge clk)begin
        a=$random;
        b=$random;
        c=$random;
        d=$random;
        sw=$random;
        vote={$random,$random};
        end
end
MUX4_1 MUX4_1(
        .sw(sw),
        .a(a),
        .b(b),
        .c(c),
        .d(d)
);
//<<<<<<<<<<<<<<<<<<<<<<<隐含锁存器例子>>>>>>>>>>>>>>>>>>>>>>>>
buried_ff buried_ff(
    .a(a),
    .sel(b[0])
);
//<<<<<<<<<<<<<<<<<<<<<<<n人表决器例子>>>>>>>>>>>>>>>>>>>>>>>>
voter_n #(
    .N(N_VOTE)
) voter_n (
    .vote(vote)
);
//<<<<<<<<<<<<<<<<<<<<<<<for乘法器例子>>>>>>>>>>>>>>>>>>>>>>>>
mult_for #(
   .SIZE(8)
    ) mult_for (
    .a({a,b}),
    .b({c,d})
    
);
//<<<<<<<<<<<<<<<<<<<<<<<UDP例子>>>>>>>>>>>>>>>>>>>>>>>>
wire ydp_o;
udp_add udp_addi(
	.y(ydp_o),
	.cin(a[0]),
	.a(b[0]),
	.b(c[0])	
);
wire Q ;
udp_dff udp_dff(
	.Q(Q),
	.D(a[0]),
	.clk(clk)
);

initial begin
	$monitor("UDP_ADD|cin=%0d a=%0d b=%0d y=%0d  UDP_DFF|D=%0d clk=%0d Q=%0d ",a[0],b[0],c[0],ydp_o,a[0],clk,Q);
end

//<<<<<<<<<<<<<<<<<<<<<<<johnson例子>>>>>>>>>>>>>>>>>>>>>>>>
johnson johnson(
	.clk(clk),
	.rst(rst)
);

/****************** 结束 module inst ******************/

initial begin
    $dumpfile("wave.lxt2");
    $dumpvars(0, tb);   //dumpvars(深度, 实例化模块1，实例化模块2，.....)
end

initial begin
        rst = 1;
        #(NCLK) rst=0;
        #(NCLK) rst=1; //复位信号

        repeat(REREAT_TIMES) @(posedge clk)begin
        
        end
        $display("运行结束！");
        $dumpflush;
        $finish;
        $stop;
end 


endmodule
