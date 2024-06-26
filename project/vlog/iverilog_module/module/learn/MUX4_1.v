//连续复制四选一
module MUX4_1(
    input [1:0]sw,
    input [3:0]a,
    input [3:0]b,
    input [3:0]c,
    input [3:0]d,
    output[3:0]y    
);
assign y =  (sw==2'd0)? a:
            (sw==2'd1)? b:
            (sw==2'd2)? c:d;



endmodule // MUX4_1 input [1:0]sw,
