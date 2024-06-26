

// ********************************************************************
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// ********************************************************************
// File name    : debounce.v
// Module name  : debounce
// Author       : STEP
// Description  : 
// Web          : www.stepfpga.com
// 
// --------------------------------------------------------------------
// Code Revision History : 
// --------------------------------------------------------------------
// Version: |Mod. Date:   |Changes Made:
// V1.0     |2017/03/14   |Initial ver
// --------------------------------------------------------------------
// Module Function:三人表决器
 
module voter(
	input a,				//评委A
	input b,				//评委B
	input c,				//评委C
	output [2:0] num_led,	//投票数显示
	output result_led  //投票结果显示
    );	
	assign num_led=~{a,b,c};	//用三个LED表示投票情况，另根据硬件电路，LED为0时亮，故取反
	assign result_led=~((!a&b&c)||(a&!b&c)||(a&b&!c)||(a&b&c))?1:0;		//此处请参阅真值表，另根据硬件电路，LED为0时亮，故取反
 
endmodule

