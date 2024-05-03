--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
--|
--| ALU OPCODES:
--|
--|     ADD     000
--|
--|
--|
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library IEEE; 
  use IEEE.numeric_std.ALL;
 
entity ALU is
-- TODO
    port( 
        --inputs
        i_A          : in std_logic_vector(7 downto 0);
        i_B          : in std_logic_vector(7 downto 0);
        i_op         : in std_logic_vector(2 downto 0);
        --outputs
        o_result     : out std_logic_vector(7 downto 0);
        o_flags      : out std_logic_vector(2 downto 0)
    );
end ALU;
 
architecture behavioral of ALU is 

 
 
signal w_result : std_logic_vector(7 downto 0);
signal w_add : std_logic_vector(7 downto 0);
signal w_sub : std_logic_vector(7 downto 0);
signal w_lsft : std_logic_vector(7 downto 0);
signal w_rsft : std_logic_vector(7 downto 0);
signal w_and : std_logic_vector(7 downto 0);
signal w_or : std_logic_vector(7 downto 0);
 
  
begin
	-- PORT MAPS ----------------------------------------
 
 
	-- CONCURRENT STATEMENTS ----------------------------
	w_add <= std_logic_vector(unsigned(i_A) + unsigned(i_B));
	w_sub <= std_logic_vector(unsigned(i_A) - unsigned(i_B));
	w_or <= i_A or i_B;
	w_and <= i_A and i_B;
	w_lsft <= std_logic_vector(shift_left(unsigned(i_A), to_integer(unsigned(i_B(2 downto 0)))));
	w_rsft <= std_logic_vector(shift_right(unsigned(i_A), to_integer(unsigned(i_B(2 downto 0)))));
	w_result <= w_add when (i_op = "000") else
	            w_sub when (i_op = "100") else
	            w_lsft when (i_op = "011") else
	            w_rsft when (i_op = "111") else
	            w_or when (i_op = "001") else
	            w_and when (i_op = "010") else
	            "00000000";
	o_result <= w_result;
	o_flags(0) <= (i_A(7) xor w_result(7)) or (i_B(7) xor w_result(7)); --cOut flag
	o_flags(1) <= '1' when (w_result = "00000000") else '0'; --zero flag
	o_flags(2) <= w_result(7); --cpu sign flag

end behavioral;
