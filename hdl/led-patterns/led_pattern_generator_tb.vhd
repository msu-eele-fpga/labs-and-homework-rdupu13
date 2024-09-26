library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_pattern_generator_tb is
end entity;

architecture led_pattern_generator_tb_arch of led_pattern_generator_tb is
	
	constant CLK_PERIOD     : time := 1 ms;                       -- Slow period for better viewing of waveform
	constant BASE_PERIOD_TB : unsigned(7 downto 0) := "00000001"; -- 62.5 ms (fastest base period)
	
	signal clk_tb              : std_ulogic;
	signal rst_tb              : std_ulogic;
	signal pattern_sel_tb      : std_ulogic_vector(2 downto 0);
	signal full_pattern_gen_tb : std_ulogic_vector(6 downto 0);
	signal pattern_gen_tb      : std_ulogic_vector(6 downto 0);
	
	signal prev_pattern : std_ulogic_vector(6 downto 0);
	
	component led_pattern_generator is
		generic (
			system_clock_period : time := 20 ns
		);
		port (
			clk         : in  std_ulogic;
			rst         : in  std_ulogic;
			base_period : in  unsigned(7 downto 0);
			pattern_sel : in  std_ulogic_vector(2 downto 0);
			pattern_gen : out std_ulogic_vector(7 downto 0)
		);
	end component;
	
	begin
		
		DUT : led_pattern_generator
			generic map (
				system_clock_period => CLK_PERIOD
			)
			port map (
				clk         => clk_tb,
				rst         => rst_tb,
				base_period => BASE_PERIOD_TB,
				pattern_sel => pattern_sel_tb,
				pattern_gen => full_pattern_gen_tb
			);
			
		pattern_gen_tb <= full_pattern_gen_tb(6 downto 0);
		
		-- Clock generation
		CLOCK_GEN : process is
		begin
			clk_tb <= '1'; wait for CLK_PERIOD / 2;
			clk_tb <= '0'; wait for CLK_PERIOD / 2;
		end process;
		
		-- DUT stimulus
		STIMULUS : process is
		begin
			
			-- Reset
			rst_tb <= '0'; wait for CLK_PERIOD;
			rst_tb <= '1'; wait for CLK_PERIOD * 2;
			rst_tb <= '0'; wait for CLK_PERIOD * 5;
			
			pattern_sel_tb <= "000"; wait for 5000 ms;
			pattern_sel_tb <= "001"; wait for 5000 ms;
			pattern_sel_tb <= "010"; wait for 5000 ms;
			pattern_sel_tb <= "011"; wait for 5000 ms;
			pattern_sel_tb <= "100"; wait for 5000 ms;
			pattern_sel_tb <= "101"; wait for 5000 ms;
			pattern_sel_tb <= "110"; wait for 5000 ms;
			pattern_sel_tb <= "111"; wait for 5000 ms;
			
			std.env.finish;
			
		end process;
		
		OUTPUT_CHECKER : process (rst_tb, pattern_gen_tb, pattern_sel_tb) is
		begin
			
			if rst_tb = '1' then
				-- Test 
				assert pattern_gen_tb = "0000000"
					report "Error on reset: pattern_gen should be 0000000."
					severity warning;
			else
				-- Test patterns
				case (pattern_sel_tb) is
					when "000" =>
						if pattern_gen_tb /= std_ulogic_vector(rotate_right(unsigned(prev_pattern), 1)) then
							report "Error in pattern 0: pattern_gen should've been rotated right, but wasn't."
							severity warning;
						end if;
					when "001" =>
						if pattern_gen_tb /= std_ulogic_vector(rotate_left(unsigned(prev_pattern), 1)) then
							report "Error in pattern 1: pattern_gen should've been rotated left, but wasn't."
							severity warning;
						end if;
					when "010" =>
						if pattern_gen_tb /= std_ulogic_vector(unsigned(prev_pattern) + to_unsigned(1, 7)) then
							report "Error in pattern 2: pattern_gen should've been incremented, but wasn't."
							severity warning;
						end if;
					when "011" =>
						if pattern_gen_tb /= std_ulogic_vector(unsigned(prev_pattern) - to_unsigned(1, 7)) then
							report "Error in pattern 3: pattern_gen should've been decremented, but wasn't."
							severity warning;
						end if;
					when "100" =>
						if pattern_gen_tb /= not prev_pattern then
							report "Error in pattern 4: pattern_gen should've been inverted, but wasn't."
							severity warning;
						end if;
					when others =>
						if pattern_gen_tb /= "0000000" then
							report "Error: pattern_gen should be 00000000 when pattern_sel > 100."
							severity warning;
						end if;
				end case;
				
				-- Save current pattern for next use as previous
				prev_pattern <= pattern_gen_tb;
			end if;
			
		end process;
		
end architecture;