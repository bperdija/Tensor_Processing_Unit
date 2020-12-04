LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;
USE work.systolic_package.all;

ENTITY Activation_Unit IS
PORT(clk,reset, hard_reset, GO_store_matrix  : IN STD_LOGIC;
     stall                                   : IN STD_LOGIC := '0';
     y_in0, y_in1, y_in2                     : IN UNSIGNED(7 DOWNTO 0);
	   done 						                       : OUT STD_LOGIC;
     row0, row1, row2                        : OUT bus_width);
END Activation_Unit;

-- Will we always reset?
ARCHITECTURE behaviour OF Activation_Unit IS

TYPE state_type is (state_0, state_1, state_2, state_3, state_4, state_5);
SIGNAL next_state : state_type;
SIGNAL y11, y12, y13, y21, y22, y23, y31, y32, y33 : UNSIGNED(7 DOWNTO 0) := (others => '0');
SIGNAL sig_done : STD_LOGIC;

BEGIN
  PROCESS(reset, hard_reset, clk)
  BEGIN

    IF (reset = '1' OR hard_reset = '1') then
      next_state <= state_0;

    ELSIF (GO_store_matrix = '1') THEN
      IF (stall = '1') then
          next_state <= next_state;

      ELSIF (Rising_Edge(clk)) THEN
        CASE next_state IS
          WHEN state_0 =>
            next_state <= state_1;

          WHEN state_1 =>
            next_state <= state_2;

          WHEN state_2 =>
            next_state <= state_3;

          WHEN state_3 =>
              next_state <= state_4;

          WHEN state_4 =>
              next_state <= state_5;

          WHEN state_5 =>
            next_state <= state_0;
        END CASE;
      END IF;

    ELSE
      next_state <= state_0;
    END IF;
  END PROCESS;

  PROCESS(next_state) --inputs would also go here
  BEGIN
    CASE next_state IS
    -- WHEN state0_0 OR state0_1
      WHEN state_0  =>
        IF (sig_done = '1') THEN
          row0(0) <= y11;
          row0(1) <= y12;
          row0(2) <= y13;
          row1(0) <= y21;
          row1(1) <= y22;
          row1(2) <= y23;
          row2(0) <= y31;
          row2(1) <= y32;
          row2(2) <= y33;
        END IF;

        sig_done <= '0';

      WHEN state_1 =>
        sig_done <= '0';
        y11 <= y_in0;

      WHEN state_2 =>
        sig_done <= '0';
        y12 <= y_in0;
        y21 <= y_in1;

      WHEN state_3 =>
        sig_done <= '0';
        y13 <= y_in0;
        y22 <= y_in1;
        y31 <= y_in2;

      WHEN state_4 =>
        sig_done <= '0';
        y23 <= y_in1;
        y32 <= y_in2;

      WHEN state_5 =>
        sig_done <= '1';
        y33 <= y_in2;

    END CASE;

    done <= sig_done;

  END PROCESS;
END behaviour;
