module idata1(
    input clk,
    input rst_n,
    output reg [7:0]do1,
    output [7:0]td
);
    assign td = do1 + 3;
    always@(posedge clk or negedge rst_n)
    if (!rst_n) begin
        do1 <= 0;
    end else begin
        do1 <= do1 + 1;
    end
endmodule // idata1