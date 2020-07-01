/*********************************************************************************
*FileName:	adder
*Author:	zongsheng hou
*Version:	v1
*Date:  	2020.07.01
*Description:  
			adder1 单比特半加器
			adder2 单比特半加器,计算符号实现。c=a·b s=a^b;
			adder3 单比特半加器,基本电路实例化实现
			full_adder1 单比特全加器
			full_adder2 8比特全加器
			full_adder3 单比特全加器，计算符号实现。c=a·b+a·cin+b·cin；s=a^b^cin;
			full_adder5 单比特全加器，半加器的实例化实现
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
module adder1(a,b,c,s);
input a,b;
output c,s;

assign {c,s}=a+b;

endmodule

module adder2(a,b,c,s);
input a,b;
output c,s;

assign c=a&b;
assign s=a^b;

endmodule

module adder3(a,b,c,s);
input a,b;
output c,s;

and u1 (c,a,b);
xor u2 (s,a,b);

endmodule

module full_adder1(a,b,cin,c,s);
input a,b,cin;
output c,s;

assign {c,s}=a+b+cin;

endmodule

module full_adder2(a,b,cin,c,s);
input [7:0] a,b;
input cin;
output c;
output [7:0] s;

assign {c,s}=a+b+cin;

endmodule

module full_adder3(a,b,cin,c,s);
input a,b,cin;
output c,s;

assign c=a&b+a&cin+b&cin;
assign s=a^b^cin;

endmodule

module full_adder4(a,b,cin,c,s);
input a,b,cin;
output c,s;
wire c1,c2,c3;

and u1 (c1,a,b);
and u2 (c2,a,cin);
and u3 (c3,b,cin);
or u4 (c,c1,c2,c3);
xor u5 (s,a,b,cin);

endmodule

module full_adder5(a,b,cin,c,s);
input a,b,cin;
output c,s;
wire c1,s1,c2;

adder1 u5 (a,b,c1,s1);
adder1 u6 (s1,cin,c2,s);

assign c=c1|c2;

endmodule



module adder_tb ;
reg a,b,cin;
wire c1,c2,c3,c4,c5,c6,c7;
wire s1,s2,s3,s4,s5,s6,s7;
wire [6:0] c,s;

adder1 u1 (a,b,c1,s1);
adder2 u2 (a,b,c2,s2);
adder3 u3 (a,b,c3,s3);
full_adder1 u4 (a,b,cin,c4,s4);
full_adder3 u5 (a,b,cin,c5,s5);
full_adder4 u6 (a,b,cin,c6,s6);
full_adder5 u7 (a,b,cin,c7,s7);

assign c={c1,c2,c3,c4,c5,c6,c7};
assign s={s1,s2,s3,s4,s5,s6,s7};

initial begin
{a,b,cin}=3'b101;
end

endmodule

module full_adder2_tb;
reg cin;
reg [7:0] a,b;
wire [7:0] s;
full_adder2 U1 (a,b,cin,c,s);

initial begin
a=8'b1000_1011;
b=8'b1000_1011;
cin=1'b1;
end

endmodule