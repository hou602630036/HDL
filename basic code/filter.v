module  filter(
      input  wire   sys_clk       ,   //系统时钟50MHz
      input  wire   sys_rst_n  ,   //全局复位
      input  wire   data_in       ,   //单bit输入信号

      outputreg    data_out      //滤除高电平或者低电平宽度小于4个时钟周期后的单bit输出信号
);

reg            data_in_reg;
reg     [1:0]  cnt;

wire           podge;
wire           nedge;

//data_in_reg:将单bit输入信号打一拍
always@(posedge sys_clk or negedge sys_rst_n)
      if(sys_rst_n ==1'b0)
         data_in_reg <=1'b0;
      else
         data_in_reg <= data_in;
    
//podge:对输入信号进行上升沿检测
assign podge = data_in &&(~data_in_reg);

//nedge:对输入信号进行下降沿检测
assign nedge =~data_in && data_in_reg;
    
//cnt:用于计数宽度小于4个时钟周期的抖动
always@(posedgesys_clk or negedge  sys_rst_n)
      if(sys_rst_n ==1'b0)   
         cnt <=2'b0; 
      else   if(podge ==1'b1|| nedge ==1'b1)
         cnt <=2'b0; 
      else  
         cnt <= cnt +1'b1;  
           
//data_out:滤除高电平或者低电平宽度小于4个时钟周期后的单bit输出信号
always@(posedgesys_clk or negedge  sys_rst_n)
      if(sys_rst_n ==1'b0)   
         data_out <=1'b0;
      else   if(&cnt ==1'b1)
         data_out <= data_in_reg;

endmodule

`timescale1ns/1ns

module  tb_filter();

//声明Testbench中信号的端口类型
reg     sys_clk;
reg     sys_rst_n;
reg     data_in;

wire    data_out;

//定义Testbench中的内部变量
reg[7:0]  tb_cnt;

//初始化系统时钟、全局复位
initial begin
      sys_clk     =1'b0;  
      sys_rst_n <=1'b0;
      #20 sys_rst_n <=1'b1;  
end

//sys_clk:模拟系统时钟，每10ns电平翻转一次，周期为20ns，频率为50MHz
always  #10 sys_clk =~sys_clk;

//tb_cnt:通过该计数器的计数值来控制毛刺区间
always@(posedgesys_clk or negedge sys_rst_n)
      if(sys_rst_n ==1'b0)
         tb_cnt <=8'b0;
      else   if(&tb_cnt ==1'b1)
         tb_cnt <=8'b0;
      else
         tb_cnt <= tb_cnt +1'b1;

//data_in:模拟单bit输入信号
always@(posedgesys_clk or negedge sys_rst_n)
      if(sys_rst_n ==1'b0)
         data_in <=1'b0;
      else   if((tb_cnt >=8'd20&& tb_cnt <=8'd28)||(tb_cnt >=8'd60&& tb_cnt <=8'd65)||(tb_cnt >=8'd80&& tb_cnt <=8'd85)||(tb_cnt >=8'd120&& tb_cnt <=8'd140))
         data_in <={$random}%2;   //计数器在该区间内产生非负随机数0、1，模拟单bit输入信号高电平或者低电平宽度小于4个时钟周期的毛刺
      else   if((tb_cnt <8'd20)||(tb_cnt >8'd65&& tb_cnt <8'd80))
         data_in <=1'b1;  //计数器在该区间内保持为1
      else   if((tb_cnt >8'd28&& tb_cnt <8'd60)||(tb_cnt >8'd85|| tb_cnt <8'd120)  ||(tb_cnt >8'd140))
         data_in <=1'b0;  //计数器在该区间内保持为0
    
//----------------filter_inst------------
 filter  filter_inst(
      .sys_clk   (sys_clk   ),  //input    sys_clk   
      .sys_rst_n (sys_rst_n ),  //input    sys_rst_n 
      .data_in   (data_in   ),  //input    data_in
                        
      .data_out  (data_out  )   //output   data_out
);

endmodule 

