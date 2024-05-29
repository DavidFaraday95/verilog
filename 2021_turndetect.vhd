----------------------------------------------------------------------------------
-- SVN information section start 
-- $URL: $ 
-- $Revision: $ 
-- $Author: $ 
-- $Date: $ 
-- SVN information section end ------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

library work;
use work.integer_fcn_light_pkg.all;

entity turn_detect is
  generic (
           clk_time_out_g : natural
          );
  port (
        clk_i           : in  std_logic;
        rst_n_i         : in  std_logic;  
        
        -- rotary switch
        rot_a_i         : in  std_logic;  
        rot_b_i         : in  std_logic;  

        dir_left_o      : out std_logic;
        dir_right_o     : out std_logic;
        still_o         : out std_logic;
        step_left_o     : out std_logic;
        step_right_o    : out std_logic
       );
end turn_detect;

architecture rtl of turn_detect is

  constant cnt_width_c    : natural := 27; -- >= unsigned_num_bits(clk_time_out_g)
                                           -- 1.0 sec = 100e6 cycles < 2^27 ~ 134e6
--  type state_t is(Rot_left,Rot_right,Reset);
  type state_t is(Rot_left,Rot_right,Reset);
  type reg_t is record 
  state         :  state_t;   
  dir_left      :  std_logic;
  dir_right     :  std_logic;
  still         :  std_logic;
  step_left     :  std_logic;
  step_right    :  std_logic;
  rot_a         :  std_logic;
  rot_b         :  std_logic;
  counter       :  integer;
--  sta_00        :  std_logic;
--  sta_10        :  std_logic;
--  sta_01        :  std_logic;
--  sta_11        :  std_logic;
  
  end record;
  constant dflt_reg_c : reg_t := (
    state           => Reset,
    dir_left      =>  '1',
    dir_right     =>  '1',
    still         =>  '1',
    step_left     =>  '0',
    step_right    =>  '0',
    rot_a         =>   '1',
    rot_b        =>   '1',
    counter      =>   0)
    ;    

  signal rin, r : reg_t := dflt_reg_c;
  
begin

  comb: process (r, rot_a_i, rot_b_i)
    variable v   : reg_t;
   
  begin
    v := r;
    
--                        if (v.rot_a = rot_a_i) and (v.rot_b = rot_b_i) then
--                            v.state := Reset;
--                        elsif (v.rot_a = rot_a_i) and (v.rot_a = '0') and (v.rot_b > rot_b_i)then
--                            v.state := Rot_left;
--                        elsif (v.rot_b = rot_b_i) and (v.rot_b = '1') and (v.rot_a /= rot_a_i)then
--                            v.state := Rot_left;
--                        elsif (v.rot_a = rot_a_i) and (v.rot_a = '1') and (v.rot_b /= rot_b_i)then
--                            v.state := Rot_left;
--                        elsif (v.rot_b = rot_b_i) and (v.rot_b = '0') and (v.rot_a /= rot_a_i)then
--                            v.state := Rot_left;
                            
--                        elsif (v.rot_b = rot_b_i) and (v.rot_b = '0') and (v.rot_a /= rot_a_i)then
--                            v.state := Rot_right; 
--                        elsif (v.rot_a = rot_a_i) and (v.rot_a = '1') and (v.rot_b /= rot_b_i)then
--                            v.state := Rot_right; 
--                        elsif (v.rot_b = rot_b_i) and (v.rot_b = '1') and (v.rot_a /= rot_a_i)then
--                            v.state := Rot_right;
--                        elsif (v.rot_a = rot_a_i) and (v.rot_a = '0') and (v.rot_b /= rot_b_i)then
--                            v.state := Rot_right;
--                        end if;    
                        
                        if (v.rot_a = rot_a_i) and (v.rot_b = rot_b_i) and (v.counter = 99999999) then
                            v.state := Reset;
                        elsif (v.rot_a = '0') and (rot_a_i = '0') and (v.rot_b = '0') and (rot_b_i = '1')then
                            v.state := Rot_right;
                            v.counter    :=  0;
                        elsif (v.rot_a = '0') and (rot_a_i = '1') and (v.rot_b = '1') and (rot_b_i = '1')then
                            v.state := Rot_right;
                            v.counter    :=  0;
                        elsif (v.rot_a = '1') and (rot_a_i = '1') and (v.rot_b = '1') and (rot_b_i = '0')then
                            v.state := Rot_right;
                            v.counter    :=  0;
                        elsif (v.rot_a = '1') and (rot_a_i = '0') and (v.rot_b = '0') and (rot_b_i = '0')then
                            v.state := Rot_right;
                            v.counter    :=  0;

                        elsif (v.rot_a = '0') and (rot_a_i = '1') and (v.rot_b = '0') and (rot_b_i = '0')then
                            v.state := Rot_left;
                            v.counter    :=  0;
                        elsif (v.rot_a = '1') and (rot_a_i = '1') and (v.rot_b = '0') and (rot_b_i = '1')then
                            v.state := Rot_left;
                            v.counter    :=  0;
                        elsif (v.rot_a = '1') and (rot_a_i = '0') and (v.rot_b = '1') and (rot_b_i = '1')then
                            v.state := Rot_left;
                            v.counter    :=  0;
                        elsif (v.rot_a = '0') and (rot_a_i = '0') and (v.rot_b = '1') and (rot_b_i = '0')then
                            v.state := Rot_left;
                            v.counter    :=  0;
                        end if;
                         
    v.rot_a      := rot_a_i;
    v.rot_b      := rot_b_i;
                        
    case v.state is
    when Reset => 
    
    v.dir_left   := '1';
    v.dir_right  := '1';
    v.still      := '1';
    v.step_left  := '0';
    v.step_right := '0';
    v.counter    :=  0;  
   
    when Rot_Left => 
                    v.dir_left   := '1';
                    v.dir_right  := '0';
                    v.still      := '0';
                    if (v.counter = 0) then
                    v.step_left  := '1';
                    v.step_right := '0';
                    else
                    v.step_left := '0';
                    end if;
                    v.counter := v.counter +1;
                    
   when Rot_Right =>
                    v.dir_left   := '0';
                    v.dir_right  := '1';
                    v.still      := '0';
                    if (v.counter = 0) then 
                    v.step_left  := '0';
                    v.step_right := '1';
                    else
                    v.step_right := '0';
                    end if;
                    v.counter := v.counter +1;
    end case;
    rin <= v;
    
    dir_left_o   <= r.dir_left; 
    dir_right_o  <= r.dir_right;
    still_o      <= r.still;
    step_left_o  <= r.step_left;
    step_right_o <= r.step_right;
  end process;

  reg: process (clk_i, rst_n_i)
  begin
    if rst_n_i = '0' then
      r <= dflt_reg_c;
    elsif rising_edge(clk_i) then
      r <= rin;
    end if;
  end process;

end rtl;
