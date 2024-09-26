library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity led_pattern_fsm is
	generic (
		system_clock_period : time := 20 ns
	);
	port (
		clk               : in  std_ulogic;                    -- System Clock
		rst               : in  std_ulogic;                    -- System reset (active high)
		push_button_pulse : in  std_ulogic;                    -- One-pulsed push button
		switches          : in  std_ulogic_vector(3 downto 0); -- Switches that determine next pattern
		pattern_gen       : in  std_ulogic_vector(7 downto 0); -- LED pattern from pattern generator
		led_pattern       : out std_ulogic_vector(7 downto 0); -- Current pattern
		pattern_sel       : out std_ulogic_vector(2 downto 0)  -- Select which pattern to display
	);
end entity;

architecture led_pattern_fsm_arch of led_pattern_fsm is
	
	type STATE is (S_PATTERN_0, S_PATTERN_1, S_PATTERN_2, S_PATTERN_3, S_PATTERN_4,
				   S_SHOW_SWITCHES);
	
	signal curr_state : STATE;
	
	signal count : natural := 0;
	
	constant ONE_SECOND_COUNT  : natural := 1000000000 ns / system_clock_period;
	
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
		
		-- Next state logic
		NEXT_STATE_LOGIC : process (clk, rst, curr_state, count, push_button_pulse) is
		begin
			if rst = '1' then
				curr_state <= S_PATTERN_0;
				count <= 0;
			elsif rising_edge(clk) then
				case (curr_state) is
				
					when S_SHOW_SWITCHES =>
						count <= count + 1;
						if (count >= ONE_SECOND_COUNT) then
							case (switches) is
								when "0000" => curr_state <= S_PATTERN_0;
								when "0001" => curr_state <= S_PATTERN_1;
								when "0010" => curr_state <= S_PATTERN_2;
								when "0011" => curr_state <= S_PATTERN_3;
								when "0100" => curr_state <= S_PATTERN_4;
								when others => curr_state <= S_PATTERN_0; -- Must be changed later!!
							end case;
						else
							curr_state <= S_SHOW_SWITCHES;
						end if;
						
					when others =>
						count <= 0;
						if push_button_pulse = '1' then
							curr_state <= S_SHOW_SWITCHES;
						else
							curr_state <= curr_state;
						end if;
						
				end case;
			end if;
		end process;
		
		-- Output logic
		OUTPUT_LOGIC : process (curr_state, pattern_gen, switches) is
		begin
			case (curr_state) is
				when S_PATTERN_0 =>
					pattern_sel <= "000";
					led_pattern <= pattern_gen;
				when S_PATTERN_1 =>
					pattern_sel <= "001";
					led_pattern <= pattern_gen;
				when S_PATTERN_2 =>
					pattern_sel <= "010";
					led_pattern <= pattern_gen;
				when S_PATTERN_3 =>
					pattern_sel <= "011";
					led_pattern <= pattern_gen;
				when S_PATTERN_4 =>
					pattern_sel <= "100";
					led_pattern <= pattern_gen;
					
				when S_SHOW_SWITCHES =>
					pattern_sel <= "111";
					led_pattern <= "0000" & switches;
			end case;
		end process;
		
end architecture;