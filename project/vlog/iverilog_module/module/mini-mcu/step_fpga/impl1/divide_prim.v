// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.10.3.144
// Netlist written on Fri Nov 27 01:07:51 2020
//
// Verilog Description of module divide
//

module divide (clk, rst_n, clkout) /* synthesis syn_module_defined=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(13[8:14])
    input clk;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(16[8:11])
    input rst_n;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(17[8:13])
    output clkout;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(18[9:15])
    
    wire clk_c /* synthesis is_clock=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(16[8:11])
    wire clk_N_8 /* synthesis is_inv_clock=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(27[28:33])
    
    wire GND_net, VCC_net, rst_n_c, clkout_c;
    wire [2:0]cnt_p;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(27[22:27])
    wire [2:0]cnt_n;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(27[28:33])
    
    wire clk_p, clk_n, n19, clk_p_N_19, n20, n141, n3, n3_adj_1, 
        clk_n_N_22, n18, n138, n18_adj_2, n19_adj_3, n20_adj_4, 
        n208;
    
    VHI i2 (.Z(VCC_net));
    INV i117 (.A(clk_c), .Z(clk_N_8));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(16[8:11])
    FD1S3IX cnt_n_50__i0 (.D(n20_adj_4), .CK(clk_N_8), .CD(n141), .Q(n3_adj_1));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(59[16:23])
    defparam cnt_n_50__i0.GSR = "ENABLED";
    FD1S3IX clk_p_30 (.D(clk_p_N_19), .CK(clk_c), .CD(n208), .Q(clk_p));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(42[12] 50[6])
    defparam clk_p_30.GSR = "ENABLED";
    FD1S3IX clk_n_32 (.D(clk_n_N_22), .CK(clk_N_8), .CD(n208), .Q(clk_n));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(63[9] 71[6])
    defparam clk_n_32.GSR = "ENABLED";
    LUT4 i43_1_lut_rep_2 (.A(rst_n_c), .Z(n208)) /* synthesis lut_function=(!(A)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(17[8:13])
    defparam i43_1_lut_rep_2.init = 16'h5555;
    IB rst_n_pad (.I(rst_n), .O(rst_n_c));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(17[8:13])
    TSALL TSALL_INST (.TSALL(GND_net));
    IB clk_pad (.I(clk), .O(clk_c));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(16[8:11])
    FD1S3IX cnt_n_50__i2 (.D(n18_adj_2), .CK(clk_N_8), .CD(n141), .Q(cnt_n[2]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(59[16:23])
    defparam cnt_n_50__i2.GSR = "ENABLED";
    LUT4 i47_2_lut (.A(cnt_n[2]), .B(rst_n_c), .Z(n141)) /* synthesis lut_function=(A+!(B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(57[9] 59[24])
    defparam i47_2_lut.init = 16'hbbbb;
    LUT4 i69_2_lut (.A(cnt_n[1]), .B(cnt_n[2]), .Z(clk_n_N_22)) /* synthesis lut_function=(A+(B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(67[13:25])
    defparam i69_2_lut.init = 16'heeee;
    LUT4 i99_1_lut (.A(n3_adj_1), .Z(n20_adj_4)) /* synthesis lut_function=(!(A)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(59[16:23])
    defparam i99_1_lut.init = 16'h5555;
    LUT4 i108_3_lut (.A(cnt_n[2]), .B(cnt_n[1]), .C(n3_adj_1), .Z(n18_adj_2)) /* synthesis lut_function=(!(A (B (C))+!A !(B (C)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(59[16:23])
    defparam i108_3_lut.init = 16'h6a6a;
    LUT4 i68_2_lut (.A(cnt_p[1]), .B(cnt_p[2]), .Z(clk_p_N_19)) /* synthesis lut_function=(A+(B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(46[13:25])
    defparam i68_2_lut.init = 16'heeee;
    LUT4 clk_p_I_0_2_lut (.A(clk_p), .B(clk_n), .Z(clkout_c)) /* synthesis lut_function=(A (B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(73[43:56])
    defparam clk_p_I_0_2_lut.init = 16'h8888;
    LUT4 i44_2_lut_2_lut (.A(rst_n_c), .B(cnt_p[2]), .Z(n138)) /* synthesis lut_function=((B)+!A) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(17[8:13])
    defparam i44_2_lut_2_lut.init = 16'hdddd;
    GSR GSR_INST (.GSR(VCC_net));
    LUT4 i77_1_lut (.A(n3), .Z(n20)) /* synthesis lut_function=(!(A)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam i77_1_lut.init = 16'h5555;
    LUT4 i101_2_lut (.A(cnt_n[1]), .B(n3_adj_1), .Z(n19_adj_3)) /* synthesis lut_function=(!(A (B)+!A !(B))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(59[16:23])
    defparam i101_2_lut.init = 16'h6666;
    OB clkout_pad (.I(clkout_c), .O(clkout));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(18[9:15])
    FD1S3IX cnt_p_51__i0 (.D(n20), .CK(clk_c), .CD(n138), .Q(n3));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_51__i0.GSR = "ENABLED";
    LUT4 i86_3_lut (.A(cnt_p[2]), .B(cnt_p[1]), .C(n3), .Z(n18)) /* synthesis lut_function=(!(A (B (C))+!A !(B (C)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam i86_3_lut.init = 16'h6a6a;
    FD1S3IX cnt_n_50__i1 (.D(n19_adj_3), .CK(clk_N_8), .CD(n141), .Q(cnt_n[1]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(59[16:23])
    defparam cnt_n_50__i1.GSR = "ENABLED";
    FD1S3IX cnt_p_51__i2 (.D(n18), .CK(clk_c), .CD(n138), .Q(cnt_p[2]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_51__i2.GSR = "ENABLED";
    FD1S3IX cnt_p_51__i1 (.D(n19), .CK(clk_c), .CD(n138), .Q(cnt_p[1]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_51__i1.GSR = "ENABLED";
    LUT4 i79_2_lut (.A(cnt_p[1]), .B(n3), .Z(n19)) /* synthesis lut_function=(!(A (B)+!A !(B))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam i79_2_lut.init = 16'h6666;
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    VLO i116 (.Z(GND_net));
    
endmodule
//
// Verilog Description of module TSALL
// module not written out since it is a black-box. 
//

//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

