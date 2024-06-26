module dis;

integer fd,file_id ,seed, i ;
localparam DELAY = 300;
reg [7:0] din;
reg o;
reg [0:0]j;
initial begin
    $display("hello,verilog!");
    fd=0;
    $display("fd=%0d",fd);
    fd = fd + 2;
    $display("fd=%0d",fd);
    fd = fd * 2;
    $display("fd=%0d",fd);
    fd = fd % 3;
    $display("fd=%0d",fd);
    fd = fd / 2;
    $display("fd=%0d",fd);
    seed=$time;
    fd= $random(seed) % 1000;
    $display("fd=%0d",fd);
    #DELAY
    $display("simulation time is %t",$time);
	for(i=0;i<10;i++)begin
		$display("第%0d次循环！",i);
	end
	for(i=0;i<100;i=i+1)begin
		din = $random;
		o = ~ din;
		j= ^din;
		$display("din=%8b,o=%0d,j=%0d",din,o,j);
	end

	
end

endmodule




