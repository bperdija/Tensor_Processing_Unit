LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;
USE work.systolic_package.all;

ENTITY MMU IS
PORT(clk, reset, hard_reset, ld, ld_w, stall  	  : IN STD_LOGIC;
     a0, a1, a2                                   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
     w0, w1, w2                                   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	   y0, y1, y2 				                          : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END MMU;

ARCHITECTURE behaviour OF MMU IS

COMPONENT processing_element IS
		PORT(clk, reset, hard_reset, ld, ld_w     : IN STD_LOGIC;
		     w_in, a_in, part_in                  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         partial_sum                          : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				 a_out                                : OUT STD_LOGIC);
END COMPONENT;

--TYPE state_type is (idle, load_col0, load_col1, load_col2);
--SIGNAL next_state, current_state: state_type;
SIGNAL 1_to_2, 2_to_3, 4_to_5, 5_to_6, 7_to_8, 8_to_9, 1_to_4, 2_to_5, 3_to_6, 4_to_7, 5_to_8, 6_to_9: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
-- init mode, ld_w will (?) stay asserted the whole time, when ld_w not asserted do we just stay at same state or do we keep going? init starts when ld_W what if ld_w asserted when in middle of compute
-- Both resets can interrupt init
-- If ld_w is not asserted during the init, then the process will stall
-- Init mode executes, setup will initiate init mode, and ____ will initiate the go mode
-- Layout:  1   2   3
--          4   5   6
--          7   8   9

-- connect all of the PEs
  Obj1: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w0, a_in => a0, part_in => "00000000", partial_sum => 1_to_4, a_out => 1_to_2);

  Obj2: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w0, a_in => 1_to_2, part_in => "00000000", partial_sum => 2_to_5, a_out => 2_to_3);

  Obj3: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w0, a_in => 2_to_3, part_in => "00000000", partial_sum => 3_to_6, a_out => open);

  Obj4: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w1, a_in => a1, part_in => 1_to_4, partial_sum => 4_to_7, a_out => 4_to_5);

  Obj5: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w1, a_in => 4_to_5, part_in => 2_to_5, partial_sum => 5_to_8, a_out => 5_to_6);

  Obj6: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w1, a_in => 5_to_6, part_in => 3_to_6, partial_sum => 6_to_9, a_out => open);

  Obj7: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w2, a_in => a2, part_in => 4_to_7, partial_sum => y0, a_out => 7_to_8);

  Obj8: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w2, a_in => 7_to_8, part_in => 5_to_8, partial_sum => y1, a_out => 8_to_9;

  Obj9: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w2, a_in => 8_to_9, part_in => 6_to_9, partial_sum => y2, a_out => open);

  -- PROCESS(current_state, hard_reset, ld_w)
  -- BEGIN
  --   IF (hard_reset = '1') THEN
  --     gg: for i in 1 to 9 generate
  --       Obji: processing_element PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => 0, a_in => 0, part_in => 0);
  --     end generate gg;
  --
  --     next_state <= idle;
  --
  -- ELSE
  --     CASE current_state IS
  --       WHEN idle =>
  --         IF (ld_w = '1') THEN
  --           next_state <= load_col0;
  --         ELSE
  --           next_state <= idle;
  --         END IF;
  --
  --       WHEN load_col0 =>
  --       IF (ld_w = '1') THEN
  --           Obj1: processing_element
  --           PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w0, a_in => 0, part_in => 0);
  --
  --           Obj4: processing_element
  --           PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w1, a_in => 0, part_in => 0);
  --
  --           Obj7: processing_element
  --           PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w2, a_in => 0, part_in => 0);
  --
  --           next_state <= load_col1;
  --         ELSE
  --           next_state <= load_col0;
  --         END IF;
  --
  --         WHEN load_col1 =>
  --           IF (ld_w = '1') THEN
  --             Obj2: processing_element
  --             PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w0, a_in => 0, part_in => 0);
  --
  --             Obj5: processing_element
  --             PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w1, a_in => 0, part_in => 0);
  --
  --             Obj8: processing_element
  --             PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w2, a_in => 0, part_in => 0);
  --
  --             next_state <= load_col2;
  --           ELSE
  --             next_state <= load_col1;
  --           END IF;
  --
  --           WHEN load_col2 =>
  --             IF (ld_w = '1') THEN
  --               Obj3: processing_element
  --               PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w0, a_in => 0, part_in => 0);
  --
  --               Obj6: processing_element
  --               PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w1, a_in => 0, part_in => 0);
  --
  --               Obj9: processing_element
  --               PORT MAP (clk => clk, reset => reset, hard_reset => hard_reset, ld => ld, ld_w => ld_w, w_in => w2, a_in => 0, part_in => 0);
  --
  --               next_state <= idle;
  --             ELSE
  --               next_state <= load_col2;
  --             END IF;
  --       END CASE;
  --     END IF;
  --   END PROCESS;
END behaviour;
