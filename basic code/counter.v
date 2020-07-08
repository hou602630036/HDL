/*********************************************************************************
*FileName:	counter
*Author:	zongsheng hou
*Version:	v1
*Date:  	2020.07.08
*Description:  
			请用Verilog RTL描述如下图设计：以clk为基准，设计一个秒计数器，在指定的计数值产生中断，
			实时输出当前的秒数计数值。（紫光展锐数字IC岗）
			<1>clk是时钟输入，频率为32.768KHz。
			<2>rst_n是异步复位输入，低电平有效，复位整个系统，为高则整个系统开始工作，其上升沿已经
			同步于clk。
			<3>start是启动信号，一个clk时钟周期的正脉冲，同步于clk。alarm[7:0]是配置信息，单位为秒，
			同步于clk。
			<4>工作模式：收到start后，秒计数器sec_cnt从零开始以秒为单位来计数，计数到alarm[7:0]指定
			的数值时，产生一个int_pluse（时钟周期的正脉冲），秒数计数器回零并停止。
			【主要考察】32.768KHz的分频。
*Others:  
*Function List:
1.…………
2.…………
*History:  //修改历史记录列表，每条修改记录应包含修改日期、修改者及修改内容简介

**********************************************************************************/

`timescale 10ps/10ps

module counter (
				input clk,rst_n,start,
				input [7:0]alarm,
				output reg int_pluse
				);

reg clk_1s;
reg [13:0] counter_clk;
reg [7:0] sec_cnt;
reg en;

always @ (posedge clk, negedge rst_n) begin
if (~rst_n) en <=0;
else if (start) en <=1;
else if (int_pluse==1) en <=0;
else en <= en;
end

always @ (posedge clk, negedge rst_n) begin
if (~rst_n) begin    
			counter_clk <=0;
			clk_1s<=0;
			end
else begin
	counter_clk<=counter_clk+1;
	if(&counter_clk=='b1) clk_1s<=~clk_1s;
end
end

always @ (posedge clk_1s , negedge rst_n) begin
if (~en) begin    
			int_pluse <=0;
			sec_cnt<=0;
			end
else begin
	sec_cnt <= sec_cnt+1;
	if(sec_cnt==alarm) begin
	int_pluse <=1;
	sec_cnt<=0;
		end
	end
end

endmodule

module counter_tb;
reg clk,rst_n,start;
reg [7:0]alarm;
wire int_pluse;

counter U1 (clk,rst_n,start,alarm,int_pluse);

initial begin
{clk,rst_n,start}=3'b010;
alarm=8'b00100111;
#7 rst_n=0;
#20 rst_n=1;
#20 start=1;
#10 start=0;
end

always #5 clk=~clk;

endmodule






