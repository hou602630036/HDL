/*********************************************************************************
*FileName:	second biggest
*Author:	zongsheng hou
*Version:	v1
*Date:  	2020.07.08
*Description:  
			不断给一列数字，给出目前为止，第二大的数字，和这个数字的数量。
			【乐鑫公司面试手撕代码题】
*Others:  
*Function List:
1.…………
2.…………
*History:  //修改历史记录列表，每条修改记录应包含修改日期、修改者及修改内容简介

**********************************************************************************/

module second_biggest(
					input clk,rst,
					input  [7:0] num_in,
					output  [7:0] second_num,second_counter
					);

reg [7:0] biggest_num,second_biggest_num;
reg [7:0] biggest_num_counter,second_num_counter;

assign second_num = second_biggest_num;
assign second_counter=second_num_counter;

always @ (posedge clk, posedge rst) begin
	if (rst) begin 
		biggest_num<=0;
		second_biggest_num<=0;
		biggest_num_counter<=0;
		second_num_counter<=0; 
			end
	else begin
	if (num_in > biggest_num) begin 
		biggest_num<=num_in; 
		second_biggest_num<=biggest_num;
		second_num_counter<=biggest_num_counter;
		biggest_num_counter<=1;
		end
	else if (num_in==biggest_num) begin
		biggest_num_counter<=biggest_num_counter+1;
		end
	else if ((num_in > second_biggest_num) && (num_in < biggest_num)) begin
		second_biggest_num<=num_in;
		second_num_counter<=1;
		end
	else if (num_in == second_biggest_num) begin
		second_num_counter<=second_num_counter+1;
		end
	else ;
	end
end

endmodule


module second_biggest_tb;

reg clk,rst;
reg [7:0] num_in;
wire [7:0] second_num,second_counter;

second_biggest U1 (clk,rst,num_in,second_num,second_counter);

initial begin
{clk,rst}=2'b00;
#7 rst=1;
#20 rst=0;
end

always #5 clk=~clk;

initial begin
repeat (100) begin
#10 num_in = $random%256;
end
end

endmodule
