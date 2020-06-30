/*********************************************************************************
*FileName:	counter7
*Author:	zongsheng hou
*Version:	v1
*Date:  	2020.06.30
*Description:  
			用你熟悉的设计方式设计一个可预置初值的7进制循环计数器,15进制的呢？
*Others:  
*Function List:
1.…………
2.…………
*History:  //修改历史记录列表，每条修改记录应包含修改日期、修改者及修改内容简介
1.Date:
Author:
Modification:
2.…………
**********************************************************************************/

module counter7 (clk,rst,count) ;
input clk,rst;
output [2:0] count;
reg [2:0] count;

always @ (posedge clk , posedge rst) begin
if(rst) count <= 'b0;
else begin
	if(count=='d6) count <='d0;
	else count <= count + 1;
end
end

endmodule

module counter7_tb ;
reg clk,rst;
wire [2:0] count;

counter7 U1 (clk,rst,count);

initial begin
{clk,rst} = 2'b00;
#7 rst=1;
#27 rst=0;
end

always #5 clk=~clk;

endmodule