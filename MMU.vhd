LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;
USE work.systolic_package.all;

ENTITY MMU IS
PORT(clk, reset, hard reset, ld, ld_wall, stall  	: IN STD_LOGIC;
     a0, a1, a2, w0, w1, w2                       : IN STD_LOGIC_VECTOR(2 DOWNTTO 0);
	   yo, y1, y2 				                          : OUT STD_LOGIC_VECTOR(2 DOWNTTO 0);
END MMU;

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
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

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
ARCHITECTURE behaviour OF MMU IS
SIGNAL
	COMPONENT processing_element IS
  PORT();
	END COMPONENT;

BEGIN

END behaviour;
