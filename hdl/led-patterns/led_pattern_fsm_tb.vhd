library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_pattern_fsm_tb is
end entity;

architecture led_pattern_fsm_tb_arch of led_pattern_fsm_tb is
	
	constant CLK_PERIOD : time := 20 ns;
	
	signal clk_tb               : std_ulogic;
	signal rst_tb               : std_ulogic;
	signal push_button_pulse_tb : std_ulogic;
	signal switches_tb          : std_ulogic_vector(3 downto 0);
	signal pattern_gen_tb       : std_ulogic_vector(7 downto 0);
	signal led_pattern_tb       : std_ulogic_vector(7 downto 0);
	signal pattern_sel_tb       : std_ulogic_vector(2 downto 0);
	
	component led_pattern_fsm is
		generic (
			system_clock_period : time := 20 ns
		);
		port (
			clk               : in  std_ulogic;
			rst               : in  std_ulogic;
			push_button_pulse : in  std_ulogic;
			switches          : in  std_ulogic_vector(3 downto 0);
			pattern_gen       : in  std_ulogic_vector(7 downto 0);
			led_pattern       : out std_ulogic_vector(7 downto 0);
			pattern_sel       : out std_ulogic_vector(2 downto 0)
		);
	end component;
	
	begin
		
		DUT : led_pattern_fsm
			generic map (
				system_clock_period => CLK_PERIOD
			)
			port map (
				clk               => clk_tb,
				rst               => rst_tb,
				push_button_pulse => push_button_pulse_tb,
				switches          => switches_tb,
				pattern_gen       => pattern_gen_tb,
				led_pattern       => led_pattern_tb,
				pattern_sel       => pattern_sel_tb
			);
		
		-- Clock generation
		CLOCK_GEN : process is
		begin
			clk_tb <= '1'; wait for CLK_PERIOD / 2;
			clk_tb <= '0'; wait for CLK_PERIOD / 2;
		end process;
		
		-- DUT Stimulus
		STIMULUS : process is
		begin
			
			
			
			
		end process;
		
end architecture;