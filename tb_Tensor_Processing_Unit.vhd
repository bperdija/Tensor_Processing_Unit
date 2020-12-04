LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;
--USE work.systolic_package.all;

COMPONENT Tensor_Processing_Unit IS
PORT(clk,reset, hard_reset, setup, GO  : IN STD_LOGIC;
     stall                             : IN STD_LOGIC := '0';
     weights, a_in                     : IN UNSIGNED(23 DOWNTO 0);
	   done 						                 : OUT STD_LOGIC;
     y0, y1, y2                        : OUT bus_width);
END COMPONENT;
