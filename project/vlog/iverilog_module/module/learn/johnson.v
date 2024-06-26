module johnson(
	output reg [7:0] out,
	input clk,
	input rst
);

always@(posedge clk or negedge rst)
begin
	if(!rst)out <= 8'd0;
	else begin
		out <= {out[6:0],{~out[7]}};
	end	
end 

endmodule 
