/*********************************************************************************
*FileName:	frequency divider
*Author:	zongsheng hou
*Version:	v1
*Date:  	2020.07.01
*Description:  
			任意切换1-8分频，且无论奇分频还是偶分频，占空比均为50%，写出verilog代码；
			https://mp.weixin.qq.com/s/AbA8Mo3Lmqm3-yiFjKjR4Q
			【偶数分频】
			【奇数分频】如果不要求占空比，比如3分频，计数器可以设置成2高1低；
						如果要求占空比，7=3+4(低)，上升下降沿分别寄存clkn，clkp，两者相或
						注意：如果低电平多，则或；如果高电平多，则与。
			【小数分频】https://mp.weixin.qq.com/s/CCzeUW0OG-QHwxEmbC61eA
						https://mp.weixin.qq.com/s/R4FJaK_6H3LKXQ7zwNV2Yg
						[略]
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

module divider_even (clk,rst,clk_out);
input clk,rst;
output clk_out;
reg clk_out;
reg [5:0] counter;
parameter divider='d8;

always @ (posedge clk, posedge rst) begin
if (rst) begin clk_out <= 'b0; counter <= 'd0; end
else begin
	if (counter >= (divider/2-1)) begin  counter <= 'd0; clk_out=~clk_out; end
	else counter <= counter +1;
	end
end
endmodule


module divider_odd (clk,rst,clk_out);
input clk,rst;
output clk_out;
reg clk_out;
reg [5:0] counter;
parameter divider='d7;

always @ (posedge clk, posedge rst) begin
if (rst) begin clk_out <= 'b0; counter <= 'd0; end
else begin
	if (counter >= (divider-1)) begin  counter <= 'd0; clk_out=~clk_out; end
	else if (counter == (divider-1)/2) begin counter <= counter +1; clk_out=~clk_out; end
	else counter <= counter +1;
	end
end
endmodule

module divider_odd2 (clk,rst,clk_out);
input clk,rst;
output clk_out;
reg clkn,clkp;
reg [5:0] counter;
parameter divider='d7;

always @ (posedge clk, posedge rst) begin
if (rst) begin clkp <= 'b0; counter <= 'd0; end
else begin
	if (counter >= (divider-1)) begin  counter <= 'd0; clkp=~clkp; end
	else if (counter == (divider-1)/2) begin counter <= counter +1; clkp=~clkp; end
	else counter <= counter +1;
	end
end

always @ (negedge clk) begin
clkn<=clkp;
end

assign clk_out = clkn | clkp;

endmodule



module clk;
reg clk,rst;
wire clk_out_even,clk_out_odd,clk_out_odd2;

divider_even U1 (clk,rst,clk_out_even);
divider_odd U2 (clk,rst,clk_out_odd);
divider_odd2 U3 (clk,rst,clk_out_odd2);

initial begin
{clk,rst}=2'b0;
#7 rst=1;
#27 rst=0;
end

always #5 clk=~clk;

endmodule