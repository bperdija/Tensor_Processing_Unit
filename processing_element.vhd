LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--USE work.systolic_package.all;

Entity processing_element is
		PORT(clk, reset, hard_reset, ld, ld_w     : IN STD_LOGIC;
		     w_in, a_in, part_in                  : IN UNSIGNED(7 DOWNTO 0);
         partial_sum,  a_out                  : OUT UNSIGNED(7 DOWNTO 0));
END processing_element;

ARCHITECTURE Behaviour of processing_element is
	SIGNAL W_To_MAC, MAC_to_Y, A_Dtmp, Y_Dtmp : UNSIGNED(7 DOWNTO 0);
  SIGNAL MAC_inside, Add_To_Round : UNSIGNED(15 DOWNTO 0);
BEGIN
    -- A register behaviour
    A_Dtmp <= (others => '0') WHEN (reset = '1' OR hard_reset = '1') ELSE
              a_in WHEN (ld = '1' AND Rising_Edge(clk)) ELSE
              A_Dtmp;
   a_out <= A_Dtmp;

   -- W register behaviour
   W_To_MAC <= (others => '0') WHEN hard_reset = '1' ELSE
                w_in WHEN (ld_W = '1' AND Rising_Edge(clk)) ELSE
                W_To_MAC;

  -- MAC behaviour
  MAC_inside <= a_in * W_To_MAC;
  Add_To_Round <= MAC_inside + part_in;
  MAC_To_Y <= (others => '1') WHEN (Add_To_Round > 255) else
              Add_To_Round(7 DOWNTO 0);

  -- Y register behaviour
  Y_Dtmp <= (others => '0') WHEN (reset = '1' OR hard_reset = '1') ELSE
            MAC_to_Y WHEN (ld = '1' AND Rising_Edge(clk)) ELSE
            Y_Dtmp;
  partial_sum <= Y_Dtmp;

END Behaviour;
