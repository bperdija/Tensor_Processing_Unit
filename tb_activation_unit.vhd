LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.ALL;
USE work.systolic_package.all;

ENTITY tb_Activation_Unit IS
END tb_Activation_Unit;

ARCHITECTURE test of tb_Activation_Unit IS

COMPONENT Activation_Unit IS
PORT(clk,reset, hard_reset, GO_store_matrix  : IN STD_LOGIC := '0';
     stall                                   : IN STD_LOGIC := '0';
     y_in0, y_in1, y_in2                     : IN UNSIGNED(7 DOWNTO 0) := (others => '0');
	   done 						                       : OUT STD_LOGIC := '0';
     row0, row1, row2                        : OUT bus_width);
END COMPONENT;

  CONSTANT HALF_PERIOD                                                    : time := 10 ns;
  SIGNAL tb_clock                                                         : std_logic := '0';
  SIGNAL tb_reset, tb_hard_reset, tb_stall, tb_done, tb_GO_store_matrix   : std_logic;
  SIGNAL tb_y_in0, tb_y_in1, tb_y_in2                                     : UNSIGNED(7 DOWNTO 0);
  SIGNAL tb_row0, tb_row1, tb_row2                                        : bus_width;

  BEGIN

  DUT : Activation_Unit
  PORT MAP(clk => tb_clock, reset => tb_reset, hard_reset => tb_hard_reset, stall => tb_stall, GO_store_matrix => tb_GO_store_matrix, y_in0 => tb_y_in0, y_in1 => tb_y_in1, y_in2 => tb_y_in2, done => tb_done, row0 => tb_row0, row1 => tb_row1, row2 => tb_row2);

  tb_clock <= NOT tb_clock AFTER HALF_PERIOD;

  PROCESS
  BEGIN

    tb_reset <= '1';
    tb_hard_reset <= '1';
    tb_stall <= '0';
    tb_GO_store_matrix <= '0';
    tb_y_in0 <= "00000000";
    tb_y_in1 <= "00000000";
    tb_y_in2 <= "00000000";
    wait for 5 ns;

    -- wait to simulate time when MMU isn't producing valid output
    tb_reset <= '0';
    tb_hard_reset <= '0';
    wait for 20 ns;

    -- collect in staggered matrix product values
	  tb_GO_store_matrix <= '1';
    tb_y_in0 <= "00000001";
    tb_y_in1 <= "00000000";
    tb_y_in2 <= "00000000";
    wait for 20 ns;

    tb_y_in0 <= "00000010";
    tb_y_in1 <= "00000100";
    tb_y_in2 <= "00000000";
    wait for 20 ns;

    tb_y_in0 <= "00000011";
    tb_y_in1 <= "00000101";
    tb_y_in2 <= "00000111";
    wait for 20 ns;

    -- test stall operation
    tb_stall <= '1';
    tb_y_in0 <= "00000011";
    tb_y_in1 <= "00000101";
    tb_y_in2 <= "00000111";
    wait for 20 ns;

    tb_stall <= '0';
    tb_y_in0 <= "00000000";
    tb_y_in1 <= "00000110";
    tb_y_in2 <= "00001000";
    wait for 20 ns;

    tb_y_in0 <= "00000000";
    tb_y_in1 <= "00000000";
    tb_y_in2 <= "00001001";
    wait for 60 ns;

  END Process;
END test;
