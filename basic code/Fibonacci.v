/*********************************************************************************
*FileName:	Fibonacci Number
*Author:	zongsheng hou
*Version:	v1
*Date:  	2020.07.08
*Description:  
			斐波那契数列是一种数列，每一项是通过将前两项相加而得到的。 从0和1开始，顺序为0、1、1、2、3、5、8、13、
			21、34，依此类推。 通常，表达式为xn = xn-1 + xn-2。 假设最大值n = 256，以下代码将生成第n个斐波那契数。 值“n”
			作为输入传递给模块（nth_number）
*Others:  
*Function List:
1.…………
2.…………
*History:  //修改历史记录列表，每条修改记录应包含修改日期、修改者及修改内容简介

**********************************************************************************/
module Fibonacci (
				input clk,rst,
				input integer n,
				output wire [127:0] outp
				);

reg [127:0] num1,num2,counter;

always @ (posedge clk, posedge rst) begin
if (rst) begin  num1<='d0; num2<='d1; counter<='d2; end
else begin
	num2<=num1+num2;
	num1<=num2;
	counter<=counter+1;
end
end

assign outp=(counter==n) ? num2 : 'd0;

endmodule

module Fibonacci_tb;

reg clk,rst;
integer n;
wire [127:0] outp;

Fibonacci U1 ( clk,rst,n,outp);

initial begin
{clk,rst}=2'b00;
n=10;
#7 rst=1;
#20 rst=0;
end

always #5 clk=~clk;

endmodule

