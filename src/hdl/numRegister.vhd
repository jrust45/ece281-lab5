----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2024 05:44:51 PM
-- Design Name: 
-- Module Name: numRegister - Behavioral
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

entity numRegister is
    Port ( i_D : in STD_LOGIC_VECTOR (7 downto 0);
           i_clk : in STD_LOGIC;
           o_Q : out STD_LOGIC_VECTOR (7 downto 0));
end numRegister;

architecture Behavioral of numRegister is

    --created registers signals wit default state to off   
    signal f_Q : std_logic := '0';     
    signal f_Q_next : std_logic := '0'; 

begin

    --CONCURRENT STATEMENTS-----
    --next state logic----------
    
    f_Q_next <= '1' when (i_clk = '1' and f_Q = '0') else 
                '0'; -- when (i_clk = '1' and f_Q = '1');  --this low key might be wrong for future Jack
    
    o_Q <= i_D when (f_Q = '1') else
           "00000000"; --default out case
           
           
    -- PROCESS --------------
    -- State memory ---------
               
register_proc : process (i_clk)
begin
    --asynchronous reset
    
    if (i_clk = '1') then
        f_Q <= f_Q_next;
    else
        f_Q <= f_Q;     --also low key might be wrong future Jack
    end if;
   
end process register_proc;
 
end Behavioral;
