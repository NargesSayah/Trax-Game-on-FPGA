	library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_signed.all;
	--use ieee.std_logic_unsigned.all;
	--use work.Build_Array.all;


	--entity
	entity manager is port(
		clk_manager :in std_logic;
		--clk_manager_baud :in std_logic;
		txd_manage : out std_logic;
		check: out std_logic;--for test
	--	data :in Myarray;
		--data_to_rs : inout std_logic_vector (7 downto 0);
		enable_send : in std_logic;--if '1' data start to ssend
		done_send_each : out std_logic;--when one byte send ,done is '1'
		done_send_all: out std_logic--when all data send ,done is '1'
	);
	end manager;


	--architecture
	architecture struct of manager is 
	
	--type data
			Type Myarray is array (7 downto 0) of std_logic_vector(7 downto 0);
			signal	data : Myarray := ("00000000","11111111","00001000","00000000","11111111","00000000","00000000","11111111");
	
	--define states
		TYPE STATE_TYPE IS (s0,s1,s2,s3,s4);
		SIGNAL state : STATE_TYPE := s0;

	--rs component
		
		component rs is port(

		clk :in std_logic ;
		done :out std_logic ; 
		enable :in std_logic ;
		data: in std_logic_vector (7 downto 0);
		txd : out std_logic 


		);
		end component;

	--end rs component

	--Baud clock component
		component BaudTickGen is port (clk,enable : in std_logic ;tick :out std_logic );
		end component ;
	--end Baud clock component
	--signal ha
			signal temp_clk:std_logic;	
			signal sig_counter_manager_byte :integer := 0;
			signal sig_counter_manager_byte_temp :integer := 0;
			signal data_to_rs :std_logic_vector (7 downto 0);
		
			

	begin--architecture begin
			
		   
		   
			--rs port mapping
			--sig_counter_manager_byte_temp <= sig_counter_manager_byte_temp;
			check <= '1';
			
			BaudClk : BaudTickGen port map(clk_manager,'1',temp_clk);
			transmit_manage: rs port map(clk_manager,done_send_each,enable_send,data_to_rs,txd_manage);

			--end rs port mapping
			--portmap buad
			
			--end portmap buad
		  
			handler: process (clk_manager)
			variable counter_manager_byte :integer  := 0 ;--count num of byte of input that send
			variable counter_manager_byte_temp :integer  := 0 ;--count num of byte of input that send
			
		begin -- process begin 
		
		counter_manager_byte_temp := counter_manager_byte;
		sig_counter_manager_byte <= counter_manager_byte_temp;
		
		
		 if (rising_edge (clk_manager))then
		--	done_send_all <= '1';
				CASE state IS
				
				
				
				WHEN s0 =>
				 
				--check <= '0';
					IF (enable_send='1')THEN
			
					
					--done_send_all <= '1';
					--	check <= '1';
					   state <= s2;
						--check <= '0'
				
			  END IF;
			  
			  --when s1 =>
			 -- state <= s2;
			  
			  
			WHEN s2 =>
			  			--done_send_all <= '0';
							  
					if (counter_manager_byte <8) then
												--	check <= '1';
													data_to_rs <= data(counter_manager_byte);
													counter_manager_byte := counter_manager_byte + 1;
												-- done_send_all <='1';
												end if;
													if (counter_manager_byte >=8) then 
												 -- check <= '1';
												  counter_manager_byte := 0;
												  --done_send_each<='0';
												  done_send_all <= '1';
												  state <= s3;
												END IF;
					--	end if;
			  
			  
			  
			  
--			when s4 =>
--						data_to_rs <= data(counter_manager_byte+1);
--						counter_manager_byte := 0;
--						done_send_all <= '1';
--			state <= s3;
--						  
			  
			  
			  
			  
			WHEN s3 =>
			  IF (enable_send = '0') THEN
				 done_send_all <= '0';
				 state <= s1;
			
			  END IF;
			
			WHEN OTHERS =>
			  state <= s0;
		 end case;
		 end if;
	  
		end process ;

		
	end architecture;

