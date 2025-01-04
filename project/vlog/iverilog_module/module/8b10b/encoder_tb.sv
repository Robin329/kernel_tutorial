module encoder_tb;
    
    parameter clk_period = 2;
    reg clk;
    initial
        clk = 0;
        always #(clk_period / 2) clk = ~clk;
        reg rst;
        reg en;
        reg kin;
        reg [7:0] din;
        wire [9:0] dout;
        wire disp;
        wire kin_err;
        
    initial begin
        $display("============= encoder 8b10b tb =============");
        rst = 0;
        din = 8'h5c;
        en = 0;
        kin = 0;
        rst = 0;
        #1
        rst = 1;
        #1
        rst = 0;
        en = 1;
        $monitor("din = %h dout = %h disp = %d", din, dout, disp);
        kin = 1;
        #2
        din = 8'h5c;
        #2
        din = 8'h5c;
        #2
        din = 8'h5c;
        #2
        din = 8'h5c;
        #1 
        en = 0;
        $display("All tests PASS!");
        $finish;
    end
    encoder_8b10 enc8b10b(
        .clk(clk),
        .rst(rst),
        .en(en),
        .kin(kin),
        .din(din),
        .dout(dout),
        .disp(disp),
        .kin_err(kin_err)
    );
endmodule