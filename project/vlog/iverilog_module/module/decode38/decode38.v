// ********************************************************************
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// ********************************************************************
// File name    : decode38.v
// Module name  : decode38
// Author       : STEP
// Description  : 3-8decode control code
// Web          : www.stepfpga.com
// 
// --------------------------------------------------------------------
// Code Revision History : 
// --------------------------------------------------------------------
// Version: |Mod. Date:   |Changes Made:
// V1.0     |2017/03/02   |Initial ver
// --------------------------------------------------------------------
// Module Function:利用3路开关的状态作为输出，通过3-8译码实现控制code灯的显示。
 
module decode38 (
    input [2:0] sw,
    output reg[7:0]code
);                                                //定义code为reg型变量，在always过程块中只能对reg型变量赋值
 
        //always过程块，括号中sw为敏感变量，当sw变化一次执行一次always中所有语句，否则保持不变
	always @ (sw)
	begin
		case(sw)                                                   //case语句，一定要跟default语句
			3'b000:	code=8'b0111_1111;                         //条件跳转，其中“_”下划线只是为了阅读方便，无实际意义  
			3'b001:	code=8'b1011_1111;                         //位宽'进制+数值是Verilog里常数的表达方法，进制可以是b、o、d、h（二、八、十、十六进制）
			3'b010:	code=8'b1101_1111;
			3'b011:	code=8'b1110_1111;
			3'b100:	code=8'b1111_0111;
			3'b101:	code=8'b1111_1011;
			3'b110: code=8'b1111_1101;
			3'b111:	code=8'b1111_1110;
			default: ;
		endcase
	end
endmodule