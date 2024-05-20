`ìnclude "3_VideoSync_Generator.v"

module ball_absolute (clk, reset, hsync, vsync, rgb);
  input clk;
  input reset;
  output hsync, vsync;
  output rgb[2:0];
  wire display_on;
  wire [8:0] hpos;
  wire [8:0] vpos;

  reg [8:0] ball_hpos;
  reg [8:0] ball_vpos;

  reg [8:0] ball_horizontal_move = 2;
  reg [8:0] ball_vertical_move = 2;

  localparam ball_horizontal_initial = 128;
  localparam ball_vertical_initial = 128;

  localparam BALL_SIZE = 4;

  hvsync_generator hvsync_gen (
    .clk(clk),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos),
    .vpos(vpos)
  );

  always @(posedge vsync or posedge reset)
    begin
      if (reset) begin
        ball_vpos <= ball_horizontal_initial;
        ball_hpos <= ball_vertical_initial;

      end else begin
        ball_hpos <= ball_hpos + ball_horizontal_move;
        ball_vpos <= ball_vpos + ball_vertical_move;

      end
    end

  always @(posedge ball_horizontal_collide)
  begin
    ball_horizontal_move <= -ball_horizontal_move;
  end

  always @(posedge ball_vertical_collide)
  begin
    ball_vertical_move <= -ball_vertical_move;
  end

  // offset of ball position from video beam
  wire [8:0] ball_hdiff = hpos - ball_hpos;
  wire [8:0] ball_vdiff = vpos - ball_vpos;

  // ball graphics output 
  wire ball_hgfx = ball_hdiff < BALL_SIZE;
  wire ball_vgfx = ball_vdiff < BALL_SIZE;
  wire ball_gfx = ball_hgfx && ball_vgfx;

  // Collide with vertical and horizontal boundaries
  // these are set when the ball touches a border
  wire ball_vertical_collide = ball_vpos >= 240 - BALL_SIZE;
  wire ball_hoizontal_collide = ball_hpos >= 256 - BALL_SIZE;

  // Combined signals to RGB Output
  wire grid_gfx = (((hpos&7) == 0) && ((vpos&7)==0));
  wire r = diplay_on && (ball_hgfx | ball_gfx);
  wire g = diplay_on && (grid_gfx | ball_gfx);
  wire b = diplay_on && (ball_vgfx | ball_gfx);

  assign rgb = {b,g,r};

endmodule
