// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.10.3.144
// Netlist written on Thu Nov 26 04:55:55 2020
//
// Verilog Description of module LED_shining
//

module LED_shining (clk_in, rst_n_in, led1, led2, led3, led4, led5, 
            led6, led7, led8) /* synthesis syn_module_defined=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(1[8:19])
    input clk_in;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(3[8:14])
    input rst_n_in;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(4[8:16])
    output led1;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(5[9:13])
    output led2;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(6[9:13])
    output led3;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(7[9:13])
    output led4;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(8[9:13])
    output led5;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(9[9:13])
    output led6;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(10[9:13])
    output led7;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(11[9:13])
    output led8;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(12[9:13])
    
    wire clk_in_c /* synthesis SET_AS_NETWORK=clk_in_c, is_clock=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(3[8:14])
    wire clk /* synthesis is_clock=1, SET_AS_NETWORK=clk */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(15[6:9])
    
    wire GND_net, rst_n_in_c, led1_c, led2_c, led3_c, led4_c, led5_c, 
        led6_c, led7_c, led8_c;
    wire [11:0]address;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(27[12:19])
    wire [17:0]instruction;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(28[13:24])
    
    wire write_strobe;
    wire [7:0]port_id;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(31[12:19])
    wire [7:0]out_port;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(31[21:29])
    
    wire n5, n7, n8, n9, n10, n11, n12, n13, n14;
    wire [19:0]cnt_p;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(27[22:27])
    
    wire n13_adj_239, n11_adj_240, n2006, s_15_4, s_15_5, n2128, 
        n114, n32, clk_enable_13, VCC_net, n2, n2180, n7_adj_241, 
        n2_adj_242, n7_adj_243;
    
    OB led5_pad (.I(led5_c), .O(led5));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(9[9:13])
    OB led3_pad (.I(led3_c), .O(led3));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(7[9:13])
    LUT4 select_6_Select_2_i3_2_lut (.A(n5), .B(out_port[2]), .Z(n12)) /* synthesis lut_function=(A+(B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(39[4] 42[11])
    defparam select_6_Select_2_i3_2_lut.init = 16'heeee;
    LUT4 i7_4_lut (.A(n13_adj_239), .B(n11_adj_240), .C(port_id[1]), .D(port_id[7]), 
         .Z(n5)) /* synthesis lut_function=(A+(B+((D)+!C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(40[5:10])
    defparam i7_4_lut.init = 16'hffef;
    LUT4 i5_4_lut (.A(port_id[0]), .B(port_id[2]), .C(port_id[6]), .D(port_id[4]), 
         .Z(n13_adj_239)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(40[5:10])
    defparam i5_4_lut.init = 16'hfffe;
    FD1P3JX out_i3 (.D(n12), .SP(clk_enable_13), .PD(n2128), .CK(clk), 
            .Q(led3_c));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(33[8] 45[4])
    defparam out_i3.GSR = "DISABLED";
    LUT4 i3_2_lut (.A(port_id[3]), .B(port_id[5]), .Z(n11_adj_240)) /* synthesis lut_function=(A+(B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(40[5:10])
    defparam i3_2_lut.init = 16'heeee;
    LUT4 select_6_Select_6_i3_2_lut (.A(n5), .B(out_port[6]), .Z(n8)) /* synthesis lut_function=(A+(B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(39[4] 42[11])
    defparam select_6_Select_6_i3_2_lut.init = 16'heeee;
    LUT4 select_6_Select_7_i3_2_lut (.A(n5), .B(out_port[7]), .Z(n7)) /* synthesis lut_function=(A+(B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(39[4] 42[11])
    defparam select_6_Select_7_i3_2_lut.init = 16'heeee;
    OB led7_pad (.I(led7_c), .O(led7));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(11[9:13])
    FD1P3JX out_i4 (.D(n11), .SP(clk_enable_13), .PD(n2128), .CK(clk), 
            .Q(led4_c));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(33[8] 45[4])
    defparam out_i4.GSR = "DISABLED";
    FD1P3JX out_i5 (.D(n10), .SP(clk_enable_13), .PD(n2128), .CK(clk), 
            .Q(led5_c));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(33[8] 45[4])
    defparam out_i5.GSR = "DISABLED";
    IB clk_in_pad (.I(clk_in), .O(clk_in_c));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(3[8:14])
    FD1P3JX out_i6 (.D(n9), .SP(clk_enable_13), .PD(n2128), .CK(clk), 
            .Q(led6_c));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(33[8] 45[4])
    defparam out_i6.GSR = "DISABLED";
    OB led8_pad (.I(led8_c), .O(led8));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(12[9:13])
    OB led4_pad (.I(led4_c), .O(led4));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(8[9:13])
    FD1P3JX out_i7 (.D(n8), .SP(clk_enable_13), .PD(n2128), .CK(clk), 
            .Q(led7_c));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(33[8] 45[4])
    defparam out_i7.GSR = "DISABLED";
    FD1P3JX out_i8 (.D(n7), .SP(clk_enable_13), .PD(n2128), .CK(clk), 
            .Q(led8_c));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(33[8] 45[4])
    defparam out_i8.GSR = "DISABLED";
    OB led6_pad (.I(led6_c), .O(led6));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(10[9:13])
    OB led1_pad (.I(led1_c), .O(led1));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(5[9:13])
    OB led2_pad (.I(led2_c), .O(led2));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(6[9:13])
    FD1P3IX out_i2 (.D(n13), .SP(write_strobe), .CD(n2128), .CK(clk), 
            .Q(led2_c));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(33[8] 45[4])
    defparam out_i2.GSR = "DISABLED";
    LUT4 select_6_Select_1_i3_2_lut (.A(n5), .B(out_port[1]), .Z(n13)) /* synthesis lut_function=(A+(B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(39[4] 42[11])
    defparam select_6_Select_1_i3_2_lut.init = 16'heeee;
    FD1P3IX out_i1 (.D(n14), .SP(write_strobe), .CD(n2128), .CK(clk), 
            .Q(led1_c));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(33[8] 45[4])
    defparam out_i1.GSR = "DISABLED";
    IB rst_n_in_pad (.I(rst_n_in), .O(rst_n_in_c));   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(4[8:16])
    VLO i1 (.Z(GND_net));
    LUT4 select_6_Select_0_i3_2_lut (.A(n5), .B(out_port[0]), .Z(n14)) /* synthesis lut_function=(A+(B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(39[4] 42[11])
    defparam select_6_Select_0_i3_2_lut.init = 16'heeee;
    TSALL TSALL_INST (.TSALL(GND_net));
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    GSR GSR_INST (.GSR(rst_n_in_c));
    mcu mcu (.\instruction[11] (instruction[11]), .\instruction[7] (instruction[7]), 
        .\instruction[14] (instruction[14]), .\instruction[15] (instruction[15]), 
        .n2(n2_adj_242), .out_port({out_port}), .clk(clk), .\instruction[12] (instruction[12]), 
        .\instruction[17] (instruction[17]), .n2180(n2180), .\instruction[13] (instruction[13]), 
        .\instruction[16] (instruction[16]), .port_id({port_id}), .write_strobe(write_strobe), 
        .address({address}), .GND_net(GND_net), .s_15_4(s_15_4), .s_15_5(s_15_5), 
        .n7(n7_adj_241), .n7_adj_3(n7_adj_243), .rst_n_in_c(rst_n_in_c), 
        .n2128(n2128), .clk_enable_13(clk_enable_13), .\cnt_p[19] (cnt_p[19]), 
        .n32(n32), .n2006(n2006), .n114(n114), .n2_adj_4(n2)) /* synthesis syn_module_defined=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(47[5] 58[2])
    VHI i1718 (.Z(VCC_net));
    rom rom (.address({address}), .\instruction[11] (instruction[11]), .clk(clk), 
        .\instruction[16] (instruction[16]), .\instruction[15] (instruction[15]), 
        .\instruction[7] (instruction[7]), .n2180(n2180), .s_15_4(s_15_4), 
        .n2(n2), .n7(n7_adj_241), .\instruction[12] (instruction[12]), 
        .\instruction[14] (instruction[14]), .\instruction[17] (instruction[17]), 
        .\instruction[13] (instruction[13]), .s_15_5(s_15_5), .n2_adj_1(n2_adj_242), 
        .n7_adj_2(n7_adj_243)) /* synthesis syn_module_defined=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(60[5] 65[2])
    \divide(N=1000000)  u1 (.clk(clk), .clk_in_c(clk_in_c), .n2128(n2128), 
            .GND_net(GND_net), .n32(n32), .n2006(n2006), .\cnt_p[19] (cnt_p[19]), 
            .n114(n114)) /* synthesis syn_module_defined=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(21[3] 25[2])
    LUT4 select_6_Select_5_i3_2_lut (.A(n5), .B(out_port[5]), .Z(n9)) /* synthesis lut_function=(A+(B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(39[4] 42[11])
    defparam select_6_Select_5_i3_2_lut.init = 16'heeee;
    LUT4 select_6_Select_4_i3_2_lut (.A(n5), .B(out_port[4]), .Z(n10)) /* synthesis lut_function=(A+(B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(39[4] 42[11])
    defparam select_6_Select_4_i3_2_lut.init = 16'heeee;
    LUT4 select_6_Select_3_i3_2_lut (.A(n5), .B(out_port[3]), .Z(n11)) /* synthesis lut_function=(A+(B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(39[4] 42[11])
    defparam select_6_Select_3_i3_2_lut.init = 16'heeee;
    
endmodule
//
// Verilog Description of module TSALL
// module not written out since it is a black-box. 
//

//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

//
// Verilog Description of module mcu
//

module mcu (\instruction[11] , \instruction[7] , \instruction[14] , \instruction[15] , 
            n2, out_port, clk, \instruction[12] , \instruction[17] , 
            n2180, \instruction[13] , \instruction[16] , port_id, write_strobe, 
            address, GND_net, s_15_4, s_15_5, n7, n7_adj_3, rst_n_in_c, 
            n2128, clk_enable_13, \cnt_p[19] , n32, n2006, n114, 
            n2_adj_4) /* synthesis syn_module_defined=1 */ ;
    input \instruction[11] ;
    input \instruction[7] ;
    input \instruction[14] ;
    input \instruction[15] ;
    output n2;
    output [7:0]out_port;
    input clk;
    input \instruction[12] ;
    input \instruction[17] ;
    output n2180;
    input \instruction[13] ;
    input \instruction[16] ;
    output [7:0]port_id;
    output write_strobe;
    output [11:0]address;
    input GND_net;
    output s_15_4;
    output s_15_5;
    input n7;
    input n7_adj_3;
    input rst_n_in_c;
    output n2128;
    output clk_enable_13;
    input \cnt_p[19] ;
    input n32;
    input n2006;
    output n114;
    output n2_adj_4;
    
    wire clk /* synthesis is_clock=1, SET_AS_NETWORK=clk */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(15[6:9])
    
    wire n2119, s_0_2, n2_c, n10, s_0_6, clk_enable_30;
    wire [0:0]C_N_155;
    
    wire n1113, n2126, s_0_7, s_15_7;
    wire [0:0]C_N_161;
    
    wire n2_adj_209, s_0_0, n830, n7_c, n2120, n868, C, clk_enable_3;
    wire [17:0]pc;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(34[12:14])
    
    wire clk_enable_52, n2032;
    wire [17:0]n417;
    
    wire s_15_0, n2_adj_210, jp, jp_N_109, n11, n20, n2019, n2122, 
        n2125, n2113, clk_enable_40;
    wire [7:0]n281;
    
    wire n2121, n2123, n8, clk_enable_10, n7_adj_211, s_0_1, n1892, 
        n1894, s_0_3, n9, s_0_4, n9_adj_212, s_0_5, n9_adj_213, 
        n1896, n1898, clk_enable_19, n2127, n6, n1, n7_adj_214, 
        n8_adj_215, n2117, s_15_1, n1809, n1810, s_15_2, clk_enable_20, 
        n7_adj_216, s_15_3, n7_adj_217, n7_adj_218, s_15_6, n7_adj_221, 
        n2115, n2124, n8_adj_222;
    wire [17:0]address_11__N_90;
    wire [7:0]n3;
    
    wire n1808, n2118, n2050, n1_adj_223, n2111, n1_adj_224, n2_adj_225, 
        n1_adj_226, n2112, n1_adj_227, n1813, n1812;
    wire [7:0]s_N_134;
    
    wire n26, n4, n25, n1811, n2109, n2_adj_228, n1_adj_229, n2_adj_230, 
        n1_adj_231, n1_adj_232, n2_adj_233, n6_adj_235, n2_adj_236, 
        n2_adj_237;
    
    LUT4 PrioSelect_540_i2_3_lut_4_lut (.A(n2119), .B(\instruction[11] ), 
         .C(\instruction[7] ), .D(s_0_2), .Z(n2_c)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(70[30:34])
    defparam PrioSelect_540_i2_3_lut_4_lut.init = 16'hf780;
    LUT4 i5_3_lut_rep_29 (.A(\instruction[14] ), .B(n10), .C(\instruction[15] ), 
         .Z(n2119)) /* synthesis lut_function=(!(A+((C)+!B))) */ ;
    defparam i5_3_lut_rep_29.init = 16'h0404;
    LUT4 PrioSelect_556_i2_3_lut_4_lut (.A(n2119), .B(\instruction[11] ), 
         .C(\instruction[7] ), .D(s_0_6), .Z(n2)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(70[30:34])
    defparam PrioSelect_556_i2_3_lut_4_lut.init = 16'hf780;
    FD1P3AX out_port_i0_i0 (.D(C_N_155[0]), .SP(clk_enable_30), .CK(clk), 
            .Q(out_port[0])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam out_port_i0_i0.GSR = "DISABLED";
    LUT4 i4_4_lut (.A(\instruction[12] ), .B(n1113), .C(n2126), .D(\instruction[17] ), 
         .Z(n10)) /* synthesis lut_function=(!((B+((D)+!C))+!A)) */ ;
    defparam i4_4_lut.init = 16'h0020;
    LUT4 i489_3_lut (.A(s_0_7), .B(s_15_7), .C(\instruction[11] ), .Z(C_N_161[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(74[63:67])
    defparam i489_3_lut.init = 16'hcaca;
    LUT4 PrioSelect_560_i2_3_lut_4_lut (.A(n2119), .B(\instruction[11] ), 
         .C(\instruction[7] ), .D(s_0_7), .Z(n2_adj_209)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(70[30:34])
    defparam PrioSelect_560_i2_3_lut_4_lut.init = 16'hf780;
    LUT4 i1072_4_lut (.A(s_0_0), .B(n2180), .C(\instruction[13] ), .D(n830), 
         .Z(n7_c)) /* synthesis lut_function=(!(A (B+!(C+!(D)))+!A (B+!(C (D))))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam i1072_4_lut.init = 16'h3022;
    LUT4 i3_4_lut (.A(\instruction[7] ), .B(n2126), .C(\instruction[11] ), 
         .D(n2120), .Z(n868)) /* synthesis lut_function=(A+(((D)+!C)+!B)) */ ;
    defparam i3_4_lut.init = 16'hffbf;
    FD1P3AX C_246 (.D(C_N_161[0]), .SP(clk_enable_3), .CK(clk), .Q(C));   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam C_246.GSR = "DISABLED";
    FD1P3IX pc__i13 (.D(n417[12]), .SP(clk_enable_52), .CD(n2032), .CK(clk), 
            .Q(pc[12])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam pc__i13.GSR = "ENABLED";
    LUT4 PrioSelect_52_i2_3_lut_4_lut (.A(n2119), .B(\instruction[11] ), 
         .C(\instruction[13] ), .D(s_15_0), .Z(n2_adj_210)) /* synthesis lut_function=(A (B (D)+!B (C))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(70[30:34])
    defparam PrioSelect_52_i2_3_lut_4_lut.init = 16'hfd20;
    FD1S3AY jp_243 (.D(jp_N_109), .CK(clk), .Q(jp)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam jp_243.GSR = "ENABLED";
    LUT4 i481_2_lut_4_lut (.A(\instruction[14] ), .B(n10), .C(\instruction[15] ), 
         .D(\instruction[11] ), .Z(n830)) /* synthesis lut_function=(!(A+((C+!(D))+!B))) */ ;
    defparam i481_2_lut_4_lut.init = 16'h0400;
    LUT4 i1_3_lut (.A(n11), .B(jp), .C(n20), .Z(clk_enable_52)) /* synthesis lut_function=(!(A (B+!(C))+!A (B))) */ ;
    defparam i1_3_lut.init = 16'h3131;
    LUT4 i1_2_lut_rep_23_4_lut (.A(n2019), .B(\instruction[16] ), .C(n2122), 
         .D(n2125), .Z(n2113)) /* synthesis lut_function=(A+((C+(D))+!B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(102[17:26])
    defparam i1_2_lut_rep_23_4_lut.init = 16'hfffb;
    LUT4 i1683_2_lut (.A(n11), .B(jp), .Z(n2032)) /* synthesis lut_function=(!(A+(B))) */ ;
    defparam i1683_2_lut.init = 16'h1111;
    FD1P3AX port_id_i0_i0 (.D(n281[0]), .SP(clk_enable_40), .CK(clk), 
            .Q(port_id[0])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam port_id_i0_i0.GSR = "DISABLED";
    FD1S3IX write_strobe_241 (.D(n2121), .CK(clk), .CD(jp), .Q(write_strobe));   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam write_strobe_241.GSR = "ENABLED";
    LUT4 i22_3_lut_4_lut (.A(n2113), .B(n2123), .C(s_0_6), .D(\instruction[7] ), 
         .Z(n8)) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i22_3_lut_4_lut.init = 16'hfb40;
    FD1P3AX s_0_0_c (.D(n7_adj_211), .SP(clk_enable_10), .CK(clk), .Q(s_0_0)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam s_0_0_c.GSR = "DISABLED";
    FD1S3AX s_0_1_c (.D(n1892), .CK(clk), .Q(s_0_1)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam s_0_1_c.GSR = "DISABLED";
    FD1S3AX s_0_2_c (.D(n1894), .CK(clk), .Q(s_0_2)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam s_0_2_c.GSR = "DISABLED";
    FD1S3AX s_0_3_c (.D(n9), .CK(clk), .Q(s_0_3)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam s_0_3_c.GSR = "DISABLED";
    FD1S3AX s_0_4_c (.D(n9_adj_212), .CK(clk), .Q(s_0_4)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam s_0_4_c.GSR = "DISABLED";
    FD1S3AX s_0_5_c (.D(n9_adj_213), .CK(clk), .Q(s_0_5)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam s_0_5_c.GSR = "DISABLED";
    FD1S3AX s_0_6_c (.D(n1896), .CK(clk), .Q(s_0_6)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam s_0_6_c.GSR = "DISABLED";
    FD1S3AX s_0_7_c (.D(n1898), .CK(clk), .Q(s_0_7)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam s_0_7_c.GSR = "DISABLED";
    FD1P3AX s_15_0_c (.D(n7_c), .SP(clk_enable_19), .CK(clk), .Q(s_15_0)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam s_15_0_c.GSR = "DISABLED";
    LUT4 i4_4_lut_adj_16 (.A(\instruction[16] ), .B(n2127), .C(\instruction[17] ), 
         .D(n6), .Z(n11)) /* synthesis lut_function=(A+(B+((D)+!C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(101[17:27])
    defparam i4_4_lut_adj_16.init = 16'hffef;
    LUT4 i581_4_lut (.A(n830), .B(s_15_0), .C(n2180), .D(n1), .Z(n7_adj_214)) /* synthesis lut_function=(A (B+!(C))+!A (B (C+(D))+!B !(C+!(D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam i581_4_lut.init = 16'hcfca;
    LUT4 i1_2_lut (.A(\instruction[14] ), .B(\instruction[13] ), .Z(n6)) /* synthesis lut_function=(A+!(B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(101[17:27])
    defparam i1_2_lut.init = 16'hbbbb;
    LUT4 i22_3_lut_4_lut_adj_17 (.A(n2113), .B(n2123), .C(s_0_5), .D(\instruction[7] ), 
         .Z(n8_adj_215)) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i22_3_lut_4_lut_adj_17.init = 16'hfb40;
    LUT4 i1_2_lut_rep_27_4_lut (.A(\instruction[14] ), .B(n10), .C(\instruction[15] ), 
         .D(\instruction[11] ), .Z(n2117)) /* synthesis lut_function=(!(A+((C+(D))+!B))) */ ;
    defparam i1_2_lut_rep_27_4_lut.init = 16'h0004;
    LUT4 i511_3_lut (.A(s_0_1), .B(s_15_1), .C(n868), .Z(n1)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam i511_3_lut.init = 16'hcaca;
    CCU2D add_193_5 (.A0(address[3]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(address[4]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n1809), .COUT(n1810), .S0(n417[3]), .S1(n417[4]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(96[37:46])
    defparam add_193_5.INIT0 = 16'h5aaa;
    defparam add_193_5.INIT1 = 16'h5aaa;
    defparam add_193_5.INJECT1_0 = "NO";
    defparam add_193_5.INJECT1_1 = "NO";
    FD1S3AX s_15_1_c (.D(n7_adj_214), .CK(clk), .Q(s_15_1)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam s_15_1_c.GSR = "DISABLED";
    FD1P3AX s_15_2_c (.D(n7_adj_216), .SP(clk_enable_20), .CK(clk), .Q(s_15_2)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam s_15_2_c.GSR = "DISABLED";
    FD1P3AX s_15_3_c (.D(n7_adj_217), .SP(clk_enable_20), .CK(clk), .Q(s_15_3)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam s_15_3_c.GSR = "DISABLED";
    FD1P3AX s_15_4_c (.D(n7_adj_218), .SP(clk_enable_20), .CK(clk), .Q(s_15_4)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam s_15_4_c.GSR = "DISABLED";
    FD1P3AX s_15_5_c (.D(n7), .SP(clk_enable_19), .CK(clk), .Q(s_15_5)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam s_15_5_c.GSR = "DISABLED";
    FD1P3AX s_15_6_c (.D(n7_adj_3), .SP(clk_enable_19), .CK(clk), .Q(s_15_6)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam s_15_6_c.GSR = "DISABLED";
    FD1P3AX s_15_7_c (.D(n7_adj_221), .SP(clk_enable_20), .CK(clk), .Q(s_15_7)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam s_15_7_c.GSR = "DISABLED";
    LUT4 i1_2_lut_rep_25_4_lut (.A(n2122), .B(\instruction[14] ), .C(n1113), 
         .D(\instruction[7] ), .Z(n2115)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(101[17:27])
    defparam i1_2_lut_rep_25_4_lut.init = 16'h0100;
    LUT4 i1029_2_lut_4_lut (.A(n2124), .B(\instruction[16] ), .C(n2019), 
         .D(n2126), .Z(clk_enable_30)) /* synthesis lut_function=(!((B+(C+!(D)))+!A)) */ ;
    defparam i1029_2_lut_4_lut.init = 16'h0200;
    LUT4 i22_3_lut_4_lut_adj_18 (.A(n2113), .B(n2123), .C(s_0_1), .D(\instruction[7] ), 
         .Z(n8_adj_222)) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i22_3_lut_4_lut_adj_18.init = 16'hfb40;
    FD1P3AX pc__i1 (.D(address_11__N_90[0]), .SP(clk_enable_52), .CK(clk), 
            .Q(address[0])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam pc__i1.GSR = "ENABLED";
    FD1P3AX out_port_i0_i1 (.D(n3[1]), .SP(clk_enable_30), .CK(clk), .Q(out_port[1])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam out_port_i0_i1.GSR = "DISABLED";
    CCU2D add_193_3 (.A0(address[1]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(address[2]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n1808), .COUT(n1809), .S0(n417[1]), .S1(n417[2]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(96[37:46])
    defparam add_193_3.INIT0 = 16'h5aaa;
    defparam add_193_3.INIT1 = 16'h5aaa;
    defparam add_193_3.INJECT1_0 = "NO";
    defparam add_193_3.INJECT1_1 = "NO";
    LUT4 mux_41_i1_4_lut (.A(\instruction[13] ), .B(n417[0]), .C(n11), 
         .D(n20), .Z(address_11__N_90[0])) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (C (D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(95[12] 104[19])
    defparam mux_41_i1_4_lut.init = 16'hca0a;
    LUT4 i357_3_lut (.A(s_0_1), .B(s_15_1), .C(\instruction[11] ), .Z(n3[1])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(74[63:67])
    defparam i357_3_lut.init = 16'hcaca;
    LUT4 i1684_2_lut_3_lut_4_lut (.A(n2125), .B(n2118), .C(n2117), .D(n2123), 
         .Z(n2050)) /* synthesis lut_function=(A (C)+!A (B (C)+!B (C+(D)))) */ ;
    defparam i1684_2_lut_3_lut_4_lut.init = 16'hf1f0;
    LUT4 i350_3_lut (.A(s_0_2), .B(s_15_2), .C(\instruction[11] ), .Z(n3[2])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(74[63:67])
    defparam i350_3_lut.init = 16'hcaca;
    FD1P3AX out_port_i0_i2 (.D(n3[2]), .SP(clk_enable_30), .CK(clk), .Q(out_port[2])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam out_port_i0_i2.GSR = "DISABLED";
    FD1P3AX out_port_i0_i3 (.D(n3[3]), .SP(clk_enable_30), .CK(clk), .Q(out_port[3])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam out_port_i0_i3.GSR = "DISABLED";
    FD1P3AX out_port_i0_i4 (.D(n3[4]), .SP(clk_enable_30), .CK(clk), .Q(out_port[4])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam out_port_i0_i4.GSR = "DISABLED";
    FD1P3AX out_port_i0_i5 (.D(n3[5]), .SP(clk_enable_30), .CK(clk), .Q(out_port[5])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam out_port_i0_i5.GSR = "DISABLED";
    FD1P3AX out_port_i0_i6 (.D(n3[6]), .SP(clk_enable_30), .CK(clk), .Q(out_port[6])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam out_port_i0_i6.GSR = "DISABLED";
    FD1P3AX out_port_i0_i7 (.D(C_N_161[0]), .SP(clk_enable_30), .CK(clk), 
            .Q(out_port[7])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam out_port_i0_i7.GSR = "DISABLED";
    LUT4 i504_3_lut_4_lut (.A(n2123), .B(n2115), .C(s_15_6), .D(s_0_6), 
         .Z(n1_adj_223)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i504_3_lut_4_lut.init = 16'hf780;
    LUT4 i2_3_lut_rep_28_4_lut (.A(\instruction[17] ), .B(n2127), .C(\instruction[16] ), 
         .D(n2019), .Z(n2118)) /* synthesis lut_function=(A+(B+((D)+!C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(101[17:27])
    defparam i2_3_lut_rep_28_4_lut.init = 16'hffef;
    LUT4 i2_3_lut_rep_30_4_lut (.A(\instruction[17] ), .B(n2127), .C(n1113), 
         .D(\instruction[14] ), .Z(n2120)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(101[17:27])
    defparam i2_3_lut_rep_30_4_lut.init = 16'hfffe;
    LUT4 i343_3_lut (.A(s_0_3), .B(s_15_3), .C(\instruction[11] ), .Z(n3[3])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(74[63:67])
    defparam i343_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut_rep_21_3_lut_4_lut (.A(n2126), .B(\instruction[11] ), 
         .C(n2118), .D(n2125), .Z(n2111)) /* synthesis lut_function=(!((B+(C+(D)))+!A)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i1_2_lut_rep_21_3_lut_4_lut.init = 16'h0002;
    LUT4 i498_3_lut_4_lut (.A(n2123), .B(n2115), .C(s_15_3), .D(s_0_3), 
         .Z(n1_adj_224)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i498_3_lut_4_lut.init = 16'hf780;
    LUT4 PrioSelect_56_i2_3_lut_4_lut_4_lut (.A(n2126), .B(\instruction[11] ), 
         .C(s_0_0), .D(n2113), .Z(n2_adj_225)) /* synthesis lut_function=(A (B+!((D)+!C))+!A (B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam PrioSelect_56_i2_3_lut_4_lut_4_lut.init = 16'hccec;
    LUT4 i530_3_lut (.A(s_0_4), .B(s_15_4), .C(\instruction[11] ), .Z(n3[4])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(74[63:67])
    defparam i530_3_lut.init = 16'hcaca;
    LUT4 i1643_2_lut_rep_34 (.A(\instruction[17] ), .B(\instruction[15] ), 
         .Z(n2124)) /* synthesis lut_function=(A (B)) */ ;
    defparam i1643_2_lut_rep_34.init = 16'h8888;
    LUT4 i1_2_lut_adj_19 (.A(\instruction[13] ), .B(\instruction[16] ), 
         .Z(n1113)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut_adj_19.init = 16'heeee;
    FD1P3AX port_id_i0_i1 (.D(n281[1]), .SP(clk_enable_40), .CK(clk), 
            .Q(port_id[1])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam port_id_i0_i1.GSR = "DISABLED";
    FD1P3AX port_id_i0_i2 (.D(n281[2]), .SP(clk_enable_40), .CK(clk), 
            .Q(port_id[2])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam port_id_i0_i2.GSR = "DISABLED";
    FD1P3AX port_id_i0_i3 (.D(n281[3]), .SP(clk_enable_40), .CK(clk), 
            .Q(port_id[3])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam port_id_i0_i3.GSR = "DISABLED";
    FD1P3AX port_id_i0_i4 (.D(n281[4]), .SP(clk_enable_40), .CK(clk), 
            .Q(port_id[4])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam port_id_i0_i4.GSR = "DISABLED";
    FD1P3AX port_id_i0_i5 (.D(n281[5]), .SP(clk_enable_40), .CK(clk), 
            .Q(port_id[5])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam port_id_i0_i5.GSR = "DISABLED";
    FD1P3AX port_id_i0_i6 (.D(n281[6]), .SP(clk_enable_40), .CK(clk), 
            .Q(port_id[6])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam port_id_i0_i6.GSR = "DISABLED";
    FD1P3AX port_id_i0_i7 (.D(n281[7]), .SP(clk_enable_40), .CK(clk), 
            .Q(port_id[7])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam port_id_i0_i7.GSR = "DISABLED";
    LUT4 i1680_3_lut_rep_31_4_lut (.A(\instruction[17] ), .B(\instruction[15] ), 
         .C(n2019), .D(\instruction[16] ), .Z(n2121)) /* synthesis lut_function=(!(((C+(D))+!B)+!A)) */ ;
    defparam i1680_3_lut_rep_31_4_lut.init = 16'h0008;
    LUT4 i506_3_lut_4_lut (.A(n2123), .B(n2115), .C(s_15_7), .D(s_0_7), 
         .Z(n1_adj_226)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i506_3_lut_4_lut.init = 16'hf780;
    LUT4 i2_4_lut (.A(n2117), .B(n2123), .C(n2115), .D(n2112), .Z(clk_enable_10)) /* synthesis lut_function=(A+(B (C+(D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(28[13:24])
    defparam i2_4_lut.init = 16'heeea;
    LUT4 i1652_2_lut_rep_35 (.A(\instruction[13] ), .B(\instruction[7] ), 
         .Z(n2125)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1652_2_lut_rep_35.init = 16'heeee;
    PFUMX i11 (.BLUT(n1_adj_227), .ALUT(n2_adj_225), .C0(n2050), .Z(n1892));
    LUT4 i527_3_lut (.A(s_0_5), .B(s_15_5), .C(\instruction[11] ), .Z(n3[5])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(74[63:67])
    defparam i527_3_lut.init = 16'hcaca;
    CCU2D add_193_13 (.A0(address[11]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(pc[12]), .B1(GND_net), .C1(GND_net), .D1(GND_net), .CIN(n1813), 
          .S0(n417[11]), .S1(n417[12]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(96[37:46])
    defparam add_193_13.INIT0 = 16'h5aaa;
    defparam add_193_13.INIT1 = 16'h5aaa;
    defparam add_193_13.INJECT1_0 = "NO";
    defparam add_193_13.INJECT1_1 = "NO";
    LUT4 i524_3_lut (.A(s_0_6), .B(s_15_6), .C(\instruction[11] ), .Z(n3[6])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(74[63:67])
    defparam i524_3_lut.init = 16'hcaca;
    LUT4 i1_3_lut_rep_22_2_lut_3_lut (.A(\instruction[13] ), .B(\instruction[7] ), 
         .C(n2118), .Z(n2112)) /* synthesis lut_function=(!(A+(B+(C)))) */ ;
    defparam i1_3_lut_rep_22_2_lut_3_lut.init = 16'h0101;
    CCU2D add_193_11 (.A0(address[9]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(address[10]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n1812), .COUT(n1813), .S0(n417[9]), .S1(n417[10]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(96[37:46])
    defparam add_193_11.INIT0 = 16'h5aaa;
    defparam add_193_11.INIT1 = 16'h5aaa;
    defparam add_193_11.INJECT1_0 = "NO";
    defparam add_193_11.INJECT1_1 = "NO";
    LUT4 mux_75_i2_3_lut (.A(s_N_134[1]), .B(\instruction[11] ), .C(\instruction[12] ), 
         .Z(n281[1])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam mux_75_i2_3_lut.init = 16'hcaca;
    LUT4 i41_4_lut (.A(\instruction[15] ), .B(n26), .C(\instruction[17] ), 
         .D(n4), .Z(n20)) /* synthesis lut_function=(A (B (C))+!A (B (C+(D))+!B !(C+!(D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(95[12] 104[19])
    defparam i41_4_lut.init = 16'hc5c0;
    LUT4 i1_2_lut_adj_20 (.A(\instruction[16] ), .B(n25), .Z(n26)) /* synthesis lut_function=(!(A+!(B))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(95[12] 104[19])
    defparam i1_2_lut_adj_20.init = 16'h4444;
    LUT4 i282_3_lut (.A(s_0_1), .B(s_15_1), .C(\instruction[7] ), .Z(s_N_134[1])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(69[38:42])
    defparam i282_3_lut.init = 16'hcaca;
    CCU2D add_193_9 (.A0(address[7]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(address[8]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n1811), .COUT(n1812), .S0(n417[7]), .S1(n417[8]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(96[37:46])
    defparam add_193_9.INIT0 = 16'h5aaa;
    defparam add_193_9.INIT1 = 16'h5aaa;
    defparam add_193_9.INJECT1_0 = "NO";
    defparam add_193_9.INJECT1_1 = "NO";
    LUT4 mux_75_i3_4_lut (.A(s_0_2), .B(\instruction[7] ), .C(\instruction[12] ), 
         .D(s_15_2), .Z(n281[2])) /* synthesis lut_function=(A (B (C+(D))+!B !(C))+!A (B (C+(D)))) */ ;
    defparam mux_75_i3_4_lut.init = 16'hcec2;
    CCU2D add_193_7 (.A0(address[5]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(address[6]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n1810), .COUT(n1811), .S0(n417[5]), .S1(n417[6]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(96[37:46])
    defparam add_193_7.INIT0 = 16'h5aaa;
    defparam add_193_7.INIT1 = 16'h5aaa;
    defparam add_193_7.INJECT1_0 = "NO";
    defparam add_193_7.INJECT1_1 = "NO";
    LUT4 i1_2_lut_3_lut_4_lut (.A(\instruction[13] ), .B(\instruction[7] ), 
         .C(n2126), .D(n2118), .Z(clk_enable_3)) /* synthesis lut_function=(!(A+(B+((D)+!C)))) */ ;
    defparam i1_2_lut_3_lut_4_lut.init = 16'h0010;
    CCU2D add_193_1 (.A0(GND_net), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(address[0]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .COUT(n1808), .S1(n417[0]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(96[37:46])
    defparam add_193_1.INIT0 = 16'hF000;
    defparam add_193_1.INIT1 = 16'h5555;
    defparam add_193_1.INJECT1_0 = "NO";
    defparam add_193_1.INJECT1_1 = "NO";
    LUT4 i1_2_lut_rep_36 (.A(rst_n_in_c), .B(jp), .Z(n2126)) /* synthesis lut_function=(A (B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i1_2_lut_rep_36.init = 16'h8888;
    LUT4 i364_3_lut (.A(s_0_0), .B(s_15_0), .C(\instruction[11] ), .Z(C_N_155[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(74[63:67])
    defparam i364_3_lut.init = 16'hcaca;
    LUT4 mux_75_i4_4_lut (.A(s_0_3), .B(\instruction[7] ), .C(\instruction[12] ), 
         .D(s_15_3), .Z(n281[3])) /* synthesis lut_function=(A (B (C+(D))+!B !(C))+!A (B (C+(D)))) */ ;
    defparam mux_75_i4_4_lut.init = 16'hcec2;
    LUT4 mux_75_i5_4_lut (.A(s_0_4), .B(\instruction[7] ), .C(\instruction[12] ), 
         .D(s_15_4), .Z(n281[4])) /* synthesis lut_function=(A (B (C+(D))+!B !(C))+!A (B (C+(D)))) */ ;
    defparam mux_75_i5_4_lut.init = 16'hcec2;
    LUT4 i1_2_lut_rep_19_3_lut (.A(n2119), .B(\instruction[11] ), .C(n868), 
         .Z(n2109)) /* synthesis lut_function=(A (B+!(C))+!A !(C)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(70[30:34])
    defparam i1_2_lut_rep_19_3_lut.init = 16'h8f8f;
    LUT4 mux_75_i6_4_lut (.A(s_0_5), .B(\instruction[7] ), .C(\instruction[12] ), 
         .D(s_15_5), .Z(n281[5])) /* synthesis lut_function=(A (B (C+(D))+!B !(C))+!A (B (C+(D)))) */ ;
    defparam mux_75_i6_4_lut.init = 16'hcec2;
    LUT4 PrioSelect_544_i2_3_lut_4_lut (.A(n2119), .B(\instruction[11] ), 
         .C(\instruction[7] ), .D(s_0_3), .Z(n2_adj_228)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(70[30:34])
    defparam PrioSelect_544_i2_3_lut_4_lut.init = 16'hf780;
    LUT4 mux_75_i7_4_lut (.A(s_0_6), .B(\instruction[7] ), .C(\instruction[12] ), 
         .D(s_15_6), .Z(n281[6])) /* synthesis lut_function=(A (B (C+(D))+!B !(C))+!A (B (C+(D)))) */ ;
    defparam mux_75_i7_4_lut.init = 16'hcec2;
    LUT4 mux_75_i8_4_lut (.A(s_0_7), .B(\instruction[7] ), .C(\instruction[12] ), 
         .D(s_15_7), .Z(n281[7])) /* synthesis lut_function=(A (B (C+(D))+!B !(C))+!A (B (C+(D)))) */ ;
    defparam mux_75_i8_4_lut.init = 16'hcec2;
    LUT4 i1_2_lut_adj_21 (.A(\instruction[13] ), .B(\instruction[14] ), 
         .Z(n2019)) /* synthesis lut_function=(A+!(B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(101[17:27])
    defparam i1_2_lut_adj_21.init = 16'hbbbb;
    LUT4 i1_4_lut (.A(\instruction[13] ), .B(\instruction[14] ), .C(\instruction[12] ), 
         .D(\instruction[16] ), .Z(n4)) /* synthesis lut_function=(!(A+(B (C+!(D))+!B (D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(95[12] 104[19])
    defparam i1_4_lut.init = 16'h0411;
    PFUMX PrioSelect_68_i9 (.BLUT(n1_adj_229), .ALUT(n2_adj_230), .C0(n2050), 
          .Z(n9_adj_212)) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;
    LUT4 i1_2_lut_rep_33_3_lut (.A(rst_n_in_c), .B(jp), .C(\instruction[11] ), 
         .Z(n2123)) /* synthesis lut_function=(!(((C)+!B)+!A)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i1_2_lut_rep_33_3_lut.init = 16'h0808;
    LUT4 i1_2_lut_3_lut_4_lut_4_lut (.A(n2119), .B(\instruction[11] ), .C(n868), 
         .D(n2180), .Z(clk_enable_19)) /* synthesis lut_function=(A (B+!(C))+!A (B ((D)+!C)+!B !(C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(70[30:34])
    defparam i1_2_lut_3_lut_4_lut_4_lut.init = 16'hcf8f;
    LUT4 i1_2_lut_rep_37 (.A(\instruction[12] ), .B(\instruction[15] ), 
         .Z(n2127)) /* synthesis lut_function=(A+(B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(101[17:27])
    defparam i1_2_lut_rep_37.init = 16'heeee;
    LUT4 i496_3_lut_4_lut (.A(n2123), .B(n2115), .C(s_15_2), .D(s_0_2), 
         .Z(n1_adj_231)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i496_3_lut_4_lut.init = 16'hf780;
    LUT4 i494_3_lut_4_lut (.A(n2123), .B(n2115), .C(s_15_1), .D(s_0_1), 
         .Z(n1_adj_227)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i494_3_lut_4_lut.init = 16'hf780;
    LUT4 mux_41_i2_4_lut (.A(\instruction[11] ), .B(n417[1]), .C(n11), 
         .D(n20), .Z(address_11__N_90[1])) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (C (D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(95[12] 104[19])
    defparam mux_41_i2_4_lut.init = 16'hca0a;
    LUT4 mux_41_i3_4_lut (.A(\instruction[7] ), .B(n417[2]), .C(n11), 
         .D(n20), .Z(address_11__N_90[2])) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (C (D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(95[12] 104[19])
    defparam mux_41_i3_4_lut.init = 16'hca0a;
    PFUMX i14 (.BLUT(n1_adj_232), .ALUT(n2_adj_233), .C0(n2050), .Z(n9_adj_213));
    LUT4 mux_41_i4_4_lut (.A(\instruction[7] ), .B(n417[3]), .C(n11), 
         .D(n20), .Z(address_11__N_90[3])) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (C (D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(95[12] 104[19])
    defparam mux_41_i4_4_lut.init = 16'hca0a;
    LUT4 i1_2_lut_rep_32_3_lut (.A(\instruction[12] ), .B(\instruction[15] ), 
         .C(\instruction[17] ), .Z(n2122)) /* synthesis lut_function=(A+(B+(C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(101[17:27])
    defparam i1_2_lut_rep_32_3_lut.init = 16'hfefe;
    LUT4 i502_3_lut_4_lut (.A(n2123), .B(n2115), .C(s_15_5), .D(s_0_5), 
         .Z(n1_adj_232)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i502_3_lut_4_lut.init = 16'hf780;
    LUT4 mux_41_i5_4_lut (.A(\instruction[7] ), .B(n417[4]), .C(n11), 
         .D(n20), .Z(address_11__N_90[4])) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (C (D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(95[12] 104[19])
    defparam mux_41_i5_4_lut.init = 16'hca0a;
    LUT4 mux_41_i6_4_lut (.A(\instruction[7] ), .B(n417[5]), .C(n11), 
         .D(n20), .Z(address_11__N_90[5])) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (C (D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(95[12] 104[19])
    defparam mux_41_i6_4_lut.init = 16'hca0a;
    LUT4 i500_3_lut_4_lut (.A(n2123), .B(n2115), .C(s_15_4), .D(s_0_4), 
         .Z(n1_adj_229)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i500_3_lut_4_lut.init = 16'hf780;
    LUT4 i40_4_lut (.A(\instruction[14] ), .B(\instruction[13] ), .C(\instruction[15] ), 
         .D(\instruction[12] ), .Z(n25)) /* synthesis lut_function=(!(A (B+!(C))+!A ((C+(D))+!B))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(95[12] 104[19])
    defparam i40_4_lut.init = 16'h2024;
    LUT4 i4_1_lut_rep_38 (.A(rst_n_in_c), .Z(n2128)) /* synthesis lut_function=(!(A)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(34[5:14])
    defparam i4_1_lut_rep_38.init = 16'h5555;
    LUT4 i1_2_lut_2_lut (.A(rst_n_in_c), .B(write_strobe), .Z(clk_enable_13)) /* synthesis lut_function=((B)+!A) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(34[5:14])
    defparam i1_2_lut_2_lut.init = 16'hdddd;
    LUT4 mux_41_i7_4_lut (.A(\instruction[7] ), .B(n417[6]), .C(n11), 
         .D(n20), .Z(address_11__N_90[6])) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (C (D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(95[12] 104[19])
    defparam mux_41_i7_4_lut.init = 16'hca0a;
    LUT4 i27_4_lut_4_lut (.A(rst_n_in_c), .B(\cnt_p[19] ), .C(n32), .D(n2006), 
         .Z(n114)) /* synthesis lut_function=((B (C (D)))+!A) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(34[5:14])
    defparam i27_4_lut_4_lut.init = 16'hd555;
    LUT4 mux_41_i8_4_lut (.A(\instruction[7] ), .B(n417[7]), .C(n11), 
         .D(n20), .Z(address_11__N_90[7])) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (C (D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(95[12] 104[19])
    defparam mux_41_i8_4_lut.init = 16'hca0a;
    LUT4 mux_41_i9_4_lut (.A(\instruction[11] ), .B(n417[8]), .C(n11), 
         .D(n20), .Z(address_11__N_90[8])) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (C (D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(95[12] 104[19])
    defparam mux_41_i9_4_lut.init = 16'hca0a;
    LUT4 mux_41_i10_4_lut (.A(\instruction[11] ), .B(n417[9]), .C(n11), 
         .D(n20), .Z(address_11__N_90[9])) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (C (D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(95[12] 104[19])
    defparam mux_41_i10_4_lut.init = 16'hca0a;
    LUT4 PrioSelect_72_i2_4_lut_3_lut (.A(\instruction[7] ), .B(s_0_4), 
         .C(n2111), .Z(n2_adj_233)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam PrioSelect_72_i2_4_lut_3_lut.init = 16'hcaca;
    LUT4 PrioSelect_68_i2_4_lut_3_lut (.A(\instruction[7] ), .B(n2111), 
         .C(s_0_3), .Z(n2_adj_230)) /* synthesis lut_function=(A ((C)+!B)+!A (B (C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam PrioSelect_68_i2_4_lut_3_lut.init = 16'he2e2;
    LUT4 mux_41_i11_4_lut (.A(\instruction[11] ), .B(n417[10]), .C(n11), 
         .D(n20), .Z(address_11__N_90[10])) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (C (D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(95[12] 104[19])
    defparam mux_41_i11_4_lut.init = 16'hca0a;
    LUT4 i1_2_lut_4_lut (.A(\instruction[11] ), .B(n2180), .C(n2111), 
         .D(n2109), .Z(clk_enable_20)) /* synthesis lut_function=(A (B+(C+(D)))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam i1_2_lut_4_lut.init = 16'hffa8;
    LUT4 i1068_3_lut (.A(n6_adj_235), .B(\instruction[11] ), .C(n2180), 
         .Z(n7_adj_211)) /* synthesis lut_function=(A (B+!(C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam i1068_3_lut.init = 16'h8a8a;
    LUT4 PrioSelect_52_i6_4_lut (.A(n2_adj_210), .B(C), .C(n2111), .D(\instruction[11] ), 
         .Z(n6_adj_235)) /* synthesis lut_function=(A (B+((D)+!C))+!A !(((D)+!C)+!B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam PrioSelect_52_i6_4_lut.init = 16'haaca;
    LUT4 i583_3_lut_4_lut (.A(\instruction[11] ), .B(n2180), .C(s_15_1), 
         .D(n2_c), .Z(n7_adj_216)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i583_3_lut_4_lut.init = 16'hf780;
    LUT4 i585_3_lut_4_lut (.A(\instruction[11] ), .B(n2180), .C(s_15_2), 
         .D(n2_adj_228), .Z(n7_adj_217)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i585_3_lut_4_lut.init = 16'hf780;
    LUT4 mux_41_i12_4_lut (.A(\instruction[11] ), .B(n417[11]), .C(n11), 
         .D(n20), .Z(address_11__N_90[11])) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (C (D)))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(95[12] 104[19])
    defparam mux_41_i12_4_lut.init = 16'hca0a;
    LUT4 jp_I_0_1_lut (.A(jp), .Z(jp_N_109)) /* synthesis lut_function=(!(A)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(94[11:21])
    defparam jp_I_0_1_lut.init = 16'h5555;
    PFUMX i21 (.BLUT(n1_adj_231), .ALUT(n8_adj_222), .C0(n2050), .Z(n1894));
    LUT4 i587_3_lut_4_lut (.A(\instruction[11] ), .B(n2180), .C(s_15_3), 
         .D(n2_adj_236), .Z(n7_adj_218)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i587_3_lut_4_lut.init = 16'hf780;
    LUT4 PrioSelect_64_i2_4_lut_3_lut (.A(\instruction[7] ), .B(s_0_2), 
         .C(n2111), .Z(n2_adj_237)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(37[11:12])
    defparam PrioSelect_64_i2_4_lut_3_lut.init = 16'hcaca;
    LUT4 i275_3_lut (.A(s_0_0), .B(s_15_0), .C(\instruction[7] ), .Z(s_N_134[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(69[38:42])
    defparam i275_3_lut.init = 16'hcaca;
    LUT4 PrioSelect_548_i2_3_lut_4_lut (.A(n2119), .B(\instruction[11] ), 
         .C(\instruction[7] ), .D(s_0_4), .Z(n2_adj_236)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(70[30:34])
    defparam PrioSelect_548_i2_3_lut_4_lut.init = 16'hf780;
    LUT4 i664_3_lut_4_lut (.A(\instruction[11] ), .B(n2180), .C(s_15_6), 
         .D(n2_adj_209), .Z(n7_adj_221)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam i664_3_lut_4_lut.init = 16'hf780;
    FD1P3AX pc__i2 (.D(address_11__N_90[1]), .SP(clk_enable_52), .CK(clk), 
            .Q(address[1])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam pc__i2.GSR = "ENABLED";
    LUT4 PrioSelect_552_i2_3_lut_4_lut (.A(n2119), .B(\instruction[11] ), 
         .C(\instruction[7] ), .D(s_0_5), .Z(n2_adj_4)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(70[30:34])
    defparam PrioSelect_552_i2_3_lut_4_lut.init = 16'hf780;
    PFUMX i12 (.BLUT(n1_adj_224), .ALUT(n2_adj_237), .C0(n2050), .Z(n9));
    LUT4 mux_75_i1_3_lut (.A(s_N_134[0]), .B(\instruction[13] ), .C(\instruction[12] ), 
         .Z(n281[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam mux_75_i1_3_lut.init = 16'hcaca;
    PFUMX i21_adj_22 (.BLUT(n1_adj_223), .ALUT(n8_adj_215), .C0(n2050), 
          .Z(n1896));
    LUT4 i1689_4_lut (.A(\instruction[14] ), .B(n2126), .C(n1113), .D(n2124), 
         .Z(clk_enable_40)) /* synthesis lut_function=(!(((C+!(D))+!B)+!A)) */ ;
    defparam i1689_4_lut.init = 16'h0800;
    PFUMX i21_adj_23 (.BLUT(n1_adj_226), .ALUT(n8), .C0(n2050), .Z(n1898));
    LUT4 i655_3_lut_rep_39_4_lut (.A(\instruction[11] ), .B(n2125), .C(n2126), 
         .D(n2118), .Z(n2180)) /* synthesis lut_function=(!((B+((D)+!C))+!A)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(78[26] 87[114])
    defparam i655_3_lut_rep_39_4_lut.init = 16'h0020;
    FD1P3AX pc__i3 (.D(address_11__N_90[2]), .SP(clk_enable_52), .CK(clk), 
            .Q(address[2])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam pc__i3.GSR = "ENABLED";
    FD1P3AX pc__i4 (.D(address_11__N_90[3]), .SP(clk_enable_52), .CK(clk), 
            .Q(address[3])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam pc__i4.GSR = "ENABLED";
    FD1P3AX pc__i5 (.D(address_11__N_90[4]), .SP(clk_enable_52), .CK(clk), 
            .Q(address[4])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam pc__i5.GSR = "ENABLED";
    FD1P3AX pc__i6 (.D(address_11__N_90[5]), .SP(clk_enable_52), .CK(clk), 
            .Q(address[5])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam pc__i6.GSR = "ENABLED";
    FD1P3AX pc__i7 (.D(address_11__N_90[6]), .SP(clk_enable_52), .CK(clk), 
            .Q(address[6])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam pc__i7.GSR = "ENABLED";
    FD1P3AX pc__i8 (.D(address_11__N_90[7]), .SP(clk_enable_52), .CK(clk), 
            .Q(address[7])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam pc__i8.GSR = "ENABLED";
    FD1P3AX pc__i9 (.D(address_11__N_90[8]), .SP(clk_enable_52), .CK(clk), 
            .Q(address[8])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam pc__i9.GSR = "ENABLED";
    FD1P3AX pc__i10 (.D(address_11__N_90[9]), .SP(clk_enable_52), .CK(clk), 
            .Q(address[9])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam pc__i10.GSR = "ENABLED";
    FD1P3AX pc__i11 (.D(address_11__N_90[10]), .SP(clk_enable_52), .CK(clk), 
            .Q(address[10])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam pc__i11.GSR = "ENABLED";
    FD1P3AX pc__i12 (.D(address_11__N_90[11]), .SP(clk_enable_52), .CK(clk), 
            .Q(address[11])) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=47, LSE_RLINE=58 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/mcu.v(65[9] 108[7])
    defparam pc__i12.GSR = "ENABLED";
    
endmodule
//
// Verilog Description of module rom
//

module rom (address, \instruction[11] , clk, \instruction[16] , \instruction[15] , 
            \instruction[7] , n2180, s_15_4, n2, n7, \instruction[12] , 
            \instruction[14] , \instruction[17] , \instruction[13] , s_15_5, 
            n2_adj_1, n7_adj_2) /* synthesis syn_module_defined=1 */ ;
    input [11:0]address;
    output \instruction[11] ;
    input clk;
    output \instruction[16] ;
    output \instruction[15] ;
    output \instruction[7] ;
    input n2180;
    input s_15_4;
    input n2;
    output n7;
    output \instruction[12] ;
    output \instruction[14] ;
    output \instruction[17] ;
    output \instruction[13] ;
    input s_15_5;
    input n2_adj_1;
    output n7_adj_2;
    
    wire clk /* synthesis is_clock=1, SET_AS_NETWORK=clk */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(15[6:9])
    
    wire n1, n17, n16, clk_enable_41, n1192, n1182;
    wire [17:0]n421;
    
    LUT4 i193_1_lut (.A(address[0]), .Z(n1)) /* synthesis lut_function=(!(A)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(13[7] 18[15])
    defparam i193_1_lut.init = 16'h5555;
    LUT4 i1693_4_lut (.A(n17), .B(address[7]), .C(n16), .D(address[3]), 
         .Z(clk_enable_41)) /* synthesis lut_function=(!(A+(B+(C+(D))))) */ ;
    defparam i1693_4_lut.init = 16'h0001;
    FD1P3JX y__i2 (.D(n1), .SP(clk_enable_41), .PD(n1192), .CK(clk), 
            .Q(\instruction[11] )) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=60, LSE_RLINE=65 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam y__i2.GSR = "DISABLED";
    LUT4 i810_2_lut (.A(clk_enable_41), .B(address[1]), .Z(n1182)) /* synthesis lut_function=(A (B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam i810_2_lut.init = 16'h8888;
    LUT4 i7_4_lut (.A(address[2]), .B(address[10]), .C(address[11]), .D(address[4]), 
         .Z(n17)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i7_4_lut.init = 16'hfffe;
    LUT4 i6_4_lut (.A(address[9]), .B(address[5]), .C(address[6]), .D(address[8]), 
         .Z(n16)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i6_4_lut.init = 16'hfffe;
    LUT4 i1687_2_lut (.A(clk_enable_41), .B(address[1]), .Z(n1192)) /* synthesis lut_function=(!((B)+!A)) */ ;
    defparam i1687_2_lut.init = 16'h2222;
    FD1P3IX y__i7 (.D(address[0]), .SP(clk_enable_41), .CD(n1182), .CK(clk), 
            .Q(\instruction[16] )) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=60, LSE_RLINE=65 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam y__i7.GSR = "DISABLED";
    FD1P3IX y__i6 (.D(n1), .SP(clk_enable_41), .CD(n1192), .CK(clk), 
            .Q(\instruction[15] )) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=60, LSE_RLINE=65 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam y__i6.GSR = "DISABLED";
    FD1P3IX y__i1 (.D(n1), .SP(clk_enable_41), .CD(n1182), .CK(clk), 
            .Q(\instruction[7] )) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=60, LSE_RLINE=65 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam y__i1.GSR = "DISABLED";
    LUT4 PrioSelect_552_i7_3_lut_4_lut (.A(\instruction[11] ), .B(n2180), 
         .C(s_15_4), .D(n2), .Z(n7)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam PrioSelect_552_i7_3_lut_4_lut.init = 16'hf780;
    FD1P3AX y__i3 (.D(n1), .SP(clk_enable_41), .CK(clk), .Q(\instruction[12] )) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=60, LSE_RLINE=65 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam y__i3.GSR = "DISABLED";
    FD1P3AX y__i5 (.D(n421[14]), .SP(clk_enable_41), .CK(clk), .Q(\instruction[14] )) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=60, LSE_RLINE=65 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam y__i5.GSR = "DISABLED";
    FD1P3AX y__i8 (.D(address[1]), .SP(clk_enable_41), .CK(clk), .Q(\instruction[17] )) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=60, LSE_RLINE=65 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam y__i8.GSR = "DISABLED";
    LUT4 i194_2_lut (.A(address[0]), .B(address[1]), .Z(n421[14])) /* synthesis lut_function=(!(A (B)+!A !(B))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(13[7] 18[15])
    defparam i194_2_lut.init = 16'h6666;
    FD1P3IX y__i4 (.D(address[0]), .SP(clk_enable_41), .CD(n1192), .CK(clk), 
            .Q(\instruction[13] )) /* synthesis LSE_LINE_FILE_ID=4, LSE_LCOL=5, LSE_RCOL=2, LSE_LLINE=60, LSE_RLINE=65 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam y__i4.GSR = "DISABLED";
    LUT4 PrioSelect_556_i7_3_lut_4_lut (.A(\instruction[11] ), .B(n2180), 
         .C(s_15_5), .D(n2_adj_1), .Z(n7_adj_2)) /* synthesis lut_function=(A (B (C)+!B (D))+!A (D)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam PrioSelect_556_i7_3_lut_4_lut.init = 16'hf780;
    
endmodule
//
// Verilog Description of module \divide(N=1000000) 
//

module \divide(N=1000000)  (clk, clk_in_c, n2128, GND_net, n32, n2006, 
            \cnt_p[19] , n114) /* synthesis syn_module_defined=1 */ ;
    output clk;
    input clk_in_c;
    input n2128;
    input GND_net;
    output n32;
    output n2006;
    output \cnt_p[19] ;
    input n114;
    
    wire clk /* synthesis is_clock=1, SET_AS_NETWORK=clk */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(15[6:9])
    wire clk_in_c /* synthesis SET_AS_NETWORK=clk_in_c, is_clock=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/top.v(3[8:14])
    
    wire clkout_N_52, n1820;
    wire [19:0]cnt_p;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(27[22:27])
    wire [19:0]n85;
    
    wire n1821, n1819, n2000, n4, n2016, n4_adj_204, n1467, n10, 
        n1818, n1817, n4_adj_205, n1826, n1825, n1824, n1823, 
        n1822;
    
    FD1S3IX clk_p_29 (.D(clkout_N_52), .CK(clk_in_c), .CD(n2128), .Q(clk));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(42[12] 50[6])
    defparam clk_p_29.GSR = "DISABLED";
    CCU2D cnt_p_110_add_4_9 (.A0(cnt_p[7]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(cnt_p[8]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n1820), .COUT(n1821), .S0(n85[7]), .S1(n85[8]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110_add_4_9.INIT0 = 16'hfaaa;
    defparam cnt_p_110_add_4_9.INIT1 = 16'hfaaa;
    defparam cnt_p_110_add_4_9.INJECT1_0 = "NO";
    defparam cnt_p_110_add_4_9.INJECT1_1 = "NO";
    CCU2D cnt_p_110_add_4_7 (.A0(cnt_p[5]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(cnt_p[6]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n1819), .COUT(n1820), .S0(n85[5]), .S1(n85[6]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110_add_4_7.INIT0 = 16'hfaaa;
    defparam cnt_p_110_add_4_7.INIT1 = 16'hfaaa;
    defparam cnt_p_110_add_4_7.INJECT1_0 = "NO";
    defparam cnt_p_110_add_4_7.INJECT1_1 = "NO";
    LUT4 i143_4_lut (.A(n2000), .B(cnt_p[15]), .C(cnt_p[14]), .D(n4), 
         .Z(n32)) /* synthesis lut_function=(A (B+(C))+!A (B+(C (D)))) */ ;
    defparam i143_4_lut.init = 16'hfcec;
    LUT4 i1_4_lut (.A(n2016), .B(cnt_p[13]), .C(cnt_p[9]), .D(n4_adj_204), 
         .Z(n4)) /* synthesis lut_function=(A (B+(C))+!A (B+(C (D)))) */ ;
    defparam i1_4_lut.init = 16'hfcec;
    LUT4 i1099_4_lut (.A(n2006), .B(\cnt_p[19] ), .C(n1467), .D(cnt_p[15]), 
         .Z(clkout_N_52)) /* synthesis lut_function=(A (B+(C (D)))+!A (B)) */ ;
    defparam i1099_4_lut.init = 16'heccc;
    LUT4 i1_4_lut_adj_13 (.A(cnt_p[5]), .B(cnt_p[8]), .C(n10), .D(cnt_p[3]), 
         .Z(n4_adj_204)) /* synthesis lut_function=(A (B+(C (D)))+!A (B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(46[13:25])
    defparam i1_4_lut_adj_13.init = 16'heccc;
    LUT4 i4_4_lut (.A(cnt_p[2]), .B(cnt_p[1]), .C(cnt_p[0]), .D(cnt_p[4]), 
         .Z(n10)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i4_4_lut.init = 16'h8000;
    CCU2D cnt_p_110_add_4_5 (.A0(cnt_p[3]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(cnt_p[4]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n1818), .COUT(n1819), .S0(n85[3]), .S1(n85[4]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110_add_4_5.INIT0 = 16'hfaaa;
    defparam cnt_p_110_add_4_5.INIT1 = 16'hfaaa;
    defparam cnt_p_110_add_4_5.INJECT1_0 = "NO";
    defparam cnt_p_110_add_4_5.INJECT1_1 = "NO";
    FD1S3IX cnt_p_110__i0 (.D(n85[0]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[0])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i0.GSR = "DISABLED";
    CCU2D cnt_p_110_add_4_3 (.A0(cnt_p[1]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(cnt_p[2]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n1817), .COUT(n1818), .S0(n85[1]), .S1(n85[2]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110_add_4_3.INIT0 = 16'hfaaa;
    defparam cnt_p_110_add_4_3.INIT1 = 16'hfaaa;
    defparam cnt_p_110_add_4_3.INJECT1_0 = "NO";
    defparam cnt_p_110_add_4_3.INJECT1_1 = "NO";
    LUT4 i2_3_lut (.A(cnt_p[11]), .B(cnt_p[10]), .C(cnt_p[12]), .Z(n2000)) /* synthesis lut_function=(A+(B+(C))) */ ;
    defparam i2_3_lut.init = 16'hfefe;
    LUT4 i2_3_lut_adj_14 (.A(cnt_p[17]), .B(cnt_p[16]), .C(cnt_p[18]), 
         .Z(n2006)) /* synthesis lut_function=(A (B (C))) */ ;
    defparam i2_3_lut_adj_14.init = 16'h8080;
    LUT4 i1_2_lut (.A(cnt_p[6]), .B(cnt_p[7]), .Z(n2016)) /* synthesis lut_function=(A+(B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(46[13:25])
    defparam i1_2_lut.init = 16'heeee;
    CCU2D cnt_p_110_add_4_1 (.A0(GND_net), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(cnt_p[0]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .COUT(n1817), .S1(n85[0]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110_add_4_1.INIT0 = 16'hF000;
    defparam cnt_p_110_add_4_1.INIT1 = 16'h0555;
    defparam cnt_p_110_add_4_1.INJECT1_0 = "NO";
    defparam cnt_p_110_add_4_1.INJECT1_1 = "NO";
    FD1S3IX cnt_p_110__i1 (.D(n85[1]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[1])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i1.GSR = "DISABLED";
    LUT4 i1095_4_lut (.A(n2000), .B(cnt_p[14]), .C(cnt_p[13]), .D(n4_adj_205), 
         .Z(n1467)) /* synthesis lut_function=(A (B+(C))+!A (B+(C (D)))) */ ;
    defparam i1095_4_lut.init = 16'hfcec;
    CCU2D cnt_p_110_add_4_21 (.A0(\cnt_p[19] ), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(GND_net), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n1826), .S0(n85[19]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110_add_4_21.INIT0 = 16'hfaaa;
    defparam cnt_p_110_add_4_21.INIT1 = 16'h0000;
    defparam cnt_p_110_add_4_21.INJECT1_0 = "NO";
    defparam cnt_p_110_add_4_21.INJECT1_1 = "NO";
    CCU2D cnt_p_110_add_4_19 (.A0(cnt_p[17]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(cnt_p[18]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n1825), .COUT(n1826), .S0(n85[17]), .S1(n85[18]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110_add_4_19.INIT0 = 16'hfaaa;
    defparam cnt_p_110_add_4_19.INIT1 = 16'hfaaa;
    defparam cnt_p_110_add_4_19.INJECT1_0 = "NO";
    defparam cnt_p_110_add_4_19.INJECT1_1 = "NO";
    CCU2D cnt_p_110_add_4_17 (.A0(cnt_p[15]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(cnt_p[16]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n1824), .COUT(n1825), .S0(n85[15]), .S1(n85[16]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110_add_4_17.INIT0 = 16'hfaaa;
    defparam cnt_p_110_add_4_17.INIT1 = 16'hfaaa;
    defparam cnt_p_110_add_4_17.INJECT1_0 = "NO";
    defparam cnt_p_110_add_4_17.INJECT1_1 = "NO";
    CCU2D cnt_p_110_add_4_15 (.A0(cnt_p[13]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(cnt_p[14]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n1823), .COUT(n1824), .S0(n85[13]), .S1(n85[14]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110_add_4_15.INIT0 = 16'hfaaa;
    defparam cnt_p_110_add_4_15.INIT1 = 16'hfaaa;
    defparam cnt_p_110_add_4_15.INJECT1_0 = "NO";
    defparam cnt_p_110_add_4_15.INJECT1_1 = "NO";
    CCU2D cnt_p_110_add_4_13 (.A0(cnt_p[11]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(cnt_p[12]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n1822), .COUT(n1823), .S0(n85[11]), .S1(n85[12]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110_add_4_13.INIT0 = 16'hfaaa;
    defparam cnt_p_110_add_4_13.INIT1 = 16'hfaaa;
    defparam cnt_p_110_add_4_13.INJECT1_0 = "NO";
    defparam cnt_p_110_add_4_13.INJECT1_1 = "NO";
    LUT4 i1_4_lut_adj_15 (.A(cnt_p[5]), .B(cnt_p[9]), .C(cnt_p[8]), .D(n2016), 
         .Z(n4_adj_205)) /* synthesis lut_function=(A (B+(C))+!A (B+(C (D)))) */ ;
    defparam i1_4_lut_adj_15.init = 16'hfcec;
    FD1S3IX cnt_p_110__i2 (.D(n85[2]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[2])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i2.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i3 (.D(n85[3]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[3])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i3.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i4 (.D(n85[4]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[4])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i4.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i5 (.D(n85[5]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[5])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i5.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i6 (.D(n85[6]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[6])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i6.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i7 (.D(n85[7]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[7])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i7.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i8 (.D(n85[8]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[8])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i8.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i9 (.D(n85[9]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[9])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i9.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i10 (.D(n85[10]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[10])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i10.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i11 (.D(n85[11]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[11])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i11.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i12 (.D(n85[12]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[12])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i12.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i13 (.D(n85[13]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[13])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i13.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i14 (.D(n85[14]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[14])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i14.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i15 (.D(n85[15]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[15])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i15.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i16 (.D(n85[16]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[16])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i16.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i17 (.D(n85[17]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[17])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i17.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i18 (.D(n85[18]), .CK(clk_in_c), .CD(n114), .Q(cnt_p[18])) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i18.GSR = "DISABLED";
    FD1S3IX cnt_p_110__i19 (.D(n85[19]), .CK(clk_in_c), .CD(n114), .Q(\cnt_p[19] )) /* synthesis syn_use_carry_chain=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110__i19.GSR = "DISABLED";
    CCU2D cnt_p_110_add_4_11 (.A0(cnt_p[9]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(cnt_p[10]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n1821), .COUT(n1822), .S0(n85[9]), .S1(n85[10]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/divide.v(38[16:23])
    defparam cnt_p_110_add_4_11.INIT0 = 16'hfaaa;
    defparam cnt_p_110_add_4_11.INIT1 = 16'hfaaa;
    defparam cnt_p_110_add_4_11.INJECT1_0 = "NO";
    defparam cnt_p_110_add_4_11.INJECT1_1 = "NO";
    
endmodule
