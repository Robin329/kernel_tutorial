`timescale 1ns / 1ps

`include "head.v"

`define CENTER_REG_DEPTH  16    //定义中间寄存器的深度 1-256
`define PC_STACK_DEPTH  20       //定义程序堆栈的深度  1 - 31
module mcu (
    input       clk,            //系统时钟
    input       rst_n,          //复位  0 --> 复位
    input       interrupt,      //中断输入信号，上升沿触发，高电平时间至少维持两个时钟
    output [11:0]address,       //程序取址地址
    input  [17:0]instruction,   //指令输入
    output reg   bram_enable,   //程序rom使能 1-->使能  
    output reg   interrupt_ack,  //中断响应信号  
    input [7:0]      in_port,        //输入口
    output reg       read_strobe,    //输入口使能     
    output reg [7:0] port_id,        //io口地址      
    output reg [7:0] out_port,       //输出口
    output reg       write_strobe    //输出口写使能  
);
//---------------------- 定义一级指令编码 --------------------
// --------  SCRIPT_BEGIN         --> 脚本识别标签，勿动
localparam
//LOAD
    LOAD_REG2REG = 6'H00,               //LOAD sX, sY    装载数据 
    LOAD_DAT2REG = 6'H01,               //LOAD sX, kk    装载立即数到寄存器
//JUMP 
    JUMP_AAA     = 6'H22,               //JUMP aaa       跳转到aaa地址执行  
    JUMP_Z       = 6'H32,               //JUMP Z,aaa    
    JUMP_NZ      = 6'H36,               //JUMP NZ,aaa      
    JUMP_C       = 6'H3A,               //JUMP C,aaa    
    JUMP_NC      = 6'H3E,               //JUMP NC,aaa 
    JUMP_AT      = 6'H26,               //JUMP @(sX,sY)   ==>  JUMP {sX[3:0],sY}
//INPUT
    INPUT_REG    = 6'H08,               //INPUT sX, (sY)  
    INPUT_PP     = 6'H09,               //INPUT sX, pp
//OUTPUT
    OUTPUT_REG   = 6'H2C,               //OUTPUT sX,(sY)
    OUTPUT_PP    = 6'H2D,               //OUTPUT sX,pp
//SHIFT 
    SHIFT        = 6'H14,                //移位操作
// ADD
    ADD_REG      = 6'H10,               // ADD sX,sY
    ADD_KK       = 6'H11,               // ADD sX,kk
    ADD_CY_REG   = 6'H12,               // ADDCY sX,sX
    ADD_CY_KK    = 6'H13,               // ADDCY sX,kk
// SUB
    SUB_REG      = 6'H18,               // SUB sX,sY
    SUB_KK       = 6'H19,               // SUB sX,kk
    SUB_CY_REG   = 6'H1A,               // SUBCY sX,sY
    SUB_CY_KK    = 6'H1B,               // SUBCY sX,kk
// RETURN
    RETURN       = 6'H25,               // RETURN 无条件返回
    RETURN_Z     = 6'H31,               // RETURN Z    Z==0 则返回
    RETURN_NZ    = 6'H35,               // RETURN NZ   Z==1 则返回
    RETURN_C     = 6'H39,               // RETURN C    C==0 则返回
    RETURN_NC    = 6'H3D,               // RETURN NC   C==1 则返回
//CALL
    CALL         = 6'H20,                // CALL aaa
    CALL_Z       = 6'H30,                // CALL Z, aaa
    CALL_NZ      = 6'H34,                // CALL NZ, aaa
    CALL_C       = 6'H38,                // CALL C, aaa
    CALL_NC      = 6'H3C,                // CALL NC, aaa
    CALL_AT      = 6'H24,                //  CALL @(sX,sY)
// COMPARE
    COMPARE_REG  =  6'H1C,                // COMPARE sX,sY   if(sX < kk or sX < sY) Z=X,C=1  ;  if(sX > kk or sX > sY) Z=X,C=0  ; if(sX == kk or sX == sY) Z=1,C=x ;
    COMPARE_KK   =  6'H1D,                // COMPARE sX,kk   if(sX < kk or sX < sY) Z=X,C=1  ;  if(sX > kk or sX > sY) Z=X,C=0  ; if(sX == kk or sX == sY) Z=1,C=x ;
    COMPARECY_REG=  6'H1E,               // COMPARECY sX,sY
    COMPARECY_KK =  6'H1F,               // COMPARECY sX,kk
