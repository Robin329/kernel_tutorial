/* top.v 
*测试step-mxo2-c是否可以使用
*by yuanhp 2020/5/31
*/

module top(
    input clk,
    input rst_n,
    output reg led0
);
localparam CYC=32'd4;//设置led周期

reg [31:0] cnt;
always @(posedge clk or negedge rst_n )
begin
    if(!rst_n)begin
        cnt <= 0;
        led0 <= 0;
    end else begin
        if(cnt >= (CYC>>1 - 1))begin
            cnt <= 0;
            led0 <= ~led0;
        end else begin
            cnt <= cnt + 1;
        end
    end
end


endmodule 