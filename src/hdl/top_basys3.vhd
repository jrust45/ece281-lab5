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
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

--lab 5
entity top_basys3 is
    port(
        --inputs
        clk     : in std_logic;
        sw      : in std_logic_vector(15 downto 0);
        btnU    : in std_logic;
        btnC    : in std_logic;
        btnL    : in std_logic;
        
        --outputs
        led     : out std_logic_vector(15 downto 0);
        seg     : out std_logic_vector(6 downto 0);
        an      : out std_logic_vector(3 downto 0)
    );
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	-- declare components and signals
	
	
	component controller_fsm is 
	   Port ( i_reset      : in std_logic;
	          i_adv        : in std_logic;
	          i_stable     : in std_logic;
	          o_cycle      : out std_logic_vector(3 downto 0)
	          );
    end component controller_fsm;
    
    component numRegister is
        port(
            --inputs
            i_D     : in std_logic_vector(7 downto 0);
            i_clk   : in std_logic;
            --outputs
            o_Q     : out std_logic_vector(7 downto 0)
        );
    end component numRegister;
    

    component ALU is 
        port( 
            i_A          : in std_logic_vector(7 downto 0);
            i_B          : in std_logic_vector(7 downto 0);
            i_op         : in std_logic_vector(2 downto 0);
            o_result     : out std_logic_vector(7 downto 0);
            o_flags      : out std_logic_vector(2 downto 0)
        );
    end component ALU;


    component twoscomp_decimal is
        port(
            i_binary: in std_logic_vector(7 downto 0);
            o_negative: out std_logic;
            o_hundreds: out std_logic_vector(3 downto 0);
            o_tens: out std_logic_vector(3 downto 0);
            o_ones: out std_logic_vector(3 downto 0)
        );
    end component twoscomp_decimal;
    
    
    component TDM4 is 
        generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
        
        port( 
            i_clk        : in  STD_LOGIC;
            i_reset        : in  STD_LOGIC; -- asynchronous
            i_D3         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
            i_D2         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
            i_D1         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
            i_D0         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
            o_data        : out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
            o_sel        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
        );
    end component TDM4;


    component clock_divider is 
        generic ( constant k_DIV : natural := 2 );
        
        port(
            i_clk   : in std_logic;
            i_reset : in std_logic;
            o_clk   : out std_logic
        );
    end component clock_divider;
    
    
    component sevenSegDecoder is 
        port( 
            i_D : in STD_LOGIC_VECTOR (3 downto 0);
            o_S : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component sevenSegDecoder;


signal w_A, w_B, w_result, w_bin : std_logic_vector(7 downto 0) := "00000000";
signal w_sign2, w_hund, w_tens, w_ones : std_logic_vector(3 downto 0); -- uncomment for task B and C
signal w_sign : std_logic := '0';
signal w_data, w_cycle : std_logic_vector(3 downto 0) := "0000";
signal w_clk : std_logic := '0';
signal w_sel : std_logic_vector(3 downto 0) := "0000";


    begin
	-- PORT MAPS ----------------------------------------


controller_inst : controller_fsm --instantiation of controller
     Port map ( 
            i_reset => btnU,
            i_adv => btnC,
            i_stable => btnL,
            o_cycle => w_cycle
            );

registerA_inst : numRegister
    Port map (
            i_D => sw(7 downto 0),
            i_clk => w_cycle(3),
            o_Q => w_A
            );  
            

registerB_inst : numRegister
    Port map (
            i_D => sw(7 downto 0),
            i_clk => w_cycle(2),
            o_Q => w_B
            );  


AUL_inst : ALU --instantiation of the ALU
     Port map ( 
            i_A => w_A,
            i_B => w_B,
            i_op => sw(15 downto 13),
            o_result => w_result,
            o_flags => led(15 downto 13)
            );


twoscomp_inst : twoscomp_decimal
    Port map (
            i_binary => w_bin,
            o_negative => w_sign,
            o_hundreds => w_hund,
            o_tens => w_tens,
            o_ones => w_ones
            );
            
       
TDM4_inst : TDM4
    Port map (
            i_clk => w_clk, --still needs to be finished in advanced version of elevator
            i_reset => btnU,
            i_D3 => w_sign2,  --need to be updated once task B and C are implemented
            i_D2 => w_hund,
            i_D1 => w_tens,
            i_D0 => w_ones,
            o_data => w_data,
            o_sel => w_sel
            );
                    
                         
clkdiv_inst : clock_divider  		--instantiation of clock_divider
    Generic map ( k_DIV => 100000 ) -- 1 Hz clock from 100 MHz
    Port map (                          
            i_clk   => clk,
            i_reset => btnU,
            o_clk   => w_clk
            );
            
            
sevSeg_inst : sevenSegDecoder --instantiation of seven Seg
    Port map ( 
            i_D => w_data,
            o_S => seg
            );
	
	
	-- CONCURRENT STATEMENTS ----------------------------

--display MUX
w_bin <= w_A when (w_cycle(1 downto 0) = "00") else
         w_result when (w_cycle(1 downto 0) = "01") else
         w_B when (w_cycle(1 downto 0) = "10") else
         "00000000";

w_sign2 <= "1111" when (w_sign = '1') else
           "0000";
           
--grounding un-used LEDs
led(12 downto 4) <= (others => '0');

--wiring active-low 7SD anodes
--an(0) <= '0';
--an(1) <= '0';
--an(2) <= not w_sel(3) or not w_sel(1);
--an(3) <= not w_sel(2) or not w_sel(0);

led(0) <= w_cycle(3); 
led(1) <= w_cycle(2); 
led(2) <= w_cycle(0) and not w_cycle(1);
led(3) <= w_cycle(0) and w_cycle(1);

an(0) <= w_sel(0); --not w_sel(2) or not w_sel(0);
an(1) <= w_sel(1); --not w_sel(2) or not w_sel(0);
an(2) <= w_sel(2);
an(3) <= w_sel(3);

end top_basys3_arch;
