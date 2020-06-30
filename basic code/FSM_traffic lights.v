/*********************************************************************************
*FileName:	traffic lights
*Author:	zongsheng hou
*Version:	v1
*Date:  	2020.06.30
*Description:  
			描述一个交通信号灯的设计: 红灯30s，绿灯25s，黄灯5s。AB为横纵两方向信号灯。
				A				B
			  黄 5s			  红 5s
			  红 25s		  绿 25s
			  红 5s			  黄 5s
			  绿 25s		  红 25s
			A,B分别为3bit位宽的信号灯数据:[RGY]
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

module traffic_lights (clk,rst,A,B);
input clk,rst;
output [2:0] A,B;
reg [2:0] A,B;
reg [4:0] counter;
reg rst_counter;
reg [2:0] n_s,c_s;

parameter	state0='d0,
			state1='d1,
			state2='d2,
			state3='d3,
			idle  ='d4;
			
			
always @ (posedge clk, posedge rst) begin
if (rst) c_s<=idle;
else c_s<=n_s;
end

always @ (*)begin
case (c_s) 
	idle  : begin
			n_s=state0; rst_counter='d1;
			end
	state0: begin
			if(counter=='d4) begin n_s=state1; rst_counter='d1; end
			else begin n_s=c_s; rst_counter='d0;  end
			end
	state1: begin
			if(counter=='d24) begin n_s=state2; rst_counter='d1; end
			else begin n_s=c_s; rst_counter='d0;  end
			end
	state2: begin
			if(counter=='d4) begin n_s=state3; rst_counter='d1; end
			else begin n_s=c_s; rst_counter='d0;  end
			end
	state3: begin
			if(counter=='d24) begin n_s=state0; rst_counter='d1; end
			else begin n_s=c_s; rst_counter='d0;  end
			end
	default: n_s=c_s;
endcase
end

always @ (*) begin
case (c_s) 
	idle  : {A,B}={6'b111111};
	state0: {A,B}={3'b001,3'b100};
	state1: {A,B}={3'b100,3'b010};
	state2: {A,B}={3'b100,3'b001};
	state3: {A,B}={3'b010,3'b100};
	default: {A,B}={6'b0};
endcase	
end

always @ (posedge clk) begin
if (rst_counter) counter<='b0;
else counter=counter+1;
end

endmodule


module traffic_lights_tb;
reg clk,rst;
wire [2:0] A,B;

traffic_lights U1 (clk,rst,A,B);

initial begin
{clk,rst}=2'b00;
#7 rst=1;
#27 rst=0;
end

always #5 clk=~clk;

endmodule











