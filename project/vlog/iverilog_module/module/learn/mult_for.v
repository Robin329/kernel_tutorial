//位宽可设置乘法器
module mult_for #(
    parameter SIZE = 8
    )(
    input [SIZE-1:0]a,
    input [SIZE-1:0]b,
    output reg[2*SIZE - 1 : 0]y
    
);
integer i;
always@(a,b)
begin
    y = 0;
    for(i=0;i<SIZE;i=i+1)
        if(b[i])y=y+(a<<i);
end
endmodule // mult_for
