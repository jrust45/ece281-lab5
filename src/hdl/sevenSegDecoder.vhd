--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2018 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : top_basys3.vhd
--| AUTHOR(S)     : C3C John Rust III
--| CREATED       : 02/20/2024 Last modified 02/22/2024
--| DESCRIPTION   : This file implements the sevenSegDecoder that implements the combo logic 
--|					that controls the functionality of a seven-segment decoder for displaying 
--|					hex values on seven-segment displays (7SD) according to 4-bit inputs provided 
--|                 by switches on the basys3 board.
--|
--|					Inputs:  i_D (3:0)  --> 4-bit signal to deternmine 7SD value to be diplayed
--|
--|					Output:  o_S (6:0) --> 7-bit signal to activate the individual segments (active low)
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std
--|    Files     : sevenSegDecoder.vhd
--|
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sevenSegDecoder is
    Port ( i_D : in STD_LOGIC_VECTOR (3 downto 0);
           o_S : out STD_LOGIC_VECTOR (6 downto 0)
           );
end entity sevenSegDecoder;

architecture Behavioral of sevenSegDecoder is
    
    signal c_Sa : std_logic := '1';
    signal c_Sb : std_logic := '1';
    signal c_Sc : std_logic := '1';
    signal c_Sd : std_logic := '1';
    signal c_Se : std_logic := '1';
    signal c_Sf : std_logic := '1';
    signal c_Sg : std_logic := '1';
    
begin

c_Sa <= ( not i_D(3) and not i_D(2) and not i_D(1) and i_D(0) )
     or ( i_D(3) and not i_D(2) and i_D(1) and i_D(0) )
     or ( i_D(3) and i_D(2) and not i_D(1) )
     or ( i_D(2) and not i_D(1) and not i_D(0) );
 
c_Sb <= ( not i_D(3) and i_D(2) and not i_D(1) and i_D(0) )
     or ( i_D(3) and i_D(2) and not i_D(0) )
     or ( i_D(3) and i_D(1) and i_D(0) )
     or ( i_D(2) and i_D(1) and not i_D(0) );
     
c_Sc <= '1' when ( (i_D = x"2") or 
                   (i_D = x"C") or 
                   (i_D = x"E") or
                   (i_D = x"F") ) else '0';

c_Sd <= '1' when ( (i_D = x"1") or 
                   (i_D = x"4") or 
                   (i_D = x"7") or
                   (i_D = x"9") or 
                   (i_D = x"A") or
                   (i_D = x"F") ) else '0';
                   
c_Se <= '1' when ( (i_D = x"1") or 
                   (i_D = x"3") or 
                   (i_D = x"4") or
                   (i_D = x"5") or 
                   (i_D = x"7") or
                   (i_D = x"9") ) else '0';

c_Sf <= '1' when ( (i_D = x"1") or 
                   (i_D = x"2") or 
                   (i_D = x"3") or
                   (i_D = x"7") or 
                   (i_D = x"C") or
                   (i_D = x"D") ) else '0';

c_Sg <= '1' when ( (i_D = x"0") or 
                   (i_D = x"1") or 
                   (i_D = x"7") ) else '0';

    o_S(0) <= c_Sa;
    o_S(1) <= c_Sb;
    o_S(2) <= c_Sc;
    o_S(3) <= c_Sd;
    o_S(4) <= c_Se;
    o_S(5) <= c_Sf;
    o_S(6) <= c_Sg;
end Behavioral;
