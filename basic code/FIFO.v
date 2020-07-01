/*********************************************************************************
*FileName:	FIFO
*Author:	zongsheng hou
*Version:	v1
*Date:  	2020.07.01
*Description:  
			【同步FIFO】FIFO_syn1 计数器决定空满的标志方式，但是耗费硬件资源（计数器）
								参考：https://blog.csdn.net/iamsarah/article/details/76022015（写的不规范）
						FIFO_syn2 使用指针比较的方式，决定空满状态。
								特点：对于指针多加一位，判断循环状态位。{ptr[4],ptr[3:0]}
								当读写指针ptr[3:0]相等时，FIFO处于空状态或满状态
								当读写指针ptr[4]相等时，读指针追上了写指针，FIFO空。
								当读写指针ptr[4]不相等时，写指针（转了一圈）追上了读指针，FIFO满。
								具体情况：
								{wr_ptr[4],rd_ptr[4]}=
								2'b00: 读指针追上了写指针，FIFO空。
								2'b10: 写指针转了一圈，追上了读指针，FIFO满。
								2'b11: 读指针也转了一圈，追上了写指针，FIFO空。
								2‘b01: 写指针又转了一圈，追上了读指针，FIFO满。
								原理参考：https://blog.csdn.net/Lily_9/article/details/89326204
								
			【异步FIFO】FIFO_asy
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

module FIFO_syn1 (clk,rst,din,dout,wr_en,rd_en,empty,full);
input clk,rst,wr_en,rd_en;
input [7:0]din;
output [7:0]dout;
output empty,full;

reg [7:0]dout;
reg [4:0] counter;
reg [3:0] wr_ptr,rd_ptr;//写和读指针
reg [7:0]mem[15:0];

always @ (posedge clk, posedge rst)begin
if (rst) begin dout<='b0; wr_ptr<='d0; rd_ptr<='d0; counter<='d0; end
else  begin
	case ({wr_en,rd_en})
	2'b00: counter <= counter;
	2'b01: begin 
		dout <= mem[rd_ptr]; 
		counter<=counter-1; 
		rd_ptr <= (rd_ptr==15)? 0 : rd_ptr+1; 
			end
	2'b10: begin 
		mem[wr_ptr]<=din;
		counter <= counter +1;
		wr_ptr <= (wr_ptr==15)? 0 : wr_ptr+1;
			end
	2'b11:begin
		dout <= mem[rd_ptr]; 
		mem[wr_ptr]<=din;
		rd_ptr <= (rd_ptr==15)? 0 : rd_ptr+1; 
		wr_ptr <= (wr_ptr==15)? 0 : wr_ptr+1;
			end
	default: ;
	endcase
end
end

assign full = (counter==16) ? 1 : 0;
assign empty = (counter==0) ? 1 : 0;

endmodule


module FIFO_syn2 (clk,rst,din,dout,wr_en,rd_en,empty,full);
input clk,rst,wr_en,rd_en;
input [7:0] din;
output [7:0] dout;
output empty,full;
reg [7:0] dout;

reg [4:0] wr_ptr,rd_ptr;
reg [7:0] mem [15:0];

always @ (posedge clk, posedge rst) begin
if (rst) begin wr_ptr <= 'b0; rd_ptr <= 'b0; dout<= 'b0; end
else begin
	case ({wr_en,rd_en})
	2'b00: ;
	2'b01: begin
			dout <= mem [rd_ptr[3:0]];
			rd_ptr <= (rd_ptr=='d31) ? 'd0 : rd_ptr+1;
			end
	2'b10: begin
			mem [wr_ptr[3:0]] <= din;
			wr_ptr <= (wr_ptr=='d31) ? 'd0 : wr_ptr+1;
			end
	2'b11: begin
			dout <= mem [rd_ptr[3:0]];
			mem [wr_ptr[3:0]] <= din;
			rd_ptr <= (rd_ptr=='d31) ? 'd0 : rd_ptr+1;
			wr_ptr <= (wr_ptr=='d31) ? 'd0 : wr_ptr+1;
			end
	default : ;
	endcase
end
end

assign empty = (rd_ptr==wr_ptr) ? 1:0;
assign full = ((rd_ptr[3:0]==wr_ptr[3:0]) && (rd_ptr[4]!=wr_ptr[4])) ? 1:0;

endmodule


module FIFO_tb;
wire empty1,full1;
wire empty2,full2;
wire [7:0]dout1,dout2;

reg clk,rst;
reg wr_en,rd_en;
reg [7:0] din;

always #5 clk=~clk;

initial
begin
clk=0;
din=0;
#7 rst=1;
#27 rst=0;
wr_en=1;rd_en=0;
#60
wr_en=0;rd_en=1;
#60 
wr_en=1;rd_en=0;
#320 
wr_en=0;rd_en=1;
#320 
wr_en=1;rd_en=0;
#60 $stop;

end

always@(posedge clk)
begin
din=din+1;
end

FIFO_syn1 U1 (clk,rst,din,dout1,wr_en,rd_en,empty1,full1);
FIFO_syn2 U2 (clk,rst,din,dout2,wr_en,rd_en,empty2,full2);

endmodule

