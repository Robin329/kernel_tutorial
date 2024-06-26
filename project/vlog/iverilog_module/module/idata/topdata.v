module topdata(
    input clk,
    input rst_n,
    output wire [7:0]do1,
    output wire [7:0]do2
);
    idata1 idata1(.clk(clk),.rst_n(rst_n),.do1(do1) );
    idata2 idata2(.clk(clk),.rst_n(rst_n),.do2(do2) );
endmodule // topdata