// TSET
    TEST_REG     = 6'H0C,                // TEST sX,sY
    TEST_KK      = 6'H0D,                // TEST sX,kk
    TESTCY_REG   = 6'H0E,                // TESTCY sX,sY
    TESTCY_KK    = 6'H0F,                // TESTCY sX,kk
// LOGIC
    AND_REG      = 6'H02,                // AND sX,sY
    AND_KK       = 6'H03,                // AND sX,kk
    OR_REG       = 6'H04,                // OR sX,sY
    OR_KK        = 6'H05,                // OR sX,kk  
    XOR_REG      = 6'H06,                // XOR sX,sY
    XOR_KK       = 6'H07,                // XOR sX,kk     
// MEMORY
    STORE_REG    = 6'H2E,                // STORY sX,(sY)   存 0-256 个8bit中间寄存器 
    STORE_SS     = 6'H2F,                // STORY sX,ss
    FETCH_REG    = 6'H0A,                // FETCH sX,(sY)   取数据
    FETCH_SS     = 6'H0B,                // FETCH sX,ss  
// INTERRUPT 
    EN_INTR      = 6'H28,                // DISEABL INTERRUPT ==> 0  ENABLE INTERRUPT ==> 1
    RETURNI      = 6'H29,                // RETURNI DISABLE ==> 0     RETURNI ENABLE ==>1
// LOAD&RETURN
    LOAD_RETURN  = 6'H21;                //LOAD&RETURN



// --------  SCRIPT_END         --> 脚本识别标签，勿动
//---------------------- 程序指针 ------------------------
reg [17:0] pc;

//---------------------- 定义寄存器 ----------------------
(* ram_style="distributed" *) reg [7:0] s[0:15]/* synthesis syn_ramstyle="block_ram" */;    //16个8位通用寄存器

//---------------------- 进位标志和结果标志 ----------------
reg C,Z;  //CARRY   ZERO

//------------------------ 定义堆栈 ----------------------
(* ram_style="distributed" *)reg [11:0] stack [ 1 : `PC_STACK_DEPTH ]/* synthesis syn_ramstyle = "block_ram" */ ; 
reg [4:0] st; //栈顶指针
//使用到了中断则定义中断标志栈
`ifdef _EN_INTR_
    `define _INTR_ 
`else
    `ifdef _RETURNI_
        `define _INTR_ 
    `endif
`endif

`ifdef _INTR_
(* ram_style="distributed" *)    reg [1:0] stack_zc[ 1 : `PC_STACK_DEPTH ]/* synthesis syn_ramstyle = "block_ram" */ ;  //ZC标志栈
    reg [4:0] st_zc; //栈顶指针
`endif

//--------------------- 定义中间寄存器 --------------------
//此处宏定义用于根据汇编代码裁剪mcu
`ifdef _STORE_REG_
    `define _STORE_
`else
    `ifdef _STORE_SS_
        `define _STORE_
    `else
        `ifdef _FETCH_REG_
            `define _STORE_
        `else 
            `ifdef _FETCH_SS_
                `define _STORE_
            `endif 
        `endif 
    `endif
`endif

`ifdef _STORE_ 
(* ram_style="distributed" *)reg [7:0] creg[0 : `CENTER_REG_DEPTH - 1]/* synthesis syn_ramstyle = "block_ram" */  ;  //可以存储 CENTER_REG_DEPTH - 1 个数据'
`endif     //end creg 

//------------------------ 定义tmp寄存器 -------------------
reg [7:0]temp;

//------------------------ 预处理中断信号 -------------------
reg [2:0] intr_f;
wire intr_p ;  //提取中断触发信号，维持两个上升沿，保证mcu可以检测到中断信号
assign intr_p = ((intr_f[0] & ~intr_f[1]) | (intr_f[1] & ~intr_f[2])) ;//两个clk的上升沿
reg enable_intr_flag;  //是否开启中断的标志信号    1：开启   0：不开启


always @( posedge clk ) begin
    if( !rst_n ) intr_f <= 3'd0;
    else  intr_f <= {intr_f[1:0],interrupt};
end

//指令地址输出
assign address = pc;
//指令解析
reg jp;
wire [3:0]x,y;
wire [7:0]data ,pp,kk ,ss;
wire [5:0]cmd;
wire [11:0]aaa;
assign cmd  = instruction[17:12];
assign x    = instruction[11:8];
assign y    = instruction[7:4];
assign data = instruction[7:0];
assign kk   = instruction[7:0];
assign ss   = instruction[7:0];
assign aaa  = instruction[11:0];
assign pp   = instruction[7:0];



always @(posedge clk ) begin
   if(rst_n == 1'b0 ) begin
       pc <= 18'd0;  //系统复位
       bram_enable <= 1; //
       write_strobe <= 1'b0;
       read_strobe <= 1'b0;
       jp=1;
       st <= 5'd0;  //空栈
`ifdef _INTR_
       st_zc <= 5'd0;
