module  beep
#(
   parameter  CNT_MAX=25'd24999999,
   parameter    DO   =18'd190839,
   parameter    RE   =18'd170067,
   parameter    MI   =18'd151514,
   parameter    FA   =18'd143265,
   parameter    SO   =18'd127550,
   parameter    LA   =18'd113635,
   parameter    SI   =18'd101213
)
(
  input   wire   sys_clk      ,
  input   wire   sys_rst_n    ,
  
  output  reg    beep         
);
reg  [19:0]  cnt;
reg  [2:0]   cnt_500ms;
reg  [17:0]  Freq_cnt;
reg  [17:0]  Freq_data;
wire  [16:0]  Duty_data;


//针对0.5秒的计数器要计满多少个系统时�?
always@(posedge sys_clk  or  negedge sys_rst_n)
if(!sys_rst_n)
   cnt<=20'd0;
else if(cnt==CNT_MAX)
   cnt<=20'd0;
else
   cnt<=cnt+1;
//针对有几�?0.5秒，进行计数�?7个音符，共有7�?0.5s组成�?个循环；
always@(posedge sys_clk  or  negedge sys_rst_n)
if(!sys_rst_n)
   cnt_500ms<=3'd0;
else if(cnt_500ms==3'd6 && cnt==CNT_MAX)
   cnt_500ms<=3'd0;
else if(cnt==CNT_MAX)
   cnt_500ms<=cnt_500ms+1;
else
   cnt_500ms<=cnt_500ms;
//针对频率计数器：即每个音调对应的频率，他会计数几个系统时钟，距离262HZ，计�?190840个时�?
//并且：这个频�?262HZ对应的系统时钟个数，是会变化的，存在Freq_data�?
always@(posedge sys_clk  or  negedge sys_rst_n)
if(!sys_rst_n)
   Freq_cnt<=18'd0;
   //当记到当前发声音�?262HZ的最大时钟个数Freq_data=190840
   //或�?�，记满0.5s的发声时长了，就让频率计数器清零
else if(Freq_cnt==Freq_data || cnt==CNT_MAX)
   Freq_cnt<=18'd0;
else
   Freq_cnt<=Freq_cnt+1;
//针对 频率计数器的：最大计数时钟个数Freq_data
//do是频率为262HZ，对�?190840个时�?
//re是频率为262HZ，对�?170068个时�?
always@(posedge sys_clk  or  negedge sys_rst_n)
if(!sys_rst_n)
   Freq_data<=DO;
else  case(cnt_500ms)
        3'd0:Freq_data<=DO;
		3'd1:Freq_data<=RE;
		3'd2:Freq_data<=MI;
		3'd3:Freq_data<=FA;
		3'd4:Freq_data<=SO;
		3'd5:Freq_data<=LA;
		3'd6:Freq_data<=SI;
	 default:Freq_data<=DO;
      endcase
//针对占空比为50%�?占的时钟个数即Duty_data等于Freq_data的一�?
//直接用连续赋值语句进行赋值�?�右�?1位代表除�?2
assign  Duty_data=Freq_data>>1;
//针对输出beep，每隔一个占空比�?占据的时钟个数就�?1�?
always@(posedge sys_clk  or  negedge sys_rst_n)
if(!sys_rst_n)
   beep<=1'b0;
else if(Freq_cnt>=Duty_data)
   beep<=1'b1;
else
   beep<=1'b0;
endmodule