LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;
USE work.systolic_package.all;

ENTITY Activation_Unit IS
PORT(clk,reset, hard_reset, stall, done  	 : IN STD_LOGIC;
     y_in0, y_in1, y_in2                   : IN UNSIGNED(7 DOWNTO 0);
     row0, row1, row2                      : OUT UNSIGNED(7 DOWNTO 0)); -- is this others okay??
END Activation_Unit;


ARCHITECTURE behaviour OF Activation_Unit IS

TYPE state_type is (idle, state_0, state_1, state_2, state_3, state_4, state_5);
SIGNAL next_state, current_state : state_type;
SIGNAL s_counter : INTEGER := 0;  -- sets counter to zero
SIGNAL y11, y12, y13, y21, y22, y23, y31, y32, y33 : UNSIGNED(7 DOWNTO 0) := (others => '0');

BEGIN
  PROCESS(stall, hard_reset, reset) -- possibly need s_counter in the process
  BEGIN
    IF (hard_reset = '1' OR reset = '1') THEN
        s_counter <= (others => '0');
        done <= '0';
        y11 <= '0';
        y12 <= '0';
        y13 <= '0';
        y21 <= '0';
        y22 <= '0';
        y23 <= '0';
        y31 <= '0';
        y32 <= '0';
        y33 <= '0';
        row0 <= (others => '0');
        row1 <= (others => '0');
        row2 <= (others => '0');
        next_state <= idle;

    ELSIF (stall = '1') THEN
        next_state <= current_state;

    ELSE
      CASE current_state IS
  	      WHEN state_0 =>
            done <= '0';
  					s_counter <= s_counter + '1';
  			 		IF (s_counter = 2) then
  						next_state <= state_1;
  					ELSE
  						next_state <= state_0;
  					END IF;

  	      WHEN state_1 =>
            y11 <= y_in0;
  					next_state <= state_2;

  	      WHEN state_2 =>
            y12 <= y_in0;
            y21 <= y_in1;
  					next_state <= state_3;

  	      WHEN state_3 =>
            y13 <= y_in0;
            y22 <= y_in1;
            y31 <= y_in2;
  					next_state <= state_4;

  	     WHEN state_4 =>
           y23 <= y_in1;
           y32 <= y_in2;
  				next_state <= state_5;

  	      WHEN state_5 =>
            y33 <= y_in2;
            done <= '1';
  					next_state <= state_6;
			  END CASE;
      END IF;

		 IF (done = '1') THEN
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

    END PROCESS;

    PROCESS(clk)
    BEGIN
      IF (Rising_Edge(clk)) THEN
        current_state <= next_state;
      END IF;
    END PROCESS;
END behaviour;
