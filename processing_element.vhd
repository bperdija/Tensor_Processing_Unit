LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.systolic_package.all;

Entity processing_element is
		PORT(clk, reset, hard_reset, ld, ld_w     : IN STD_LOGIC;
		     w_in, a_in, part_in                  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         partial_sum                          : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				 a_out                                : OUT STD_LOGIC);
END processing_element;

ARCHITECTURE Behaviour of processing_element is
	signal W_To_MAC, MAC_inside, MAC_to_Y : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    -- A register


END Behaviour;
