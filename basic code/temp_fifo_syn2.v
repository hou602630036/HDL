module fifo_syn2 (clk,rst,din,dout,wr_en,rd_en,full,empty);
input clk,rst,wr_en,rd_en;
input [7:0] din;
output [7:0] dout;
output full,empty;

reg [7:0] fifo [15:0];
reg [4:0] wr_addr,rd_addr;
reg [7:0] dout;

always @ (posedge clk, posedge rst) begin
if (rst) begin   end
else begin
case ({wr_en,rd_en})
2'b00 : begin
		wr_addr<=wr_addr;
		rd_addr<=rd_addr;
		dout<=0;
		end
2'b01 : begin
		dout<=fifo[rd_addr];
		if (rd_addr==15) rd_addr<=0;
		else rd_addr<=rd_addr+1;
		end
2'b10 : begin
		fifo[wr_addr]<=din;
		if (wr_addr==15) wr_addr<=0;
		else wr_addr<=wr_addr+1;
		end
2'b11 : begin
		fifo[wr_addr]<=din;
		dout<=fifo[rd_addr];
		if (wr_addr==15) wr_addr<=0;
		else wr_addr<=wr_addr+1;
		if (rd_addr==15) rd_addr<=0;
		else rd_addr<=rd_addr+1;
		end
endcase

end

end

assign full = ((wr_addr[4]^rd_addr[4]) && (wr_addr[3:0]==rd_addr[3:0])) ? 1:0;
assign empty = (wr_addr==rd_addr) ? 1:0;

endmodule