`include "3_VideoSync_Generator.v"


module paddles_top (clk, reset, hsync, vsync, hpaddle, vpaddle, rgb);
  input clk, reset;
  input hpaddle, vpaddle;
  output hsync, vsync;
  output [2:0] rgb;

  wire display_on;
  wire [8:0] hpos;
  wire [8:0] vpos;

  reg [7:0] player_x;
  reg [7:0] player_y;
  reg [7:0] paddle_x;
  reg [7:0] paddle_y;

  // read horizontal paddle
  always @(posedge hpaddle)      // Input transition, Speichertransfer
    paddle_x <= vpos[7:0];       // Speicher <= wire

  // read vertical paddle 
  always @(posedge vpaddle)      // Input transition, Speichertransfer
    paddle_y <= vpos[7:0];       // Speicher <= wire

  always @(posedge vsync)
    begin
      player_y <= paddle_x;      // Inputs auf Register geladen
      player_y <= paddle_y;      // Inputs auf Register geladen
    end

  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos),
    .vpos(vpos)
  );

  // display paddle positions on screen
  wire h = hpos [7:0] >= paddle_x;
  wire v = vpos [7:0] >= paddle_y;

  assign rgb = {1'b0, display_on && h, display_on && v};

endmodule
    
