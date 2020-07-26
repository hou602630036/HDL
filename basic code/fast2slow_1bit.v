module fast_to_slow(
     input  wire   clka       ,   //sourceclock
     input  wire   src_rst_n   , //sourceclock reset (0:reset)
     input  wire   Signal_a   ,   //sourceclock pulse in
     input  wire   clkb       ,   //destinationclock
     input  wire   dst_rst_n  ,   //destinationclock reset (0:reset)
   
     outputwire   Signal_b       //destinationpulse out
		);
 
reg     src_state   ;
reg     state_dly1  ;
reg     state_dly2  ;
reg     dst_state   ;
 
//将脉冲信号转化为沿信号
always@(posedge clka ornegedge src_rst_n)
     if(src_rst_n ==1'b0)
         src_state<=1'b0;
     elseif(Signal_a ==1'b1)
         src_state<=~src_state;
 
  //将展宽的脉冲打三拍
always@(posedge clkb ornegedge dst_rst_n)
     if(dst_rst_n ==1'b0)begin
        state_dly1 <=1'b0;
         state_dly2 <=1'b0;
         dst_state  <=1'b0;
     end              
     elsebegin    
         state_dly1 <= src_state;
         state_dly2 <= state_dly1;
         dst_state  <= state_dly2;
     end
 
//上升沿和下降沿同时检测
assign Signal_b = dst_state ^ state_dly2;

endmodule


module tb_fast_to_slow();

reg     clka;
reg     src_rst_n;
reg     Signal_a;
reg     clkb;
reg     dst_rst_n;
    
wire    Signal_b;

//初始化系统时钟、复位
initial begin
 clka        =1'b1;
 src_rst_n <=1'b0;
 Signal_a  <=1'b0;
 clkb       =1'b1;
 dst_rst_n <=1'b0;
 #3.334
  //复位释放
 src_rst_n <=1'b1;
 dst_rst_n <=1'b1;
 #33.34;
  //第一个脉冲
 Signal_a  <=1'b1;
 #3.334;     
 Signal_a  <=1'b0;
 #66.68;    
  //第二个脉冲
 Signal_a  <=1'b1;
 #3.334;     
 Signal_a  <=1'b0;
end

//clka:模拟快速时钟域的时钟，每1.667ns电平翻转一次，频率近似为300MHz
always  #1.667 clka =~clka;

//clkb:模拟慢速时钟域的时钟，每5ns电平翻转一次，频率为100MHz
always  #5 clkb =~clkb;

//----------------fast_to_slow_isnt-----------
 fast_to_slow  fast_to_slow_isnt(
 .clka      (clka      ),  //input    clka      
 .src_rst_n(src_rst_n),  //input   src_rst_n 
 .Signal_a  (Signal_a),  //input   Signal_a     
 .clkb      (clkb      ),  //input    clkb      
 .dst_rst_n(dst_rst_n),  //input   dst_rst_n 
                                            
 .Signal_b (Signal_b  )   //output  Signal_b     
);
      
endmodule
