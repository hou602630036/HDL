module transmit( input clk_tx, input rst_n, input ren, input [7:0] data_in, input clk_tr, output [7:0] data_out

    );
reg ack , req;
reg  ack_r1, ack_r2, ack_r3;
always@ (posedge clk_tx or negedge rst_n)
begin
    if (!rst_n)
        {ack_r1, ack_r2, ack_r3} <= 0;
    else
        {ack_r3, ack_r2, ack_r1} <= {ack_r2, ack_r1, ack};
end
wire pos_ack;
assign pos_ack = ack_r2 & ~ack_r3;
always @ (posedge clk_tx or negedge rst_n)
begin
    if (! rst_n)
        req <= 0;
    else if (ack_r2 == 0 && ren)
        req <= 1;
    else if (pos_ack)
        req <= 0;
end

reg [7:0] data_reg;

always@ (posedge clk_tx or negedge rst_n)
begin
    if (!rst_n)
    begin
        data_reg <= 0;
    end
    else if (req)
        data_reg <= data_in;
end
reg req_r1,req_r2,req_r3;
wire pos_req;
wire neg_req;
assign pos_req = req_r2 &~req_r3;
assign neg_req = ~req_r2 & req_r3;
always@ (posedge clk_tr or negedge rst_n)
begin
    if (!rst_n)
    {req_r3,req_r2,req_r1} <= 0;
    else
    {req_r3,req_r2,req_r1} <= {req_r2, req_r1, req};
end
reg data_out_reg;
always@ (posedge clk_tr or negedge rst_n)
begin
    if (! rst_n)
    ack <= 0;
    else if (pos_req)
    ack <= 1;
    else if (neg_req)
    ack <= 0;
end
always @ (posedge clk_tr or negedge rst_n)
begin
    if (! rst_n)
    data_out_reg <= 0;
    else if (pos_req)
    data_out_reg <= data_reg;
end
assign data_out = data_out_reg;
endmodule