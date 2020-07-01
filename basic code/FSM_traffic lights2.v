/*********************************************************************************
*FileName:	traffic lights
*Author:	zongsheng hou
*Version:	v1
*Date:  	2020.06.30
*Description:  
			描述一个交通信号灯的设计: 红灯30s，绿灯25s，黄灯5s。AB为横纵两方向信号灯。
				A				B
			  红 25s		  绿 25s
			  红 5s		 	  黄 5s
			  绿 25s		  红 25s
			  黄 5s		      红 5s
			A,B分别为3bit位宽的信号灯数据:[RGY]
			第二种实现方式，通过en信号使得状态转移部分只能在计数到达一定值时，才可以转换
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

module light (rst,clk,r,g,y);
input rst,clk;
output r,g,y;
reg r,g,y;
reg [1:0] c_s,n_s;
reg en;
reg [7:0] counter;

parameter 	state0 = 'b00,
		state1 = 'b01,
		state2 = 'b10,
		state3 = 'b11;

always @ (posedge clk) begin
	if (rst) c_s<=state0; 
	else if (en) c_s <= n_s;
	else  c_s <= c_s;
end

always @(*) begin
case (c_s)
	state0 : n_s = state1;
	state1 : n_s = state2;
	state2 : n_s = state3;
	state3 : n_s = state0;
	default : n_s = state1;
endcase
end

always @(*) begin
case (c_s)
	state0 : {r,g,y} = 3'b100;
	state1 : {r,g,y} = 3'b100;
	state2 : {r,g,y} = 3'b010;
	state3 : {r,g,y} = 3'b001;
	default : {r,g,y} = 3'b100;
endcase

end

always @(posedge clk) begin
if(rst) begin counter<=0; en<=0; end
else begin 
case (c_s) 
	state0 : begin
		if(counter < 24) begin counter <= counter+1; en<=0; end
		else begin counter <=0; en<=1; end 
		end
	state1 : begin
		if(counter < 4) begin counter <= counter+1; en<=0; end
		else begin counter <=0; en<=1; end 
		end
	state2 : begin
		if(counter < 24) begin counter <= counter+1; en<=0; end
		else begin counter <=0; en<=1; end 
		end
	state3 : begin
		if(counter < 4) begin counter <= counter+1; en<=0; end
		else begin counter <=0; en<=1; end 
		end
endcase

end

end

endmodule

module light_tb;
reg rst,clk;
wire r,g,y;

initial begin
{rst,clk} = 2'b00;
#1000 $stop;
end

initial begin
#17 rst=1;
#37 rst=0;
end

always #5 clk=~clk;

light U0 (rst,clk,r,g,y);

endmodule
