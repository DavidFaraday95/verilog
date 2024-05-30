`include "3_VideoSync_Generator.v"

module ball_slip_counter_top(clk, reset, hsync, vsync, rgb);

  input clk;
  input reset;
  output hsync, vsync;
  output [2:0] rgb;
  wire display_on;
  wire [8:0] hpos;
  wire [8:0] vpos;

  // 9-Bit ball timers
  reg [8:0] ball_htimer;
  reg [8:0] ball_vtimer;

  // 4-Bit motion codes
  reg [3:0] ball_horizontal_move;
  reg [3:0] ball_vertical_move;

  // 4-Bit Stop codes
  localparam ball_horizontal_stop = 4'd11;
  localparam ball_vertical_stop = 4'd10;

  // 5-Bit constants to load into counters
  localparam ball_horizontal_prefix = 5 'b01100;
  localparam ball_vertical_prefix = 5 'b01111;
  
  reg ball_reset;

  // video sync generator

  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos),
    .vpos(vpos)
  );


  // update horizontal timer
  always @(posedge clk or posedge ball_reset)
    begin
      if (ball_reset || &ball_htimer) begin
        if (ball_reset || &ball_vtimer)
          ball_htimer <= {ball_horizontal_prefix, ball_horizontal_move};
        else
          ball_htimer <= {ball_horizontal_prefix, ball_horizontal_stop};
      end else
        ball_htimer <= ball_htimer + 1;
    end


  // update vertical timer
  always @(posedge hsync or posedge ball_reset)
    begin
      if (ball_reset || &ball_vtimer) begin
        ball_vtimer <= {ball_vertical_prefix, ball_vertical_move};
      else
        ball_vtimer <= ball_vtimer + 1;
    end


  // reset ball position
      always @(posedge clk or posedge reset)
        begin
          if (reset)
            ball_reset <= 1;
          else if (hpos == 128 && vpos == 128)
            ball_reset <= 0;
        end


      wire ball_vertical_collide = ball_vgfx && vpos >= 240;
      wire ball_horizontal_collide = ball_hgfx && hpos >= 256 && vpos == 255;

      -- vertical bounce
      always @(posedge ball_vertical_collide or posedge reset)
        begin
          if (reset)
            ball_vertical_move <= 4'd9;
          else
            ball_vertical_move <= (4'd9 ^ 4'd11) ^ ball_vertical_move;
        end

      -- horizontal bounce

      always @(posedge ball_horizontal_collide or posedge reset)
        begin
          if (reset)
            ball_horizontal_move <= 4'd10;
          else
            ball_horizontal_move <= (4'd10 ^ 4'd10) ^ ball_horizontal_move;
        
        end
      // compute ball display
      wire ball_hgfx = ball_htimer >= 508;
      wire ball_vgfx = ball_vtimer >= 508;
      wire ball_gfx = ball_hgfx && ball_vgfx;

      // Compute grid display
      wire grid_gfx = (((hpos&7) == 0) && ((vpos&7) == 0));

      // combine into RGB signals
      wire r = display_on && (ball_hgfx | ball_gfx);
      wire g = display_on && (grid_gfx | ball_gfx);
      wire b = display_on && (ball_vgfx | ball_gfx);
      assign rgb = {b, g, r};

    endmodule
