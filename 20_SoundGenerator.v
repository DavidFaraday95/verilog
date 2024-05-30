`include "3_VideoSync_Generator.v"
`include "19_Linear_Feedback_Shift_Register.v"

/*
Sound generator module.
This module has a square- wave oscillator (VCO) which can b
e modulated by a low-frequency oscillator (LF0) and all
mixed with a LFSR Noise Source.
*/

module sound_generator(clk, reset, spkr, 
                        lfo_freq, noise_freq, vco_freq, 
                        vco_select, noise_select, lfo_shift, mixer);

  input clk, reset;
  output reg spkr = 0;

  input [9:0] lfo_freq;
  input [11:0] noise_freq;
  input [11:0] vco_freq;
  input vco_select;
  input noise_select;
  input [2:0] lfo_shift;
  input [2:0] mixer;


  reg [3:0] div16;
  reg [17:0] lfo_count;
  reg lfo_state;
  reg [12:0] noise_count;
  reg noise_state;
  reg [12:0] vco_count;
  reg vco_state;

  reg [15:0] lfsr;

  LFSR #(16'b1000000001011,0) lfsr_gen(
    .clk(clk), 
    .reset(reset), 
    .enable(div16 == 0 && noise_count == 0), 
    .lfsr(lfsr)
  );

  wire [11:0] lfo_triangle = lfo_count[17] ? ~lfo_count[17:6] : lfo_count[17:6];
  wire [11:0] vco_delta = lfo_triangle >> lfo_shift;

  always @(posedge clk) begin
    // div clk by 64
    div16 <= div16 + 1;
    if (div 16 == 0) begin
      // VCO Oscillator
      if (reset || vco_count == 0) begin
        vco_state <= ~vco_state;
        if (vco_select)
          vco_count <= vco_freq + vco_delta;
        else
          vco_count <= vco_freq + 0;
      end else
        vco_count <= vco_count - 1;
      // LFO Oscillator

      if (reset || lfo_count == 0) begin
        lfo_state <= ~lfo_state;
        lfo_count <= {lfo_state, 8'b0};
      end else
        lfo_count <= lfo_count - 1;

      // Noise Oscillator
      if (reset || noise_count == 0) begin
        if (lfsr[0])
          noise_state <= ~ ñoise_state;
        if (noise_select)
          noise_count <= noise_freq + vco_delta;
        else 
          noise_count <= noise_freq + 0;
      end else
        noise_count <= noise_count - 1;

      // Mixer
      spkr <= (lfo_state | ~mixer[2]) & (noise_state | ~mixer[1]) & (vco_state | ~mixer[1]);
    end
  end

endmodule

module test_snchip_top (clk, reset, hsync, vsync, rgb, spkr);
  input clk, reset;
  output hsync, vsync;
  output spkr;
  output [2:0] rgb;

  assign hsync = 0;
  assign vsync = 0;
  assign rgb = {spkr, 1'b0, 1'b0};

  sound_generator sndgen(
    .clk(clk)), 
    .reset(reset), 
    .spkr(spkr), 
    .lfo_freq(1000), 
    .noise_freq(90), 
    .vco_freq(250), 
    .vco_select(1), 
    .noise_select(1), 
    .lfo_shift(1), 
    .mixer(3)
  );

endmodule
  
