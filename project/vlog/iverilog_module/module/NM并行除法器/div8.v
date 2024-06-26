`timescale 1ns / 1ps
// ********************************************************************
//	FileName	: div8.v
//	Author		：hpy 
//	Email		：yuan_hp@qq.com 
//	Date		：2021年05月02日 
//	Description	：
// -------------------------------------------------------------------- 

/*--------------------------------
div8 #(
    .N(32),  //被除数位宽
    .M(8)    //除数位宽  满足 N>=M
) div_inst ( 
    .dividend(  ), //被除数
    .divisor(   ), //除数位宽  满足 N>=M
    .merchant(  ), //商
    .remainder(     ) //余数
);
---------------------------------*/
module div8 #(
    parameter N=32,  //被除数位宽
    parameter M=8  //除数位宽  满足 N>=M
)(  
    input [N-1:0] dividend, //被除数
    input [M-1:0] divisor,// 除数
    output reg [N-M : 0] merchant,//商
    output reg [M - 1 : 0] remainder  //余数
);
parameter N_CAT = N-M;
integer i ; 
reg [N-M   : 0] merchant_reg ; 
reg [N-1   : 0] dividend_reg  ;
reg [M : 0] remainder_reg;
always @(*) begin 
    merchant_reg = {(N-M +1){1'b0}};
    dividend_reg=dividend;
    remainder_reg = {(M+1){1'b0}};
    for( i=0 ;i<N; i=i+1) begin
        remainder_reg = (remainder_reg<<1) + dividend_reg[N-1];
        if({1'B0,divisor} <= remainder_reg) begin
            merchant_reg = (merchant_reg<<1)+1'b1 ;
            remainder_reg = remainder_reg - divisor;
        end
        else begin 
            merchant_reg = merchant_reg<<1;
            remainder_reg = remainder_reg ;
        end
        dividend_reg= dividend_reg<<1;
       // remainder_reg = (remainder_reg<<1) + dividend_reg[N-M];
      
    end
    merchant = merchant_reg;
    remainder = remainder_reg[M-1:0];
end 

endmodule
