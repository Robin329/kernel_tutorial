`timescale 1ns / 1ps
module saler_3always(
    input rst_n,
    input clk,
    input [1:0]in,
    output reg out
);
reg [4:0]state,next_state;
reg out1,out2,out3;
localparam  S0=5'b00001,
            S1=5'b00010,
            S2=5'b00100,
            S3=5'b01000,
            S4=5'b10000;

//状态转移
always@(posedge clk or negedge rst_n)
begin
    if(rst_n == 0)
        state <= S0;
    else
        state <= next_state; 
end

//状态转移组合逻辑判断
always@(state or in)
begin
    next_state = S0;
    case(state)
        S0:begin
            if(in[1])
                next_state = S2;
            else if(in[0])
                next_state = S1;
            else 
                next_state = S0;
        end
        S1:begin
            if(in[1])
                next_state = S3; //1.5
            else if(in[0])
                next_state = S2; //1 
            else 
                next_state = S1;
        end
        S2:begin
            if(in[1])
                next_state = S4; //
            else if(in[0])
                next_state = S3; // 
            else 
                next_state = S2;
        end
        S3:begin
            if(in[1] | in[0])
                next_state = S4; //
            else 
                next_state = S3;
        end
        S4:begin
                next_state = S0; //
        end
        default:next_state = S0;
    endcase
end

//输出
always@(state)
begin
    if(!rst_n)
        out <= 0;
    else begin
        case(state)
            S0:out <= 0;
            S1:out <= 0;
            S2:out <= 0;
            S3:out <= 0;
            S4:out <= 1;
            default:out <= 0;
        endcase
    end 
end
// 组合逻辑输出
always@(state)
begin
    if(!rst_n)
        out1 <= 0;
    else begin
        case(state)
            S0:out1 = 0;
            S1:out1 = 0;
            S2:out1 = 0;
            S3:out1 = 0;
            S4:out1 = 1;
            default:out1 <= 0;
        endcase
    end 
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)out2<=0;
    else begin
         case(next_state)
            S0:out2 = 0;
            S1:out2 = 0;
            S2:out2 = 0;
            S3:out2 = 0;
            S4:out2 = 1;
            default:out2 = 0;
        endcase       
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)out3<=0;
    else begin
         case(next_state)
            S0:out3 <= 0;
            S1:out3 <= 0;
            S2:out3 <= 0;
            S3:out3 <= 0;
            S4:out3 <= 1;
            default:out3 <= 0;
        endcase       
    end
end
reg flag ,flag1,flag2;
always@(posedge clk)
begin
    flag <= out3;
end


reg d1,d2;
always@(posedge clk)
begin
    flag1 = flag;
    d1=flag1;
end

always@(posedge clk)
begin
    flag2 <= flag;
    d2<=flag2;
end


endmodule
