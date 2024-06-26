module buried_ff(
    input [3:0] a,
    input sel,
    output reg [3:0]y
);

always@(a,sel)
begin
    if (sel)y=a;
end

endmodule // buried_ff