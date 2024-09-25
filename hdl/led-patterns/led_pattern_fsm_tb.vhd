library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_pattern_fsm_tb is
end entity;

architecture led_pattern_fsm_tb_arch of led_pattern_fsm_tb is
	
	signal clk               : std_ulogic;
	signal rst               : std_ulogic;
	signal push_button_pulse : std_ulogic;
	signal switches          : std_ulogic_vector(3 downto 0);
	signal base_period       : unsigned(7 downto 0);
	signal led_pattern       : std_ulogic_vector(7 downto 0)
	
	component led_pattern_fsm is
		generic (
			system_clock_period : time := 20 ns
		);
		port (
			clk               : in  std_ulogic;
			rst               : in  std_ulogic;
			push_button_pulse : in  std_ulogic;
			switches          : in  std_ulogic_vector(3 downto 0);
			base_period       : in  unsigned(7 downto 0);
			led_pattern       : out std_ulogic_vector(7 downto 0)
		);
	end component;
	
	begin
		
		DUT : led_pattern_fsm
			port map (
				clk => clk_tb,
				rst => rst_tb,
				push_button_pulse_tb,
				switches => switches_tb,
				base_period => base_period_tb,
				led_pattern => led_pattern_tb,
			);
		
		STIMULUS : process is
		begin
			
			
			
		end process;
		
end architecture;