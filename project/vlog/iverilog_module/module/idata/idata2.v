module idata2(
    input clk,
    input rst_n,
    output reg [7:0]do2
);
    always@(posedge clk or negedge rst_n)
    if (!rst_n) begin
        do2 <= 0;
    end else begin
        do2 <= do2 + 2;
    end
endmodule // idata1