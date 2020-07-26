/*********************************************************************************
*FileName:	adder
*Author:	zongsheng hou
*Version:	v1
*Date:  	2020.07.20
*Description:  
			G(x)=x^10+x^9+x^5+x+1;
			输入32bit，算出10位CRC码
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
module CRC10 (clk,rst,din,crc_en,crc_out);
input clk,rst,crc_en;
input [31:0] din;
output [9:0] crc_out;

reg [9:0] crc_out_reg;
reg crc_out9;
integer i;
assign crc_out=crc_out_reg;

always @ (posedge clk, posedge rst)begin
if (rst) begin crc_out_reg<=0;  end
else if (crc_en) begin
	for (i=0;i<32;i++)begin
	crc_out_reg[0]<=crc_out_reg[9]^din[i];
	crc_out_reg[1]<=crc_out_reg[9]^crc_out_reg[0];
	crc_out_reg[2]<=crc_out_reg[1];
	crc_out_reg[3]<=crc_out_reg[2];
	crc_out_reg[4]<=crc_out_reg[3]^crc_out_reg[9];
	crc_out_reg[5]<=crc_out_reg[4];
	crc_out_reg[6]<=crc_out_reg[5];
	crc_out_reg[7]<=crc_out_reg[6];
	crc_out_reg[8]<=crc_out_reg[7];
	crc_out_reg[9]<=crc_out_reg[8]^crc_out_reg[9];
	end
end

end

endmodule


module CRC10_2 (clk,rst,din,dout);
input clk,rst,din;
output dout;
reg [9:0] crc_out_reg;

assign dout=crc_out_reg;

always @ (posedge clk, posedge rst) begin
if (rst) crc_out_reg<=0;
else begin
	crc_out_reg[0]<=crc_out_reg[9]^din[i];
	crc_out_reg[1]<=crc_out_reg[9]^crc_out_reg[0];
	crc_out_reg[2]<=crc_out_reg[1];
	crc_out_reg[3]<=crc_out_reg[2];
	crc_out_reg[4]<=crc_out_reg[3]^crc_out_reg[9];
	crc_out_reg[5]<=crc_out_reg[4];
	crc_out_reg[6]<=crc_out_reg[5];
	crc_out_reg[7]<=crc_out_reg[6];
	crc_out_reg[8]<=crc_out_reg[7];
	crc_out_reg[9]<=crc_out_reg[8]^crc_out_reg[9];
end
end

endmodule

