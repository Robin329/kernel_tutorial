primitive udp_add(
	y,
	cin,
	a,
	b	
);
input cin,a,b;
output y;
table
//	cin	a	b	:	y
	0	0	0	:	0;	
	0	0	1	:	1;
	0	1	0	:	1;
	0	1	1	:	0;
	1	0	0	:	1;
	1	0	1	:	0;
	1	1	0	:	0;
	1	1	1	:	1;
endtable

endprimitive
