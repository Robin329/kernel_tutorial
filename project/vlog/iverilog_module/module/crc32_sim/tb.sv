
module tb;

  logic [55:0] dpk_key[40];
  bit [31:0] result;
  integer fd;

  initial begin
    dpk_key[0][55:0]  = 56'h311788bb26ded9;
    dpk_key[1][55:0]  = 56'hd20700a9435ebc;
    dpk_key[2][55:0]  = 56'h797f47bfdbb6f8;
    dpk_key[3][55:0]  = 56'hac62bce7918f6d;
    dpk_key[4][55:0]  = 56'h7f5bf67e4da866;
    dpk_key[5][55:0]  = 56'ha6051761c52f83;
    dpk_key[6][55:0]  = 56'h30d9a5d4f383ac;
    dpk_key[7][55:0]  = 56'haec359d636ecf3;
    dpk_key[8][55:0]  = 56'hb99f7e2e4a0682;
    dpk_key[9][55:0]  = 56'h937cbee60633da;
    dpk_key[10][55:0] = 56'h27346d6e561258;
    dpk_key[11][55:0] = 56'h83ffb1d66e67ee;
    dpk_key[12][55:0] = 56'h407be02c4efbf;
    dpk_key[13][55:0] = 56'h4fd70d8aada347;
    dpk_key[14][55:0] = 56'hf43bba2c210204;
    dpk_key[15][55:0] = 56'h7d2a8ba5efd3b8;
    dpk_key[16][55:0] = 56'h1ee401a5a4ce52;
    dpk_key[17][55:0] = 56'hd1f10190a154c0;
    dpk_key[18][55:0] = 56'ha8624ec41384a9;
    dpk_key[19][55:0] = 56'he59f5d746b4741;
    dpk_key[20][55:0] = 56'h54bc1d3e1bf881;
    dpk_key[21][55:0] = 56'hf9e0621d1f41da;
    dpk_key[22][55:0] = 56'h9301b8aba26013;
    dpk_key[23][55:0] = 56'h57608e8a758d83;
    dpk_key[24][55:0] = 56'hb6e51ab2f85231;
    dpk_key[25][55:0] = 56'h9b4eb1a21c91ae;
    dpk_key[26][55:0] = 56'h5f03b25bd3e877;
    dpk_key[27][55:0] = 56'he5465bb4f92c96;
    dpk_key[28][55:0] = 56'h8b713821c7cbc1;
    dpk_key[29][55:0] = 56'hb67b002c5eca5;
    dpk_key[30][55:0] = 56'h4ff506f154cf06;
    dpk_key[31][55:0] = 56'h45d4a5b29c3250;
    dpk_key[32][55:0] = 56'h51e7e95a4fc12d;
    dpk_key[33][55:0] = 56'hd50bf8f9ffab66;
    dpk_key[34][55:0] = 56'hebab5dd63c16b;
    dpk_key[35][55:0] = 56'hb7e1b8a111cc93;
    dpk_key[36][55:0] = 56'hedad307cd992fa;
    dpk_key[37][55:0] = 56'h88eb9090584b9b;
    dpk_key[38][55:0] = 56'hf6878ec5487bd6;
    dpk_key[39][55:0] = 56'h9ae9fed3d94fc5;
  end
  function bit [31:0] crc32(bit enable);
    int ix;
    bit [31:0] crc = 32'hFFFFFFFF;
    bit [31:0] i_crc, bitmapped_crc;
    bit [8312:0] bit_stream; // 1024 byte nominal max packet + maximum of 15 additional bytes from DPP_LONG_PACKET_ERROR
    bit bit0, bit1, bit2, bit4, bit5, bit7, bit8, bit10, bit11, bit12, bit16, bit22, bit23, bit26;
    int number_of_bits = 0;
    int number_of_56bitswords = 0;

    fd = $fopen("result.txt", "w");
    number_of_56bitswords = 40;

    if (number_of_56bitswords == 0) begin
      //$display("crc32", "Called for payload of size 0, returning with empty CRC32.");
      crc32 = 32'h00000000;
      return crc32;
    end

    // Serialize the data
    for (ix = 0; ix < number_of_56bitswords; ix++) begin
      bit_stream = bit_stream << 56;
      bit_stream[55:0] = dpk_key[(number_of_56bitswords-1)-ix];
      //$display("\n CRC calculation done word 32'h%8h", words[(number_of_56bitswords - 1) - ix]);
    end

    number_of_bits = number_of_56bitswords * 56;

    for (ix = 0; ix < number_of_bits; ix++) begin
      bit0  = crc[31] ^ bit_stream[ix];
      //   $display("bit0:%x  bit_stream[%d]:%x", bit0, ix, bit_stream[ix]);
      bit1  = crc[0] ^ bit0;
      bit2  = crc[1] ^ bit0;
      bit4  = crc[3] ^ bit0;
      bit5  = crc[4] ^ bit0;
      bit7  = crc[6] ^ bit0;
      bit8  = crc[7] ^ bit0;
      bit10 = crc[9] ^ bit0;
      bit11 = crc[10] ^ bit0;
      bit12 = crc[11] ^ bit0;
      bit16 = crc[15] ^ bit0;
      bit22 = crc[21] ^ bit0;
      bit23 = crc[22] ^ bit0;
      bit26 = crc[25] ^ bit0;
      $display(
          "bit1:%d bit2:%d bit4:%d bit5:%d bit7:%d bit8:%d bit10:%d bit11:%d bit12:%d bit16:%d bit22:%d bit23:%d bit26:%d\n",
          bit1, bit2, bit4, bit5, bit7, bit8, bit10, bit11, bit12, bit16, bit22, bit23, bit26);
      crc = {
        crc[31:26],
        bit26,
        crc[24:23],
        bit23,
        bit22,
        crc[20:16],
        bit16,
        crc[14:12],
        bit12,
        bit11,
        bit10,
        crc[8],
        bit8,
        bit7,
        crc[5],
        bit5,
        bit4,
        crc[2],
        bit2,
        bit1,
        bit0
      };
      //   $fdisplay(fd, "crc:%x", crc);
      $display("crc:%x", crc);
    end

    // Inverting bits
    i_crc = ~crc;

    // Bit swaping
    for (ix = 0; ix <= 31; ix++) begin
      bitmapped_crc[31-ix] = i_crc[ix];
    end

    crc32 = crc;
    $fclose(fd);
    //$display("crc32", $sformatf("Returned CRC32 = 32'h%8h, calculated from %0d data bytes",
    //                          crc32, number_of_56bitswords*7));
  endfunction : crc32

  // Testbench
  initial begin
    result = crc32(1);
    $display("CRC32: %h", result);
    $display("运行结束！");
    $dumpflush;
    $finish;
    $stop;
  end
endmodule
