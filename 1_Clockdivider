// 1. Clock Divider

module clockdivider(
  input clk,
  input reset,
  output clk_div2,
  output clk_div4,
  output clk_div8,
  output clk_div16,
  output clk_div32
);
  
  always @(posedge clk)
    clk_div2 <= reset ? 0: ~clk_div2;
  
  always @(posedge clk_div2)
    clk_div4 <= ~clk_div4;
    
  always @(posedge clk_div4)
    clk_div8 <= ~clk_div8;
  
  always @(posedge clk_div8)
    clk_div16 <= ~clk_div16;
  
  always @(posedge clk_div16)
    clk_div32 <= ~clk_div32;

endmodule;
