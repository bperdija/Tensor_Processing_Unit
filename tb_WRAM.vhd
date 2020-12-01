LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY tb_WRAM  IS
END tb_WRAM;

ARCHITECTURE test of tb_WRAM IS

COMPONENT WRAM is
  PORT(aclr		  : IN STD_LOGIC  := '0';
		  address		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		  clock		  : IN STD_LOGIC  := '1';
		  data		  : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
		  rden		  : IN STD_LOGIC  := '1';
		  wren		  : IN STD_LOGIC;
		  q	       	: OUT STD_LOGIC_VECTOR (23 DOWNTO 0));
END COMPONENT;

  CONSTANT HALF_PERIOD              : time := 10 ns;
  SIGNAL tb_clock                   : std_logic := '0';
  SIGNAL tb_aclr, tb_rden, tb_wren  : std_logic;
  SIGNAL tb_data, tb_q              : STD_LOGIC_VECTOR(23 DOWNTO 0);
  SIGNAL tb_address                 : STD_LOGIC_VECTOR(1 DOWNTO 0);

  BEGIN
  DUT : WRAM
  PORT MAP(aclr => tb_aclr, address => tb_address, clock => tb_clock, data => tb_data, rden => tb_rden, wren => tb_wren, q => tb_q);

  tb_clock <= NOT tb_clock AFTER HALF_PERIOD;

  PROCESS
  BEGIN

  -- READ FROM SRAM AND WRITE VALUES TO SRAM
    wait for 5 ns;

    tb_aclr <= '0';
    tb_address <= "00";
    tb_data <= "000000000000000000000001";
    tb_rden <= '0';
    tb_wren <= '1';
    wait for 100 ns;

   tb_address <= "00";
    tb_data <= "000000000000000000000001";
   tb_rden <= '1';
    tb_wren <= '0';
    wait for 40 ns;

    tb_address <= "01";
    tb_data <= "000000000000000000000100";
    tb_rden <= '0';
    tb_wren <= '1';
    wait for 20 ns;

   tb_address <= "01";
   tb_rden <= '1';
    tb_wren <= '0';
    wait for 40 ns;

   tb_address <= "00";
   tb_rden <= '1';
    tb_wren <= '0';
    wait for 40 ns;

  END PROCESS;
END test;
