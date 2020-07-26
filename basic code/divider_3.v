/*********************************************************************************
*FileName:	adder
*Author:	zongsheng hou
*Version:	v1
*Date:  	2020.07.21
*Description:  
			3分频,占空比为50%
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
`timescale 1ns/100ps

module divider3 (clk,rst,outp);
input clk,rst;
output outp;

reg [1:0] cs;
reg clk3,clk3n;

always @ (posedge clk, posedge rst) begin
if (rst) begin  clk3<=0; cs<=2'b00; end
else begin
	case(cs)
	2'b00: begin clk3<=0; cs<=2'b01; end
	2'b01: begin clk3<=1; cs<=2'b10; end
	2'b10: begin clk3<=1; cs<=2'b00; end
	default : begin clk3<=0; cs<=2'b01; end
	endcase
end
end

always @ (negedge clk, posedge rst) begin
if (rst) clk3n<=0;
else clk3n<=clk3;
end

assign outp= clk3n & clk3;

endmodule

module tb;
reg clk,rst;
wire outp;

divider3 U0(clk,rst,outp);

initial begin
{clk,rst}=0;
#7 rst=1;
#10 rst=0;
end

always #5 clk=~clk;

endmodule
