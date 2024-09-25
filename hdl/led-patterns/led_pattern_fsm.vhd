library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_pattern_fsm is
	generic (
		system_clock_period : time := 20 ns
	);
	port (
		clk               : in  std_ulogic;                    -- System clock
		rst               : in  std_ulogic;                    -- System reset (active high)
		push_button_pulse : in  std_ulogic;                    -- Push button to change patterns (conditioned by async_conditioner)
		switches          : in  std_ulogic_vector(3 downto 0); -- Switches that determine next pattern
		led_pattern       : out std_ulogic_vector(7 downto 0)  -- Current LED pattern, displayed if hps_led_control = 0
	);
end entity;

architecture led_pattern_fsm_arch of led_pattern_fsm is
	
	type STATE is ();
	
	signal curr_state : STATE;
	
	begin
	
		-- State 0 (reset): one shifting right   at 1/2
		-- State 1: two shifting left            at 1/4
		-- State 2: 7 bit up-counter             at 2
		-- State 3: 7 bit down-counter           at 1/8
		-- State 4: Base rate in binary rotating at 1/4
		
		-- Button transition
			-- led = switches for 1 sec
			-- curr_state = switches if switches < 5
			-- curr_state = curr_state otherwise >= 5
		
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