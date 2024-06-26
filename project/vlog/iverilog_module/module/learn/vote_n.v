//n人表决器
module voter_n#(
    parameter N = 7
)(
    output reg pass,  //结果
    input [N-1:0] vote //投票情况
);
    //位宽计算函数
    function integer clogb2 (input integer depth);
    begin
        for (clogb2=0; depth>0; clogb2=clogb2+1) 
            depth = depth >>1;                          
    end
    endfunction

    reg[clogb2(N) - 1:0] sum;
    integer i;
    always @(vote)
    begin
        sum=0;
        for(i=0;i<N;i=i+1)//for语句if(vote[i]) 
            if(vote[i])sum=sum+1;
        if(sum > (N>>1) + N[0]) pass=1;  //若超过半赞成，则pass=1
        else pass = 0;
    end 
endmodule
