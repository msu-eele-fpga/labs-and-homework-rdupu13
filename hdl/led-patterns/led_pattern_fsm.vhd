library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_pattern_fsm is
	port (
		clk               : in  std_ulogic;                    -- System clock
		rst               : in  std_ulogic;                    -- System reset (active high)
		push_button_pulse : in  std_ulogic;                    -- Push button (conditioned by async_conditioner)
		switches          : in  std_ulogic_vector(3 downto 0); -- Switches that determines next state
		base_period       : in  unsigned(7 downto 0);          -- 
		led_pattern       : out std_ulogic_vector(7 downto 0)  -- Current LED pattern, displayed if hps_led_control = 0
	);
end entity;

architecture led_pattern_fsm_arch of led_pattern_fsm is
	
	type STATE is ();
	
	signal curr_state : STATE;
	
	begin
		
		NEXT_STATE_LOGIC : process (clk, rst, curr_state, push_button_pulse) is
		begin
			if rst = '1' then
				curr_state <= 
			elsif rising_edge(clk) then
				case (curr_state) then
					
						
				end case;
			end if;
		end process;
		
		OUTPUT_LOGIC : process (curr_state) is
		begin
			case (curr_state) is
				
			end case;
		end process;
		
end architecture;