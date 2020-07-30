				library ieee;
				use ieee.std_logic_1164.all;
				use ieee.numeric_std.all;

				entity rs is port(
				--clk_slow :in std_logic ;
				clk :in std_logic ;
				done :out std_logic ;
				enable :in std_logic ;
				data: in std_logic_vector (7 downto 0);
				txd : out std_logic 
				);
				end rs;



				architecture struct of rs is
				  TYPE STATE_TYPE IS (s0, s1, s2,s3,s4);
					SIGNAL state : STATE_TYPE := s0;
					signal sig_counter_get,sig_counter_send,sig_row,sig_col : integer := -1;
					type RAM_Buffer is array (7 downto 0) of STD_LOGIC_VECTOR (7 downto 0);
					signal ram: RAM_Buffer := (others=> (others=> 'U'));
					
					component BaudTickGen is port (clk,enable : in std_logic ;tick :out std_logic );
					end component ;
					
					signal temp_clk:std_logic;	
					
					
					--taarif signal
					
				--	signal data:std_logic_vector (7 downto 0) := "01000001";	-- A
					--tamam
						



				  begin
				  --baudtick for fast clock is needed !! 
				--  L0 : BaudTickGen port map(clk,'1',temp_clk);
				  transmiter: process (clk)
				  
					variable counter_get :integer := 0;
					variable col :integer := 0;
					variable row :integer := 0;
					variable counter_send:integer := 0;
					
					
					
					
					
					
				  begin  
				  if (rising_edge (clk))then -- temp_clk bood
						
						CASE state IS
						WHEN s0 =>
						  txd <= '1';
						  state <= s1;
						  
						
						WHEN s1 =>
						  IF (enable='1')THEN
							 txd <= '0';
							 state <= s2;
						  END IF;
						  
						  
						WHEN s2 =>
					--	if (rising_edge (clk)) then
							sig_counter_get <= counter_get;
						  IF (counter_get < 8 ) then 
						  ram(counter_get)(0)<=data(0);
						  ram(counter_get)(1)<=data(1);
						  ram(counter_get)(2)<=data(2);
						  ram(counter_get)(3)<=data(3);
						  ram(counter_get)(4)<=data(4);
						  ram(counter_get)(5)<=data(5);
						  ram(counter_get)(6)<=data(6);
						  ram(counter_get)(7)<=data(7);
						  
						 
						  counter_get := counter_get + 1;
						  
						  end if ;
						  IF (counter_get >= 8 ) then 
						  --txd <= '1';
						  counter_get := 0;
						  --done <= '1';
						  state <= s3;
						  END If;
						-- end if;
						 
						 when s3 =>
						 
						 if(counter_send <64) then
						 
						 if (col >= 8) then
						 col := 0;
						 row := row +1 ;
						 end if;
						 
						 
						 txd <= ram (row)(col);
						-- sig_col <= col ;
						 col := col + 1;
						 --sig_row <= row;
						 sig_counter_send <= counter_send;
						 counter_send := counter_send+1;
						 else
						 done <= '1';
						 state <= s4;
						 
						 
						 
					    end if;
						  
						WHEN s4 =>
						  IF enable = '0' THEN
							 done <= '0';
							 state <= s0;
						
						  END IF;
						
						WHEN OTHERS =>
						  state <= s0;
					 end case;
					 end if;
				  end process;








				end ;
