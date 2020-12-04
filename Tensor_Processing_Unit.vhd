LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;
--USE work.systolic_package.all;

ENTITY Tensor_Processing_Unit IS
PORT(clk,reset, hard_reset, setup, GO  : IN STD_LOGIC;
     stall                             : IN STD_LOGIC := '0';
     weights, a_in                     : IN UNSIGNED(23 DOWNTO 0);
	   done 						                 : OUT STD_LOGIC;
     y0, y1, y2                        : OUT bus_width);
END Tensor_Processing_Unit;

-- Will we always reset?
ARCHITECTURE behaviour OF Tensor_Processing_Unit IS

COMPONENT WRAM IS
  PORT( aclr		: IN STD_LOGIC  := '0';
        address	: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        clock		: IN STD_LOGIC  := '1';
        data		: IN STD_LOGIC_VECTOR (23 DOWNTO 0);
        rden		: IN STD_LOGIC  := '1';
        wren		: IN STD_LOGIC;
        q		    : OUT STD_LOGIC_VECTOR (23 DOWNTO 0));
END COMPONENT;

COMPONENT URAM IS
	PORT(aclr		 : IN STD_LOGIC  := '0';
  		 address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
  		 clock	 : IN STD_LOGIC  := '1';
  		 data		 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
  		 rden		 : IN STD_LOGIC  := '1';
  		 wren		 : IN STD_LOGIC ;
  		 q		   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END COMPONENT;

COMPONENT MMU IS
PORT(clk, reset, hard_reset, ld, ld_w, stall  	  : IN STD_LOGIC;
     a0, a1, a2                                   : IN UNSIGNED(7 DOWNTO 0);
     w0, w1, w2                                   : IN UNSIGNED(7 DOWNTO 0);
	   y0, y1, y2 				                          : OUT UNSIGNED(7 DOWNTO 0);
     collect_matrix                               : OUT STD_LOGIC);
END COMPONENT;

COMPONENT Activation_Unit IS
PORT(clk,reset, hard_reset, GO_store_matrix  : IN STD_LOGIC;
     stall                  : IN STD_LOGIC := '0';
     y_in0, y_in1, y_in2    : IN UNSIGNED(7 DOWNTO 0);
	   done 						      : OUT STD_LOGIC;
     row0, row1, row2       : OUT bus_width);
END COMPONENT;

TYPE state_type is (idle, load_row0, load_row1, load_row2);
SIGNAL next_state, current_state: state_type;
SIGNAL ld_row0, ld_row1, ld_row2 : STD_LOGIC;
SIGNAL W_out : STD_LOGIC_VECTOR (23 DOWNTO 0);
SIGNAL element_address : UNSIGNED(1 DOWNTO 0);
--SIGNAL element_address_URAM : UNSIGNED(1 DOWNTO 0);
SIGNAL a0, a1, a2 : UNSIGNED(7 DOWNTO 0);
SIGNAL a_in0, a_in1, a_in2 : UNSIGNED(7 DOWNTO 0);

BEGIN

  -- setup mode
  PROCESS(current_state, hard_reset, reset, stall, setup, GO)
  BEGIN
    IF (hard_reset = '1' OR reset = '1') THEN
        next_state <= idle;

    ELSIF (GO = '1') THEN -- assuming setup is off / setup and go are never the same

    ELSE -- setup = 1 (and GO "happens to be" 0, Laura Flood circa 2020)
      CASE current_state IS
        WHEN idle =>
          element_address <= "00"; -- used for WRAM row and URAM
          next_state <= load_row0;

        WHEN load_row0 =>
          element_address <= "01";
          next_state <= load_row1;

        WHEN load_row1 =>
          element_address <= "10";
          next_state <= load_row2;

        -- Set all control and weight buffers to 0 for the next cycle once the FSM returns to Idle.
        WHEN load_row2 =>
          element_address <= "11"; -- ?????????????????????????
          next_state <= idle;
        END CASE;
      END IF;
    END PROCESS;

    URAM_reset <= hard_reset OR reset;
    a_in0 <= a_in(23 DOWNTO 16);
    a_in1 <= a_in(15 DOWNTO 8);
    a_in2 <= a_in(7 DOWNTO 0);

    WRAM1 : PORT MAP WRAM(aclr => hard_reset, address => element_address, clock => clk, data => weights, rden => GO, wren => setup, q => W_out);

    URAM1 : PORT MAP URAM(aclr => URAM_reset, address => element_address, clock => clk, data => a_in0, rden => GO, wren => setup, q => a0);
    URAM2 : PORT MAP URAM(aclr => URAM_reset, address => element_address, clock => clk, data => a_in1, rden => GO, wren => setup, q => a1);
    URAM3 : PORT MAP URAM(aclr => URAM_reset, address => element_address, clock => clk, data => a_in2, rden => GO, wren => setup, q => a2);


END behaviour;
