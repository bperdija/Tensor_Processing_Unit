LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY tb_processing_element  IS
END tb_processing_element;

ARCHITECTURE behaviour of tb_processing_element IS

COMPONENT processing_element is
	PORT(clk, reset, hard_reset, ld, ld_w     : IN STD_LOGIC := '0';
			 w_in, a_in, part_in                  : IN UNSIGNED(7 DOWNTO 0) := (others => '0');
			 partial_sum,  a_out                  : OUT UNSIGNED(7 DOWNTO 0) := (others => '0'));
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

		-- everything should be 0
		tb_hard_reset <= '1';
		tb_reset <= '0';
    wait for 5 ns;

    -- partial_sum should be 0
    tb_hard_reset <= '0';
    tb_ld_w <= '1';
    tb_ld <= '0';
    tb_a_in <= "00000000";
    tb_w_in <= "00000010";
    tb_part_in <= "00000000";
    wait for 20 ns;

    -- partial_sum should be 00001100
    tb_ld <= '1';
    tb_a_in <= "00000001";
    tb_w_in <= "00000010";
    tb_part_in <= "00001010";
    wait for 20 ns;

    -- partial_sum should be 00001010
    tb_a_in <= "00000000";
    tb_w_in <= "00000010";
    tb_part_in <= "00001010";
    wait for 20 ns;

    -- partial_sum should be 11111111
    tb_a_in <= "11111111";
    tb_w_in <= "00000010";
    tb_part_in <= "00001010";
    wait for 20 ns;

    -- partial_sum should be 11111111
    tb_a_in <= "11111110";
    tb_w_in <= "00000001";
    tb_part_in <= "00001010";
    wait for 20 ns;

    -- everything but W register will be 0, testing soft reset
    tb_reset <= '1';
    tb_a_in <= "00000010"; -- 0
    tb_w_in <= "00000010"; -- should stay at 2
    tb_part_in <= "00001010";
    wait for 20 ns;

    -- partial_sum should be 00000110
    tb_reset <= '0';
    tb_ld_w <= '0';
    tb_a_in <= "00000010";
    tb_w_in <= "00000001"; -- should stay at 2
    tb_part_in <= "00000010";
    wait for 20 ns;

    -- partial_sum should be 00000100, testing load
    tb_ld_w <= '1';
    tb_ld <= '0';
    tb_a_in <= "00000001"; -- should stay at 2
    tb_w_in <= "00000001";
    tb_part_in <= "00000001";
    wait for 20 ns;

    -- partial_sum should be 00000000
    tb_hard_reset <= '1';
    tb_ld <= '1';
    tb_a_in <= "00000001";
    tb_w_in <= "00000011";
    tb_part_in <= "00000010";
    wait for 20 ns;

  END PROCESS;
END behaviour;
