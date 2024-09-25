library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity _fsm is
	port (
		clk in  std_ulogic;
		rst in  std_ulogic;
		
	);
end entity;

architecture _fsm_arch of _pattern_fsm is
	
	type STATE is ();
	
	signal curr_state : STATE;
	
	begin
		
		-- Next state logic
		NEXT_STATE_LOGIC : process (clk, rst, curr_state) is
		begin
			if rst = '1' then
				
			elsif rising_edge(clk) then
				
				case (curr_state) then
					
				end case;
			end if;
		end process;
		
		-- Output logic
		OUTPUT_LOGIC : process (curr_state) is
		begin
			case (curr_state) is
					
			end case;
		end process;
		
end architecture;