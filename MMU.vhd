LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;

ENTITY MMU IS
PORT(clk, reset, hard_reset, ld, ld_w, stall  	  : IN STD_LOGIC := '0';
     a0, a1, a2                                   : IN UNSIGNED(7 DOWNTO 0) := (others => '0');
     w0, w1, w2                                   : IN UNSIGNED(7 DOWNTO 0) := (others => '0');
	   y0, y1, y2 				                          : OUT UNSIGNED(7 DOWNTO 0) := (others => '0');
     collect_matrix                               : OUT STD_LOGIC := '0');
END MMU;

ARCHITECTURE behaviour OF MMU IS

COMPONENT processing_element IS
		PORT(clk, reset, hard_reset, ld, ld_w     : IN STD_LOGIC;
		     w_in, a_in, part_in                  : IN UNSIGNED(7 DOWNTO 0);
         partial_sum, a_out                   : OUT UNSIGNED(7 DOWNTO 0));
END COMPONENT;

TYPE state_type is (idle, load_col0, load_col1, load_col2);
SIGNAL next_state, current_state: state_type;
SIGNAL sig_1_to_2, sig_2_to_3, sig_4_to_5, sig_5_to_6, sig_7_to_8, sig_8_to_9, sig_1_to_4, sig_2_to_5, sig_3_to_6, sig_4_to_7, sig_5_to_8, sig_6_to_9: UNSIGNED(7 DOWNTO 0) := (others => '0');
SIGNAL ld_col0, ld_col1, ld_col2, sig_ld : STD_LOGIC;
SIGNAL ld_counter : INTEGER := 0;
BEGIN

-- assuming ld and ld_w wil never be asserted at the same time
 PROCESS(current_state, ld_w, ld, stall)
 BEGIN

   IF (ld = '1') THEN -- COMPUTE mode
       sig_ld <= '1';

       IF (stall = '1') THEN
          sig_ld <= '0';
      END IF;

       ld_col0 <= '0';
       ld_col1 <= '0';
       ld_col2 <= '0';

   ELSIF (ld_w = '1') THEN -- INIT mode
     sig_ld <= '0';

     CASE current_state IS
       -- exit the idle mode
       WHEN idle =>
         ld_col0 <= '1';
         ld_col1 <= '0';
         ld_col2 <= '0';
         next_state <= load_col0;

       WHEN load_col0 =>
         ld_col0 <= '0';
         ld_col1 <= '1';
         ld_col2 <= '0';
         next_state <= load_col1;

       WHEN load_col1 =>
         ld_col0 <= '0';
         ld_col1 <= '0';
         ld_col2 <= '1';
         next_state <= load_col2;

       -- Set all control and weight buffers to 0 for the next cycle once the FSM returns to Idle.
       WHEN load_col2 =>
         ld_col0 <= '0';
         ld_col1 <= '0';
         ld_col2 <= '0';
         next_state <= idle;
       END CASE;

    ELSE
      ld_col0 <= '0';
      ld_col1 <= '0';
      ld_col2 <= '0';
      next_state <= current_state;

    END IF;
   END PROCESS;

   PROCESS(clk, hard_reset, reset)
   BEGIN
     IF (hard_reset = '1' OR reset = '1') THEN
         current_state <= idle;
         ld_counter <= 0;

     ELSIF (Rising_Edge(clk)) THEN
       current_state <= next_state;

       IF (sig_ld = '1') then -- if ld asserted increment counter to keep track of clocks
         ld_counter <= ld_counter + 1;
      END IF;

      -- if counter reached first state where there is output assert signal to collect matrix, turn off when reached last state with output
      IF (ld_counter < 2 OR ld_counter > 6) THEN
        collect_matrix <= '0';
      else
        collect_matrix <= '1';
      END IF;

     END IF;
   END PROCESS;

    -- Take the row from W and spit it out as a column in the MMU
    -- port map all of the PEs together

    -- Col1
    Obj1: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => sig_ld, ld_w => ld_col0, w_in => w0, a_in => a0, part_in => "00000000", partial_sum => sig_1_to_4, a_out => sig_1_to_2);
    Obj4: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => sig_ld, ld_w => ld_col0, w_in => w1, a_in => a1, part_in => sig_1_to_4, partial_sum => sig_4_to_7, a_out => sig_4_to_5);
    Obj7: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => sig_ld, ld_w => ld_col0, w_in => w2, a_in => a2, part_in => sig_4_to_7, partial_sum => y0, a_out => sig_7_to_8);

    -- Col2
    Obj2: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => sig_ld, ld_w => ld_col1, w_in => w0, a_in => sig_1_to_2, part_in => "00000000", partial_sum => sig_2_to_5, a_out => sig_2_to_3);
    Obj5: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => sig_ld, ld_w => ld_col1, w_in => w1, a_in => sig_4_to_5, part_in => sig_2_to_5, partial_sum => sig_5_to_8, a_out => sig_5_to_6);
    Obj8: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => sig_ld, ld_w => ld_col1, w_in => w2, a_in => sig_7_to_8, part_in => sig_5_to_8, partial_sum => y1, a_out => sig_8_to_9);

    -- Col3
    Obj3: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => sig_ld, ld_w => ld_col2, w_in => w0, a_in => sig_2_to_3, part_in => "00000000", partial_sum => sig_3_to_6, a_out => open);
    Obj6: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => sig_ld, ld_w => ld_col2, w_in => w1, a_in => sig_5_to_6, part_in => sig_3_to_6, partial_sum => sig_6_to_9, a_out => open);
    Obj9: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => sig_ld, ld_w => ld_col2, w_in => w2, a_in => sig_8_to_9, part_in => sig_6_to_9, partial_sum => y2, a_out => open);

END behaviour;
