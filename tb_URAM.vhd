LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

--testbench entities are always empty
ENTITY tb_processing_element  IS
END tb_processing_element;

ARCHITECTURE behaviour of tb_processing_element IS

COMPONENT URAM is
  PORT(aclr		  : IN STD_LOGIC  := '0';
		  address		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		  clock		  : IN STD_LOGIC  := '1';
		  data		  : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		  rden		  : IN STD_LOGIC  := '1';
		  wren		  : IN STD_LOGIC ;
		  q	       	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END COMPONENT;

  CONSTANT HALF_PERIOD : time := 10 ns;
  SIGNAL tb_clock      : std_logic := '0';
  SIGNAL tb_reset, tb_hard_reset, tb_ld, tb_ld_w  : std_logic;
  SIGNAL tb_w_in, tb_a_in, tb_part_in, tb_partial_sum, tb_a_out : UNSIGNED(7 DOWNTO 0);

  BEGIN
  DUT : processing_element
  PORT MAP(clk => tb_clock, reset => tb_reset, hard_reset => tb_hard_reset, ld => tb_ld, ld_w => tb_ld_w, w_in => tb_w_in, a_in => tb_a_in, part_in => tb_part_in, partial_sum => tb_partial_sum, a_out => tb_a_out);

  tb_clock <= NOT tb_clock AFTER HALF_PERIOD;

  PROCESS
  BEGIN
    wait for 5 ns;




  END PROCESS;
END behaviour;
