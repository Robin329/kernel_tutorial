// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.10.3.144
// Netlist written on Thu Nov 26 04:13:40 2020
//
// Verilog Description of module rom
//

module rom (clk, address, instruction, enable) /* synthesis syn_module_defined=1 */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(3[8:11])
    input clk;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(4[20:23])
    input [11:0]address;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(5[17:24])
    output [17:0]instruction;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    input enable;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(7[17:23])
    
    wire clk_c /* synthesis is_clock=1, SET_AS_NETWORK=clk_c */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(4[20:23])
    
    wire GND_net, VCC_net, address_c_11, address_c_10, address_c_9, 
        address_c_8, address_c_7, address_c_6, address_c_5, address_c_4, 
        address_c_3, address_c_2, address_c_1, address_c_0, instruction_c_17, 
        instruction_c_16, instruction_c_15, instruction_c_14, n241, 
        instruction_c_12, instruction_c, n1, n240, enable_c, n302;
    wire [17:0]instruction_17__N_19;
    
    wire n251, n253, n18, clk_c_enable_8, n308, n314;
    
    VHI i2 (.Z(VCC_net));
    LUT4 i7_4_lut (.A(address_c_4), .B(enable_c), .C(address_c_10), .D(address_c_5), 
         .Z(n18)) /* synthesis lut_function=(!(A+((C+(D))+!B))) */ ;
    defparam i7_4_lut.init = 16'h0004;
    FD1P3AX y__i5 (.D(instruction_17__N_19[14]), .SP(clk_c_enable_8), .CK(clk_c), 
            .Q(instruction_c_14));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam y__i5.GSR = "ENABLED";
    LUT4 i99_2_lut (.A(address_c_3), .B(address_c_7), .Z(n302)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i99_2_lut.init = 16'heeee;
    LUT4 i46_2_lut (.A(clk_c_enable_8), .B(address_c_1), .Z(n251)) /* synthesis lut_function=(A (B)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam i46_2_lut.init = 16'h8888;
    FD1P3AX y__i3 (.D(n314), .SP(clk_c_enable_8), .CK(clk_c), .Q(instruction_c_12));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam y__i3.GSR = "ENABLED";
    LUT4 i42_2_lut (.A(address_c_0), .B(address_c_1), .Z(instruction_17__N_19[14])) /* synthesis lut_function=(!(A (B)+!A !(B))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(13[7] 18[15])
    defparam i42_2_lut.init = 16'h6666;
    FD1P3AX y__i8 (.D(address_c_0), .SP(clk_c_enable_8), .CK(clk_c), .Q(instruction_c_17));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam y__i8.GSR = "ENABLED";
    OB instruction_pad_17 (.I(instruction_c_17), .O(instruction[17]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    LUT4 i48_2_lut_2_lut (.A(address_c_1), .B(clk_c_enable_8), .Z(n253)) /* synthesis lut_function=(!(A+!(B))) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(13[7] 18[15])
    defparam i48_2_lut_2_lut.init = 16'h4444;
    LUT4 i41_1_lut_rep_1 (.A(address_c_1), .Z(n314)) /* synthesis lut_function=(!(A)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(13[7] 18[15])
    defparam i41_1_lut_rep_1.init = 16'h5555;
    TSALL TSALL_INST (.TSALL(GND_net));
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    VLO i108 (.Z(GND_net));
    LUT4 i10_4_lut (.A(n308), .B(address_c_2), .C(n18), .D(n302), .Z(clk_c_enable_8)) /* synthesis lut_function=(!(A+(B+((D)+!C)))) */ ;
    defparam i10_4_lut.init = 16'h0010;
    GSR GSR_INST (.GSR(VCC_net));
    FD1P3IX y__i1 (.D(n1), .SP(clk_c_enable_8), .CD(n251), .CK(clk_c), 
            .Q(n240));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam y__i1.GSR = "ENABLED";
    LUT4 i39_1_lut (.A(address_c_0), .Z(n1)) /* synthesis lut_function=(!(A)) */ ;   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(13[7] 18[15])
    defparam i39_1_lut.init = 16'h5555;
    LUT4 i105_4_lut (.A(address_c_9), .B(address_c_11), .C(address_c_8), 
         .D(address_c_6), .Z(n308)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i105_4_lut.init = 16'hfffe;
    OB instruction_pad_16 (.I(instruction_c_16), .O(instruction[16]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    OB instruction_pad_15 (.I(instruction_c_15), .O(instruction[15]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    OB instruction_pad_14 (.I(instruction_c_14), .O(instruction[14]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    OB instruction_pad_13 (.I(n241), .O(instruction[13]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    OB instruction_pad_12 (.I(instruction_c_12), .O(instruction[12]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    OB instruction_pad_11 (.I(instruction_c), .O(instruction[11]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    OB instruction_pad_10 (.I(instruction_c), .O(instruction[10]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    OB instruction_pad_9 (.I(instruction_c), .O(instruction[9]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    OB instruction_pad_8 (.I(instruction_c), .O(instruction[8]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    OB instruction_pad_7 (.I(n240), .O(instruction[7]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    OB instruction_pad_6 (.I(n240), .O(instruction[6]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    OB instruction_pad_5 (.I(n240), .O(instruction[5]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    OB instruction_pad_4 (.I(n240), .O(instruction[4]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    OB instruction_pad_3 (.I(n240), .O(instruction[3]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    OB instruction_pad_2 (.I(n240), .O(instruction[2]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    OB instruction_pad_1 (.I(instruction_c), .O(instruction[1]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    OB instruction_pad_0 (.I(n241), .O(instruction[0]));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(6[17:28])
    IB clk_pad (.I(clk), .O(clk_c));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(4[20:23])
    IB address_pad_11 (.I(address[11]), .O(address_c_11));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(5[17:24])
    IB address_pad_10 (.I(address[10]), .O(address_c_10));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(5[17:24])
    IB address_pad_9 (.I(address[9]), .O(address_c_9));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(5[17:24])
    IB address_pad_8 (.I(address[8]), .O(address_c_8));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(5[17:24])
    IB address_pad_7 (.I(address[7]), .O(address_c_7));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(5[17:24])
    IB address_pad_6 (.I(address[6]), .O(address_c_6));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(5[17:24])
    IB address_pad_5 (.I(address[5]), .O(address_c_5));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(5[17:24])
    IB address_pad_4 (.I(address[4]), .O(address_c_4));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(5[17:24])
    IB address_pad_3 (.I(address[3]), .O(address_c_3));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(5[17:24])
    IB address_pad_2 (.I(address[2]), .O(address_c_2));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(5[17:24])
    IB address_pad_1 (.I(address[1]), .O(address_c_1));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(5[17:24])
    IB address_pad_0 (.I(address[0]), .O(address_c_0));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(5[17:24])
    IB enable_pad (.I(enable), .O(enable_c));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(7[17:23])
    FD1P3IX y__i7 (.D(n1), .SP(clk_c_enable_8), .CD(n253), .CK(clk_c), 
            .Q(instruction_c_16));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam y__i7.GSR = "ENABLED";
    FD1P3IX y__i6 (.D(address_c_0), .SP(clk_c_enable_8), .CD(n251), .CK(clk_c), 
            .Q(instruction_c_15));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam y__i6.GSR = "ENABLED";
    FD1P3IX y__i4 (.D(address_c_0), .SP(clk_c_enable_8), .CD(n253), .CK(clk_c), 
            .Q(n241));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam y__i4.GSR = "ENABLED";
    FD1P3JX y__i2 (.D(n1), .SP(clk_c_enable_8), .PD(n253), .CK(clk_c), 
            .Q(instruction_c));   // f:/home/mini-mcu/hardware/mcu/step_fpga/rom.v(11[7] 20[4])
    defparam y__i2.GSR = "ENABLED";
    
endmodule
//
// Verilog Description of module TSALL
// module not written out since it is a black-box. 
//

//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

