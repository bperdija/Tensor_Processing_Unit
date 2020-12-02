LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.ALL;
--USE ieee.std_logic_unsigned.ALL;

ENTITY tb_MMU  IS
END tb_MMU;

ARCHITECTURE test of tb_MMU IS

COMPONENT MMU is
  PORT(clk, reset, hard_reset, ld, ld_w, stall  	  : IN STD_LOGIC;
       a0, a1, a2                                   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       w0, w1, w2                                   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
  	   y0, y1, y2 				                          : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END COMPONENT;

  CONSTANT HALF_PERIOD                                         : time := 10 ns;
  SIGNAL tb_clock                                              : std_logic := '0';
  SIGNAL tb_hard_reset, tb_reset, tb_ld, tb_ld_w, tb_stall     : std_logic;
  SIGNAL tb_a0, tb_a1, tb_a2, tb_y0, tb_y1, tb_y2              : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL tb_w0, tb_w1, tb_w2                                   : STD_LOGIC_VECTOR(7 DOWNTO 0);

  BEGIN

  DUT : MMU
  PORT MAP(clk => tb_clock, reset => tb_reset, hard_reset => tb_hard_reset, ld => tb_ld, ld_w => tb_ld_w, stall => tb_stall, a0 => tb_a0, a1 => tb_a1, a2 => tb_a2, w0 => tb_w0, w1 => tb_w1, w2 => tb_w2, y0 => tb_y0, y1 => tb_y1, y2 => tb_y2);

  tb_clock <= NOT tb_clock AFTER HALF_PERIOD;

  PROCESS
  BEGIN
    wait for 5 ns;

    tb_hard_reset <= '1';
    tb_reset <= '0';
    tb_stall <= '0';
    wait for 20 ns;

    tb_ld_w <= '1';
    tb_ld <= '0';
    tb_w0 <= "00000001";
    tb_w1 <= "00000011";
    tb_w2 <= "00000101";
    tb_a0 <= "00000000";
    tb_a1 <= "00000000";
    tb_a2 <= "00000000";
    wait for 20 ns;

    tb_ld_w <= '0';
    tb_ld <= '1';
    tb_w0 <= "00000000";
    tb_w1 <= "00000000";
    tb_w2 <= "00000000";
    tb_a0 <= "00000010";
    tb_a1 <= "00000000";
    tb_a2 <= "00000000";
    wait for 20 ns;

    tb_a0 <= "00000100";
    tb_a1 <= "00000110";
    tb_a2 <= "00000000";
    wait for 20 ns;

    tb_a0 <= "00000110";
    tb_a1 <= "00000010";
    tb_a2 <= "00000100";
    wait for 20 ns;

    tb_a0 <= "00000000";
    tb_a1 <= "00000100";
    tb_a2 <= "00000110";
    wait for 20 ns;

    tb_a0 <= "00000000";
    tb_a1 <= "00000000";
    tb_a2 <= "00000010";
    wait for 20 ns;


    -- all output now


    END PROCESS;
END test;
