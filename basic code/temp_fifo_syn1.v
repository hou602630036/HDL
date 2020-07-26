module FIFO_syn (clk,rst,din,dout,wr_en,rd_en,full,empty);
input clk,rst,wr_en,rd_en;
input [7:0] din;
output [7:0] dout;
output full,empty;

reg [7:0] fifo[3:0];
reg [3:0] wr_addr,rd_addr;
reg [4:0] counter;
reg [7:0] dout;

always @ (posedge clk,posedge rst) begin
if (rst) begin wr_addr=0; rd_addr=0; counter=0;end
else begin
case ({wr_en,rd_en})
2'b00 : begin
		wr_addr<=wr_addr;
		rd_addr<=rd_addr;
		counter<=rd_addr;
		end
2'b01 : begin
		dout<=fifo[rd_addr];
		counter<=counter-1;
		if (rd_addr==15) rd_addr<='d0;
		else rd_addr<=rd_addr+1;
		end
2'b10 : begin
		fifo[wr_addr]<=din;
		counter<=counter +1;
		if (wr_addr==15) wr_addr<='d0;
		else wr_addr<=wr_addr+1;
		end
2'b11 : begin
		fifo[wr_addr]<=din;
		dout<=fifo[rd_addr];
		counter<=counter;
		if (wr_addr==15) wr_addr<='d0;
		else wr_addr<=wr_addr+1;
		if (rd_addr==15) rd_addr<='d0;
		else rd_addr<=rd_addr+1;		
		end		
endcase
end
end

assign full = (counter==16) ? 1:0;
assign empty= (counter==0 ) ? 1:0;

endmodule
