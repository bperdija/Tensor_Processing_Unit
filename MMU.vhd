LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;
USE work.systolic_package.all;

ENTITY MMU IS
PORT(clk, reset, hard reset, ld, ld_wall, stall  	: IN STD_LOGIC;
     a0, a1, a2, w0, w1, w2                       : IN STD_LOGIC_VECTOR(2 DOWNTTO 0);
	   yo, y1, y2 				                          : OUT STD_LOGIC_VECTOR(2 DOWNTTO 0);
END MMU;

ARCHITECTURE behaviour OF MMU IS
SIGNAL
	COMPONENT processing_element IS
  PORT();
	END COMPONENT;

BEGIN

END behaviour;
