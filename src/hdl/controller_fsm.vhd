----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2024 05:42:58 PM
-- Design Name: 
-- Module Name: controller_fsm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller_fsm is
    Port ( i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture Behavioral of controller_fsm is
    
    --created registers signals wit default state to off
    signal f_Q : std_logic_vector(1 downto 0) := "11";
    signal f_Q_next : std_logic_vector(1 downto 0) := "11";
    
begin

    --CONCURRENT STATEMENTS-----
    --next state logic----------
                --when progressing to next state (button was pressed)
    f_Q_next <= "00" when (i_adv = '1' and f_Q = "11") else
                "01" when (i_adv = '1' and f_Q = "00") else
                "10" when (i_adv = '1' and f_Q = "01") else
                "11" when (i_adv = '1' and f_Q = "10") else
                
                --when staying on current state (no button pressed)    
                "00" when (i_adv = '0' and f_Q = "00") else
                "01" when (i_adv = '0' and f_Q = "01") else
                "10" when (i_adv = '0' and f_Q = "10") else
                "11"; -- when (i_adv = '1' and f_Q = "11") else
    
    
    o_cycle <= "1000" when (f_Q = "00") else
               "0110" when (f_Q = "01") else
               "0001" when (f_Q = "10") else
               "0011"; --when (f_Q = "11");
    
    
    -- PROCESS --------------
    -- State memory ---------
    
register_proc : process (i_reset, i_adv)
begin
    --asynchronous reset
    
    if i_reset = '1' then 
        f_Q <= "11";
    elsif i_adv = '1' then
        f_Q <= f_Q_next;
    end if;
    
end process register_proc;
    
end Behavioral;
