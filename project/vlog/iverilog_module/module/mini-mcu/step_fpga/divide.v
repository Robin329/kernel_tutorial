// Module Function:��������ʱ�ӷ�Ƶ

/*--------- ʵ���� ---------
divide #(
	.N()
) u1 (
	.clk(),
	.rst_n(),
	.clkout()
); 
---------------------------*/
`timescale 1ns / 1ps
module divide #(
	parameter	N	= 5      //��Ƶϵ��
)(	
	input clk,     //�����ź�
	input rst_n,
	output clkout   //����źţ��������ӵ�LED�۲��Ƶ��ʱ��
);
 
	function integer clog2(input integer in);
		for(clog2 = 0; in; clog2 = clog2+1)
			in = in>>1;
	endfunction
	

	reg 	[clog2(N)-1:0]	cnt_p,cnt_n;     //cnt_pΪ�����ش���ʱ�ļ�������cnt_nΪ�½��ش���ʱ�ļ�����
	reg			clk_p,clk_n;     //clk_pΪ�����ش���ʱ��Ƶʱ�ӣ�clk_nΪ�½��ش���ʱ��Ƶʱ��
 
	//�����ش���ʱ�������Ŀ���
	always @ (posedge clk )         //posedge��negedge��verilog��ʾ�ź������غ��½���
                                                         //��clk���������ٻ���rst_n��͵�ʱ��ִ��һ��always������
		begin
			if(!rst_n)
				cnt_p<=0;
			else if (cnt_p>=(N-1))
				cnt_p<=0;
			else cnt_p<=cnt_p+1;             //������һֱ��������������N-1��ʱ�����㣬����һ��ģN�ļ�����
		end
 
         //�����ش����ķ�Ƶʱ�����,���NΪ�����õ���ʱ��ռ�ձȲ���50%�����NΪż���õ���ʱ��ռ�ձ�Ϊ50%
    always @ (posedge clk )
		begin
			if(!rst_n)
				clk_p<=0;
			else if (cnt_p<(N>>1))          //N>>1��ʾ����һλ���൱�ڳ���2ȥ������
				clk_p<=0;
			else 
				clk_p<=1;               //�õ��ķ�Ƶʱ�������ڱȸ����ڶ�һ��clkʱ��
		end
 
        //�½��ش���ʱ�������Ŀ���        	
	always @ (negedge clk )
		begin
			if(!rst_n)
				cnt_n<=0;
			else if (cnt_n>=(N-1))
				cnt_n<=0;
			else cnt_n<=cnt_n+1;
		end
 
        //�½��ش����ķ�Ƶʱ���������clk_p�����ʱ��
	always @ (negedge clk)
		begin
			if(!rst_n)
				clk_n<=0;
			else if (cnt_n<(N>>1))  
				clk_n<=0;
			else 
				clk_n<=1;                //�õ��ķ�Ƶʱ�������ڱȸ����ڶ�һ��clkʱ��
		end
 
        assign clkout = (N==1)?clk:(N[0])?(clk_p&clk_n):clk_p;      //�����жϱ��ʽ
                                                                    //��N=1ʱ��ֱ�����clk
                                                                    //��NΪż��Ҳ����N�����λΪ0��N��0��=0�����clk_p
                                                                    //��NΪ����Ҳ����N���λΪ1��N��0��=1�����clk_p&clk_n�������ڶ�����������
endmodule     