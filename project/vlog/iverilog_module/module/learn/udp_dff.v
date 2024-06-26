//udp写的d触发器 dff
primitive udp_dff(
	Q,
	clk,
	D
);

input D,clk;
output Q;

reg Q;

table
	//clk	D	:	state:	Q
	(01)	0	:	?	:	0;//上升沿到来，锁存数据
	(01)	1	:	?	:	1;
	(0?)	1	:	1	:	1;
	(0?)	0	:	0	:	0;
	(?0)	?	:	?	:	-; //没有上升沿到来，保持原值
	?		(??):	?	:	-;//时钟不变，输出值也不变

endtable

endprimitive
