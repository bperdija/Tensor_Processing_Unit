
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;
USE work.systolic_package.all;

ENTITY tb_Tensor_Processing_Unit IS
END tb_Tensor_Processing_Unit;

ARCHITECTURE test of tb_Tensor_Processing_Unit IS

COMPONENT Tensor_Processing_Unit IS
PORT(clk, reset, hard_reset, setup, GO  : IN STD_LOGIC;
   stall                             : IN STD_LOGIC := '0';
   weights, a_in                     : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
   done 						                 : OUT STD_LOGIC;
   y0, y1, y2                        : OUT bus_width);
END COMPONENT;

CONSTANT HALF_PERIOD                                                 : time := 10 ns;
SIGNAL tb_clock                                                      : std_logic := '0';
SIGNAL tb_reset, tb_hard_reset, tb_setup, tb_GO, tb_stall, tb_done   : std_logic;
SIGNAL tb_weights, tb_a_in                                           : STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL tb_y0, tb_y1, tb_y2                                           : bus_width;

BEGIN

DUT : Tensor_Processing_Unit
PORT MAP(clk => tb_clock, reset => tb_reset, hard_reset => tb_hard_reset, setup => tb_setup, GO => tb_go, stall => tb_stall, weights => tb_weights, a_in => tb_a_in, y0 => tb_y0, y1 => tb_y1, y2 => tb_y2);

tb_clock <= NOT tb_clock AFTER HALF_PERIOD;

-- WRAM      URAM (write elements down)
-- 1 2 3     1 2 3
-- 4 5 6     4 5 6
-- 7 8 9     7 8 9

PROCESS
BEGIN

tb_hard_reset <= '1';
tb_reset <= '1';
tb_stall <= '0';
wait for 5 ns;

tb_setup <= '1';
tb_hard_reset <= '0';
tb_reset <= '0';
tb_weights <= "000000010000001000000011"; -- WRAM element 0
tb_a_in <= "000000010000010000000111"; -- URAM 0
wait for 20 ns;

tb_weights <= "000001000000010100000110"; -- WRAM element 1
tb_a_in <= "000000100000010100001000"; -- URAM 1
wait for 20 ns;

tb_weights <= "000001110000100000001001"; -- WRAM element 2
tb_a_in <= "000000110000011000001001"; -- URAM 2
wait for 20 ns;


END PROCESS;
end test;
