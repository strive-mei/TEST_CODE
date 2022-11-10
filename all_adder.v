module  all_adder
(
   input  wire  in_1,
   input  wire  in_2,
   input  wire  cin,
   output wire sum,
   output wire count

);
//中间的两个传递数据的线型变量wire
wire   h0_count;
wire   h1_count;
wire   h0_sum;
//直接例化两个半加器，进行调用，再对半加器的输出进行相或；
//第一个半加器
half_adder   half_adder_inst0
(
  .in_1(in_1),
  .in_2(in_2),
  .count(h0_count),
  .sum(h0_sum),
 );
 //第二个半加器
half_adder   half_adder_inst1
(
  .in_1(h0_sum),
  .in_2(cin),
  .count(h1_count),
  .sum(sum),
 );
 //输出out是两个半加器out的或运算
 assign count =h0_count || h1_count;
 endmodule