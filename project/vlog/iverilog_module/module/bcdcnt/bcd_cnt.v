
module bcd_cnt#(
	parameter place = 32'd4,
	parameter max = 32'h65 
)
(
	input clk,
	input rst_n,
	output reg [4*place - 1:0] q
);
integer i;
reg [ place : 0 ] c;

always @(posedge clk)
begin
	if(!rst_n)begin
		q = {place{1'b0}};	
		c[0] = 1;
	end
	else begin
		c [0] = 1'b1;
		for(i=0;i<place;i=i+1)
		begin
			{c[i+1],q[i*4+3],q[i*4+2],q[i*4+1],q[i*4]} = bcd_add({q[i*4+3],q[i*4+2],q[i*4+1],q[i*4]},c[i]);
		end
		if(q > max - 1 )q = 0;

	end
end

function [4:0]bcd_add(input [3:0] din,input cin);
	begin	
		bcd_add[3:0] = din + cin;
		if(bcd_add[3:0] > 4'd9)begin
			bcd_add[3:0] = bcd_add[3:0] + 4'd6;
			bcd_add[4] = 1'b1;end
		else begin
			bcd_add[3:0] = bcd_add[3:0];	
			bcd_add[4] = 1'b0;
		end
	end 
endfunction 


endmodule

