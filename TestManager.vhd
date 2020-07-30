-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  use work.Build_Array.all;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
          COMPONENT manager
          PORT(
			 
   clk_Manage_slow:in std_logic;
	clk_Manage_fast :in std_logic;
	txd_manage : out std_logic;
	data :in Myarray;
	check: out std_logic;--for test
	enable_send : in std_logic;--if '1' data start to ssend
	done_send_each : out std_logic;--when one byte send ,done is '1'
	done_send_all: out std_logic--when all data send ,done is '1'

                  );
          END COMPONENT;
	
	
	
	--signal input
signal	clk_Manage_slow : std_logic := '0';
signal	clk_Manage_fast: std_logic := '0';
signal	data : Myarray := ("00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000");
signal	enable_send :  std_logic := '0';--if '1' data start to ssend
	--signal output
signal	txd_manage :  std_logic := '0';
signal   check:  std_logic := '0';
signal	done_send_each :  std_logic := '0';--when one byte send ,done is '1'
signal	done_send_all:  std_logic := '0';--when all data send ,done is '1'
	
	 -- Clock period definitions
   constant clk_period_slow : time := 80 ns;
	constant clk_period_fast : time := 10 ns;
          

  BEGIN

  -- Instantiate the Unit Under Test (UUT)
				uut: manager PORT MAP (
				clk_Manage_slow =>clk_Manage_slow,
				clk_Manage_fast=>clk_Manage_fast,
				txd_manage =>txd_manage,
				data =>data,
				check => check ,
				enable_send =>enable_send,--if '1' data start to ssend
				done_send_each =>done_send_each,--when one byte send ,done is '1'
				done_send_all =>done_send_all --when all data send ,done is '1'
        );




	enable_send  <= '1' after 100 ns, '0' after 1000 ns ;
	data  <= ("00000000","00000000","00000000","00000000","00000000","00000000","00000000","11111111") after 50 ns ;
	
   -- Clock slow process definitions
   clk_Manage_slow_process :process
   begin
		clk_Manage_slow <= '0';
		wait for clk_period_slow/2;
		clk_Manage_slow <= '1';
		wait for clk_period_slow/2;
   end process;
	 
 

   -- Stimulus process
   stim_proc_slow: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period_slow*10;

      -- insert stimulus here 

      wait;
   end process;
	
	
	-- Clock fast  process definitions
   clk_Manage_fast_process :process
   begin
		clk_Manage_fast <= '0';
		wait for clk_period_fast/2;
		clk_Manage_fast <= '1';
		wait for clk_period_fast/2;
		end process;
		
		 -- Stimulus process
   stim_proc_fast: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period_fast*10;

      -- insert stimulus here 

      wait;
   end process;
	
  
	
	
	
	
  END;
