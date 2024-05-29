
----------------------------------------------------------------------------------
-- SVN information section start 
-- $URL: $ 
-- $Revision: $ 
-- $Author: $ 
-- $Date: $ 
-- SVN information section end ------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.debounce_pkg.all;

library work;
use work.turn_detect_pkg.all;

entity robo is
  port ( 
        clk_i            : in  std_logic; -- 100 MHz system clock
        
        rot_a_i          : in  std_logic;
        rot_b_i          : in  std_logic;
        
        btn_center_i     : in  std_logic; -- used as reset
        
        led_o            : out std_logic_vector(4 downto 0)
        );

end robo;

architecture rtl of robo is
  
  signal rst_n          : std_logic;
  
  signal rot_a          : std_logic;
  signal rot_b          : std_logic;

  signal dir_left       : std_logic;
  signal dir_right      : std_logic;
  signal still          : std_logic;
  signal step_left      : std_logic;
  signal step_right     : std_logic;

begin

  rst_n <= not btn_center_i;

  -- instantiation of debounce
  debounce_i0: debounce
    generic map (
                 duration_g    => 500000,   -- number of clock cycles for debouncing: 5ms = 500000 clock cycles
                 high_active_g => true -- true iff button_i = 1 means that button is pressed
                )
    port map (
              clk_i         => clk_i,
              rst_n_i       => rst_n,
              button_i      => rot_a_i,
              state_o       => rot_a,  -- 1 = butten is pressed
              released_o    => open,   -- 1 (for one clock cycle) = button has released
              pressed_o     => open    -- 1 (for one clock cycle) = button has pressed
             );
  debounce_i1: debounce
    generic map (
                 duration_g    => 500000,   -- number of clock cycles for debouncing: 5ms = 500000 clock cycles
                 high_active_g => true -- true iff button_i = 1 means that button is pressed
                )
    port map (
              clk_i         => clk_i,
              rst_n_i       => rst_n,
              button_i      => rot_b_i,
              state_o       => rot_b,  -- 1 = butten is pressed
              released_o    => open,   -- 1 (for one clock cycle) = button has released
              pressed_o     => open    -- 1 (for one clock cycle) = button has pressed
             );
             
  turn_detect_i0: turn_detect
    generic map (
                 clk_time_out_g => 100000000 -- 1s
                )
    port map (
              clk_i        => clk_i,
              rst_n_i      => rst_n,
              rot_a_i      => rot_a,
              rot_b_i      => rot_b,
              dir_left_o   => dir_left,
              dir_right_o  => dir_right,
              still_o      => still,
              step_left_o  => step_left,
              step_right_o => step_right
             );
   
  led_o(0) <= dir_right;
  led_o(1) <= still;
  led_o(2) <= dir_left;
  led_o(3) <= rot_a;
  led_o(4) <= rot_b;
  
  stepper_ctrl : stepper_ctrl
      generic map(
            clk_per_phase_g  => 200000 	-- number of clock cycles for one phase of stepper
		)
      port map(
          clk_i        => clk_i,
          rst_n_i      => rst_n,
          
          step_left_i  => step_left,
          step_right_i => step_right,
          
          stepper_a_o  => stepper_a_o,
          stepper_b_o  => stepper_b_o
        );
  
end rtl;
