/*********************************************************************************
*FileName:	FIFO
*Author:	zongsheng hou
*Version:	v2
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
								
			【异步FIFO】FIFO_asy https://blog.csdn.net/alangaixiaoxiao/article/details/81432144
								重点：clk_r和clk_w分别读和写操作，ptr正常增加和归零，这与同步相同。
								每个rd_ptr和wr_ptr分别转换成格雷码，然后打拍的方式分别传递到对方的时钟下，
								empty和full即可使用assign判断。
								判断读空时：需要读时钟域的格雷码rgray_next和被同步到读时钟域的写指针rd2_wp每一位完全相同;
								判断写满时：需要写时钟域的格雷码wgray_next和被同步到写时钟域的读指针wr2_rp高两位不相同，其余各位完全相同；
*Others:  
*Function List:
1.…………
2.…………
*History:  //修改历史记录列表，每条修改记录应包含修改日期、修改者及修改内容简介
	v2:加入了异步FIFO的tb，并进行了验证
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


module FIFO_syn_tb;
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


module FIFO_asy (clk_w,clk_r,rst,din,dout,wr_en,rd_en,empty,full);
input clk_r,clk_w,rst,wr_en,rd_en;
input [7:0] din;
output [7:0] dout;
reg  [7:0] dout;
output empty,full;
reg [3:0] wr_ptr,rd_ptr;
reg [7:0] mem [15:0];
wire [3:0] grey_wr_ptr,grey_rd_ptr;

reg [3:0] grey_wr_ptr_d1,grey_wr_ptr_d2;
reg [3:0] grey_rd_ptr_d1,grey_rd_ptr_d2;

always @ (posedge clk_w , posedge rst) begin
if (rst) begin
		wr_ptr<='b0; 
		end
else begin
		if (wr_en) begin
			mem [wr_ptr] <= din;
			wr_ptr <= (wr_ptr==15) ? 0 : wr_ptr+1;
			end
		else wr_ptr <= wr_ptr;
end
end

always @ (posedge clk_r , posedge rst) begin
if (rst) begin
		rd_ptr<='b0; 
		end
else begin
		if (rd_en) begin
			dout <= mem [wr_ptr];
			rd_ptr <= (rd_ptr==15) ? 0 : rd_ptr+1;
			end
		else rd_ptr <= rd_ptr;
end
end

always @ (posedge clk_r) begin
	grey_wr_ptr_d1 <= grey_wr_ptr;
	grey_wr_ptr_d2 <= grey_wr_ptr_d1;
end

always @ (posedge clk_w) begin
	grey_rd_ptr_d1 <= grey_rd_ptr;
	grey_rd_ptr_d2 <= grey_rd_ptr_d1;
end

assign grey_wr_ptr = (wr_ptr>>1)^wr_ptr;
assign grey_rd_ptr = (rd_ptr>>1)^rd_ptr;

assign full = (grey_wr_ptr=={~grey_rd_ptr_d2[3:2],grey_rd_ptr_d2[1:0]});
assign empty = (grey_rd_ptr==grey_wr_ptr_d2);

endmodule

module FIFO_asy_tb;
reg clk_r,clk_w,rst,wr_en,rd_en;
reg [7:0] din;
wire [7:0] dout;
wire empty,full;

FIFO_asy U1 (clk_w,clk_r,rst,din,dout,wr_en,rd_en,empty,full);

initial begin
{clk_r,clk_w,rst,wr_en,rd_en}=5'b0;
din = 8'd5;
#7 rst=1;
#20 rst=0;
end

always #5 clk_r=~clk_r;
always #10 clk_w=~clk_w;

initial fork
begin
#33 wr_en=1;
#100 wr_en=0;
end
begin
#53 rd_en=1;
#10 rd_en=0;
#100 rd_en=1;
end
join

endmodule
