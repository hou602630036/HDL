/*********************************************************************************
*FileName:	sequential detection
*Author:	zongsheng hou
*Version:	v1
*Date:  	2020.07.01
*Description:  
			画出可以检测10010串的状态图,并verilog实现之。
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

module sequential_detection (clk,rst,inp,outp);
input clk,rst,inp;
output outp;
reg outp;
 
reg [2:0] c_s,n_s;
 
parameter	idle='d0,
			state1='d1,
			state2='d2,
			state3='d3,
			state4='d4,
			state5='d5;
 
always @ (posedge clk,posedge rst) begin
if (rst) c_s<=idle;
else c_s<=n_s;
end

always @ (*) begin
case (c_s)
	idle:	begin 
			if (inp) n_s=state1;
			else n_s=c_s;
			end
	state1:	begin 
			if (~inp) n_s=state2;
			else n_s=c_s;
			end
	state2:	begin 
			if (~inp) n_s=state3;
			else n_s=state1;
			end
	state3:	begin 
			if (inp) n_s=state4;
			else n_s=idle;
			end
	state4:	begin 
			if (~inp) n_s=state5;
			else n_s=state1;
			end
	state5: n_s=idle;
	default:n_s=c_s;
endcase
end

always @ (*) begin
case (c_s)
	state5: outp='b1;
	default:outp='b0;
endcase
end

endmodule

module sequential_detection_tb ;
reg clk,rst,inp;
wire outp;

sequential_detection U1 (clk,rst,inp,outp);

initial begin
{clk,rst,inp}='b000;
#7 rst='b1;
#27 rst='b0;
end

always #5 clk=~clk;

always #20 inp=$random%2;

endmodule