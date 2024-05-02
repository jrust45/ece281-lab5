----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2024 12:36:01 PM
-- Design Name: 
-- Module Name: controller_fsm_tb - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller_fsm_tb is
end controller_fsm_tb;

architecture test_bench of controller_fsm_tb is

    component controller_fsm is 
	   Port ( i_reset      : in std_logic;
	          i_adv        : in std_logic;
	          o_cycle      : out std_logic_vector(3 downto 0)
	          );
    end component controller_fsm;
    
    signal w_reset, w_adv : std_logic := '0';
    signal w_cycle : std_logic_vector(3 downto 0) := "0000";
    
    constant k_clk_period : time := 10 ns;
    
begin

    uut : controller_fsm port map(
        i_reset => w_reset,
        i_adv => w_adv,
        o_cycle => w_cycle
    );
       
sim_proc: process
        begin
        
        w_adv <= '0'; w_reset <= '0';
        wait for k_clk_period*1;
            assert o_cycle = "11" report "bad start" severity failure;
        
        w_adv <= '1';
        wait for k_clk_period*1;
            assert o_cycle = "00" report "bad advance to state 00" severity failure;
        
        w_adv <= '0';
        wait for k_clk_period*1;
            assert o_cycle = "00" report "bad hold on state 00" severity failure;
           
       w_adv <= '1';
       wait for k_clk_period*1;
       
           --sequential timing
           w_reset <= '1';
           wait for k_clk_period*1;
               assert w_L_lights = "000" report "bad reset" severity failure;
               assert w_R_lights = "000" report "bad reset" severity failure;
               
           w_reset <= '0';
           wait for k_clk_period*1;
           
           --all on
           w_left <= '1'; w_right <= '1'; wait for k_clk_period;
               assert w_L_lights = "111" report "bad all on" severity failure;
               assert w_R_lights = "111" report "bad all on" severity failure;
           
wait;
end process;
 

end test_bench;
