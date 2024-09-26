library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_pattern_generator_tb is
end entity;

architecture led_pattern_generator_tb_arch of led_pattern_generator_tb is
	
	constant CLK_PERIOD     : time := 1 ms;                       -- Slow period for better viewing of waveform
	constant BASE_PERIOD_TB : unsigned(7 downto 0) := "00000001"; -- 62.5 ms (fastest base period)
	
	signal clk_tb         : std_ulogic;
	signal rst_tb         : std_ulogic;
	signal pattern_sel_tb : std_ulogic_vector(2 downto 0);
	signal pattern_gen_tb : std_ulogic_vector(7 downto 0);
	
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
				pattern_gen => pattern_gen_tb
			);
		
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
			pattern_sel_tb <= "000";
			rst_tb <= '0'; wait for CLK_PERIOD;
			rst_tb <= '1'; wait for CLK_PERIOD * 2;
			rst_tb <= '0'; wait for CLK_PERIOD * 5;
			
			wait for 5000 ms;
			
			std.env.finish;
			
		end process;
		
end architecture;