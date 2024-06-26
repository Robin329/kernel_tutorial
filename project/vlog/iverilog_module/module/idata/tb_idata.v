
`timescale 1ns/1ps
module tb;
reg clk;
reg rst_n;

wire [7:0]do1;
wire [7:0]do2;

topdata test(
    .clk(clk),
    .rst_n(rst_n)
   // .do1(do1),
   // .do2(do2)
);

localparam CLK_PERIOD = 2;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("wave.lxt2");
    $dumpvars(0, tb);
end

initial begin
    #1 rst_n<=1'bx;clk=1'bx;
    #(CLK_PERIOD*3) rst_n=1;
    #(CLK_PERIOD*3) rst_n=0;clk=0;
    repeat(3) @(posedge clk);
    rst_n<=1;
    repeat(64) @(posedge clk);

    $dumpflush;
    $stop;
end

endmodule
