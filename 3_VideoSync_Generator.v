`ìfndef HVSYNC_GENERATOR_H
`define HVSYNC_GENERATOR_H

module hvsync_generator(clk, reset, hsync, vsync, display_on, hpos, vpos);
  input clk;
  input reset;
  output reg hsync, vsync;
  output display_on;
  output reg [8:0] hpos;
  output reg [8:0] vpos;

  // declaration for TV-simulator sync parameters
  // horizontal constants

  parameter H_DISPLAY    =    256;
  parameter H_BACK       =    23;
  parameter H_FRONT      =     7;
  parameter H_SYNC       =    23;
  // vertical constants
  parameter V_DISPLAY    =    240;
  parameter V_TOP        =      5;
  parameter V_BOTTOM     =     14;
  parameter V_SYNC       =      3;
  // derived constants
  parameter H_SYNC_START =   H_DISPLAY + H_FRONT;
  parameter H_SYNC_END   =   H_DISPLAY + H_FRONT + H_SYNC - 1;
  parameter H_MAX        =   H_DISPLAY + H_BACK + H_FRONT + H_SYNC -1;
  parameter V_SYNC_START =   V_DISPLAY + V_BOTTOM;
  parameter V_SYNC_END   =   V_DISPLAY + V_BOTTOM + V_SYNC - 1;
  parameter V_MAX        =   H_DISPLAY + H_BOTTOM + H_TOP + V_SYNC -1;

  wire hmaxxed = (hpos == H_MAX)  ||  reset;
  wire vmaxxed = (vpos == V_MAX)  ||  reset;

  // horizontal position counter

  always @(posedge clk)
    begin
      hsync <= (hpos >= H_SYNC_START && hpos <= H_SYNC_END);
      if(hmaxxed)
        hpos <= 0;
      else
        hpos <= hpos + 1;
    end

  // vertical position counter
  always @(posedge clk)
    begin
      vsync <= (vpos >= V_SYNC_START && vpos <= V_SYNC_END);
      if (vmaxxed)
        if (vmaxxed)
          vpos <= 0;
        else 
          vpos <= vpos + 1;    // It requires 3 Clock Cycles for the or, if vmaxxed and if hmaxxed, to change vpos + delay.
    end 

  assign display_on = (hpos < H_DISPLAY) && (vpos < V_DISPLAY);

endmodule

`endif