`endif 
       C <=1'B0;
       enable_intr_flag <= 1'b0;
   end 
   else begin
               //pc指针到一下个地址
       if(jp == 1'b1)begin
           write_strobe <= 1'b0;
           read_strobe <= 1'b0 ;
           jp <= jp + 1'b1;
           interrupt_ack <= 1'b0;
       end
       else begin
`ifdef _INTR_
            if( enable_intr_flag & intr_p ) begin  //中断信号来了，干点中断的事情
                stack[st+1] <= pc ;  //保护当前的程序指针
                st <= st + 1'b1;
                stack_zc[ st_zc+1'b1] <= {Z,C};  //标志入栈
                st_zc <= st_zc + 1'b1;
                pc <= `ISR_ADDR;  //程序地址到中断入口地址去
                interrupt_ack <= 1'b1;
                jp <= jp + 1'b1;
                //enable_intr_flag <= 1'b0;
            end
            else begin 
`endif
            case(cmd)  //6位
`ifdef _SHIFT_
               SHIFT: begin   //收到左移指令，开始判别二级指令   注意：二级指令不宜用多层 if else if的结构，这样由于延时可能会出错
                    pc <= pc +1'b1;
                    case(instruction[7:0])
                         8'h06:begin  s[x] <= {s[x][6:0],1'b0} ; C <= s[x][7]; Z <= {s[x][6:0],1'b0}==8'd0 ; end  //SL0 sX ,低位补0
                         8'h07:begin  s[x] <= {s[x][6:0],1'b1} ; C <= s[x][7]; Z<=1'b0 ; end  //SL1 sX ,低位补1
                         8'h04:begin  s[x] <= {s[x][6:0],s[x][0]} ; C <= s[x][7];Z <= {s[x][6:0],s[x][0]}==8'd0;end  //SLX sX ,低位补原来的低位值
                         8'h00:begin  s[x] <= {s[x][6:0],C} ; C <= s[x][7]; Z <= {s[x][6:0],C}==8'd0;end   //SLA sX，带进位标志的移位
                         8'h02:begin  s[x] <= {{s[x][6:0]},{s[x][7]}} ; C <= s[x][7]; Z <= s[x]==8'd0 ;end   //RL sX  循环左移                 
                         8'h0E:begin  s[x] <= {1'b0,s[x][7:1]} ;C <= s[x][0]; Z <= {1'b0,s[x][7:1]}  == 8'd0;  end  // SR0 sX  右移，最高位补0
                         8'h0F:begin  s[x] <= {1'b1,s[x][7:1]} ;C <= s[x][0]; Z <= 1'b0;  end  // SR0 sX  右移，最高位补1
                         8'h0A:begin  s[x] <= {s[x][7],s[x][7:1]} ;C <= s[x][0]; Z <={s[x][7],s[x][7:1]}==8'd0 ;  end  // SRX 最高位补原来的最高位
                         8'h08:begin  s[x] <= {C,s[x][7:1]} ;C <= s[x][0]; Z <= {C,s[x][7:1]}==8'd0 ;  end  // SRA
                         8'h0C:begin  s[x] <= {s[x][0],s[x][7:1]} ;C <= s[x][0]; Z <= s[x]==8'd0 ;  end  // RR
                         default :;
                    endcase
                   end
`endif
`ifdef _LOAD_REG2REG_
               LOAD_REG2REG: begin s[x] <= s[y]; pc <= pc + 1'b1; end // LOAD sX, sY
`endif  
`ifdef _LOAD_DAT2REG_
               LOAD_DAT2REG: begin s[x] <= data; pc <= pc + 1'b1;end  // LOAD sX, data
`endif  
`ifdef _JUMP_AAA_
               JUMP_AAA: pc <= aaa ;                  // JUMP aaa    空拍
`endif
`ifdef _JUMP_Z_
               JUMP_Z:begin  if(Z) pc <= aaa;else pc <= pc + 1'b1; end                      // JUMP Z,aaa    空拍
`endif
`ifdef _JUMP_NZ_
               JUMP_NZ:begin  if(!Z) pc <= aaa;else pc <= pc + 1'b1; end                    // JUMP NZ,aaa    空拍
`endif
`ifdef _JUMP_C_
               JUMP_C:begin  if(C) pc <= aaa;else pc <= pc + 1'b1; end                   // JUMP C,aaa    空拍
`endif
`ifdef _JUMP_NC_
               JUMP_NC:begin  if(!C) pc <= aaa;else pc <= pc + 1'b1; end                    // JUMP NC,aaa    空拍
`endif
`ifdef _JUMP_AT_
               JUMP_AT:begin  pc <= {s[x][3:0],sY} ;end   //JUMP @(sX,sY)
`endif 
               OUTPUT_REG: begin pc <= pc + 1'b1 ;   end//OUTPUT sX, (sY) 
               OUTPUT_PP: begin pc <= pc + 1'b1 ; end //OUTPUT sX, pp
`ifdef _ADD_REG_
                ADD_REG:begin pc <= pc + 1'b1;{C,s[x]} <= s[x] + s[y] ; Z <= (s[x] + s[y])==8'd0; end  //ADD sX,sY
`endif
`ifdef _ADD_KK_                
                ADD_KK: begin pc <= pc + 1'b1;{C,s[x]} <= s[x] + data  ; Z <= (s[x] + data)==8'd0; end  //ADD sX,kk
`endif
`ifdef _ADD_CY_REG_
                ADD_CY_REG:begin pc <= pc + 1'b1; {C,s[x]} <=  s[x] + s[y] + C ; Z <=( s[x] + s[y] + C) == 8'd0;end //ADDCY sX,sY
`endif
`ifdef _ADD_CY_KK_
                ADD_CY_KK:begin pc <= pc + 1'b1; {C,s[x]} <=  s[x] + data + C ; Z <=( s[x] + data + C) == 8'd0;end //ADDCY sX,kk
`endif
`ifdef _SUB_REG_
                SUB_REG:begin  pc <= pc + 1'b1; s[x] <= s[x] - s[y]; C <= (s[x] < s[y]);Z <=(s[x] == s[y]) ;  end //SUB sX,sY
`endif
`ifdef _SUB_KK_
                SUB_KK: begin  pc <= pc + 1'b1; s[x] <= s[x] - kk ; C <= (s[x] < kk);Z <=(s[x] == kk);  end //SUB sX,sY
`endif
`ifdef _SUB_CY_REG_
                SUB_CY_REG:begin   pc <= pc + 1'b1; s[x] <= s[x] - s[y] - C; C <= ( {1'b0,s[x]} < (9'd0 + s[y] + C) );Z <= ((s[x] - s[y])==8'd0) & (Z);  end //SUBCY sX,sY
`endif
`ifdef _SUB_CY_KK_
                SUB_CY_KK: begin   pc <= pc + 1'b1; s[x] <= s[x] -kk - C; C <= ( {1'b0,s[x]} < (9'd0 + kk + C) );Z <= ((s[x] - kk)==8'd0) & (Z);  end//SUBCY sX,kk
`endif
`ifdef _RETURN_
                RETURN:begin pc <= stack[st] ; st<=st - 1'b1; end// RETURN
`endif
`ifdef _RETURN_Z_
                RETURN_Z: begin if(Z) begin pc <= stack[st] ; st<=st - 1'b1; Z <= stack_zc[st_zc][1]; C <= stack_zc[st_zc][0]; st_zc <= st_zc - 1'b1 ;end else begin pc <= pc + 1'b1; end end  //RETURN Z
 `endif
 `ifdef _RETURN_NZ_
                RETURN_NZ: begin if(!Z) begin pc <= stack[st] ; st<=st - 1'b1; end else begin pc <= pc + 1'b1; end end// RETURN NZ
`endif
`ifdef _RETURN_C_
                RETURN_C: begin if(C) begin pc <= stack[st] ; st<=st - 1'b1;end else begin pc <= pc + 1'b1; end end//RETURN C
`endif
`ifdef _RETURN_NC_
                RETURN_NC: begin if(!C) begin pc <= stack[st] ; st<=st - 1'b1;end else begin pc <= pc + 1'b1; end end  //RETURN NC
`endif
`ifdef _CALL_
                CALL:    begin pc <= aaa ; stack[st+1] <= pc + 1'b1;  st <= st + 1'b1; end  //CALL aaa
`endif
`ifdef _CALL_AT_
                CALL_AT: begin pc <= {s[x][3:0],s[y]} ; stack[st+1] <= pc + 1'b1;  st <= st + 1'b1; end
`endif 
`ifdef _CALL_Z_
                CALL_Z: begin if(Z)begin stack[st+1] <= pc + 1'b1;  st <= st + 1'b1;pc <= aaa; end else pc <= pc + 1'b1; end    //CALL Z,aaa
`endif
`ifdef _CALL_NZ_
                CALL_NZ: begin if(!Z)begin stack[st+1] <= pc + 1'b1;  st <= st + 1'b1; pc <= aaa;end else pc <= pc + 1'b1; end // CALL NZ,aaa
`endif
`ifdef _CALL_C_
               CALL_C: begin if(C)begin stack[st+1] <= pc + 1'b1;  st <= st + 1'b1;pc <= aaa; end else pc <= pc + 1'b1; end   //CALL C,aaa
`endif
`ifdef _CALL_NC_
              CALL_NC: begin if(!C)begin stack[st+1] <= pc + 1'b1;  st <= st + 1'b1; pc <= aaa; end else pc <= pc + 1'b1; end  //CALL NC, aaa
`endif            
`ifdef _COMPARE_REG_
                COMPARE_REG: begin   pc <= pc + 1'b1; temp <= s[x] - s[y]; C <= (s[x] < s[y]);Z <=(s[x] == s[y]) ; end //COMPARE sX,sY
`endif
`ifdef _COMPARE_KK_                
                COMPARE_KK: begin   pc <= pc + 1'b1;;temp <= s[x] - kk; C <= (s[x] < kk);Z <=(s[x] == kk) ; end //COMPARE sX,kk
 `endif
 `ifdef _COMPARECY_REG_
                COMPARECY_REG:begin   pc <= pc + 1'b1;;temp <= s[x] - s[y] - C; C <= ( {1'b0,s[x]} < (9'd0 + s[y] + C) );Z <= ((s[x] - s[y])==8'd0) & (Z);  end //COMPARECY sX,sY
 `endif
 `ifdef _COMPARECY_KK_
                COMPARECY_KK: begin  pc <= pc + 1'b1;; temp <= s[x] -kk - C; C <= ( {1'b0,s[x]} < (9'd0 + kk + C) );Z <= ((s[x] - kk)==8'd0) & (Z);  end//COMPARECY sX,kk
 `endif
 `ifdef _AND_REG_
                AND_REG: begin   pc <= pc + 1'b1; s[x]<= s[x] & s[y] ; C<=1'b0; Z <= (s[x] & s[y])==8'd0 ;  end // AND sX,sY
 
 `endif
 `ifdef _AND_KK_
                AND_KK: begin  pc <= pc + 1'b1; s[x]<= s[x] & kk ; C<=1'b0; Z <= (s[x] & kk)==8'd0 ;  end     // AND sX,kk
 `endif
 `ifdef _OR_REG_
                OR_REG: begin   pc <= pc + 1'b1; s[x]<= s[x] | s[y] ; C<=1'b0; Z <= (s[x] | s[y])==8'd0 ;  end // OR sX,sY
 `endif
 `ifdef _OR_KK_
                OR_KK:  begin   pc <= pc + 1'b1; s[x]<= s[x] | kk ; C<=1'b0; Z <= (s[x] | kk)==8'd0 ;  end     //  OR sX,kk
 `endif
 `ifdef _XOR_REG_
                XOR_REG: begin   pc <= pc + 1'b1; s[x]<= s[x] ^ s[y] ; C<=1'b0; Z <= (s[x] ^ s[y])==8'd0 ;  end  //XOR sX,sY
 `endif
 `ifdef _XOR_KK_
                XOR_KK:  begin   pc <= pc + 1'b1; s[x]<= s[x] ^ kk ; C<=1'b0; Z <= (s[x] ^ kk)==8'd0 ;  end     // XOR sX,kk
 `endif
 `ifdef _TEST_REG_
                TEST_REG: begin   pc <= pc + 1'b1; temp<= s[x] & s[y] ; Z <= ((s[x] & s[y])==8'd0)  ; C <=  crc_one(s[x] & s[y]);  end // TEST sX,sY
 `endif
 `ifdef _TEST_KK_
                TEST_KK: begin   pc <= pc + 1'b1; temp<= s[x] & kk ; Z <= ((s[x] & kk)==8'd0)  ; C <=  crc_one(s[x] & kk);  end    // TEST sX,kk
 `endif
 `ifdef _TESTCY_REG_
                TESTCY_REG: begin  pc <= pc + 1'b1; temp<= s[x] & s[y] ; Z <= ((s[x] & s[y])==8'd0) & Z ; C <= C + crc_one(s[x] & s[y]);  end // TESTCY sX,sY
 `endif
 `ifdef _TESTCY_KK_
                TESTCY_KK: begin   pc <= pc + 1'b1; temp<= s[x] & kk ; Z <= ((s[x] & kk)==8'd0) & Z ; C <= C + crc_one(s[x] & kk);  end    // TESTCY sX,kk
`endif
`ifdef _STORE_REG_
                STORE_REG: begin   pc <= pc + 1'b1; creg[y] <= s[x];   end  // STORY sX , (sY)
`endif 
`ifdef _STORE_SS_
                STORE_SS: begin   pc <= pc + 1'b1; creg[ss] <= s[x];   end  // STORY sX , ss
`endif 
`ifdef _FETCH_REG_
                FETCH_REG : begin pc <= pc + 1'b1; s[x] <= creg[y];   end   //FETCH sX,(sY)
`endif 
`ifdef _FETCH_SS_
                FETCH_SS : begin pc <= pc + 1'b1; s[x] <= creg[ss];   end   //FETCH sX,ss
`endif 
`ifdef _EN_INTR_
                EN_INTR : begin pc <= pc + 1'b1; enable_intr_flag <= data[0];  end   // ENABLE INTERRUPT    OR DISABLE INTERRUPT
`endif
`ifdef _RETURNI_
             //   RETURNI : begin  pc <= stack[st]; st <= st - 1'b1; Z <= stack_zc[st_zc][1]; C <= stack_zc[st_zc][0]; st_zc <= st_zc - 1'b1 ; enable_intr_flag <= data[0]; end
             RETURNI : begin  pc <= stack[st] ;st<=st-1'b1; Z <= stack_zc[st_zc][1]; C <= stack_zc[st_zc][0]; st_zc <= st_zc - 1'b1; enable_intr_flag <= data[0]; end
`endif 
`ifdef _LOAD_RETURN_
             LOAD_RETURN: begin if(st == 5'd0 )begin pc <= pc + 1'b1; end else begin pc <= stack[st]; st<=st - 1'b1;  end s[x] <= data;   end // LOAD&RETURN :执行该条命令，如果程序栈非空，下一条指令就去那里，否则顺序执行
`endif

                INPUT_REG:begin  s[x] <= in_port;  pc <= pc + 1'b1 ; end // INPUT sX,(sY)
                INPUT_PP: begin  s[x] <= in_port ; pc <= pc + 1'b1 ; end // INPUT sX, pp

                default: ;
            endcase
           write_strobe <= ( (cmd==OUTPUT_REG) || (cmd==OUTPUT_PP));
           read_strobe <= ( (cmd==INPUT_REG) || (cmd==INPUT_PP)) ;
           jp <= jp + 1'b1;
           interrupt_ack <= 1'b0;
`ifdef _INTR_
       end
`endif
       end
//------------------------------------------------------------------------------------------------------------

   end
end

/*****************************************
* IO
*****************************************/
always@(*)begin
    case(cmd)
        OUTPUT_REG,INPUT_REG: begin
            out_port = s[x];
            port_id = s[y]; 
        end
        OUTPUT_PP: begin
            out_port = s[x];
            port_id = pp; 
        end
        INPUT_REG:begin
            port_id = s[y];
        end
        INPUT_PP:begin
            port_id = pp;
        end
        default: begin
            out_port = out_port;
            port_id = port_id;
        end
    endcase
end
/*****************************************
* 计算8bit奇偶校验 奇数个1则返回1
*****************************************/
function crc_one(input [7:0] in);
    crc_one = in[7] + in[6] + in[5] + in[4] + in[3] + in[2] + in[1] + in[0];
endfunction

endmodule