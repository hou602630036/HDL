//??????????????10??????5??10?????????
//UTF-8
module drink (clk,rst,a,b,charge,outp);
input clk,rst,a,b;
output charge,outp;
reg charge,outp;


reg [1:0] next_state,current_state;

parameter 	idle='d0,
		coin5='d1,
		coin10='d2,
		coin15='d3;

always @ (posedge clk or posedge rst) 
begin
if(rst) begin
	current_state <= idle;
	charge <='b0;
	outp <='b0;
	end
else current_state <= next_state;

end

always @(*)
begin
case (current_state)
	idle: 
		begin
		if(a) next_state=coin5;
		else if(b) next_state=coin10;
		else next_state=current_state;
		end
	coin5:
		begin
		if(a) next_state=coin10;
		else if(b) next_state=coin15;
		else next_state=current_state;
		end
	coin10: next_state=idle;
	coin15: next_state=idle;
	default:next_state=current_state;
endcase
end

always @ (*)
begin
case (current_state)
	coin10: {charge,outp}=2'b01;
	coin15: {charge,outp}=2'b11;
	default:{charge,outp}=2'b00;
endcase
end
endmodule

module drink_tb;
reg clk,rst,a,b,temp;
wire charge,outp;

drink U1 (.clk(clk),.rst(rst),.a(a),.b(b),.charge(charge),.outp(outp));

initial begin
{clk,rst,a,b}=4'b0000;
#7 rst=1;
#27 rst=0;
end

always #5 clk=~clk;

initial begin
repeat(100)begin
#50 temp=$random%2;
{a,b} = temp ? 2'b01 : 2'b10;
end
end

endmodule
