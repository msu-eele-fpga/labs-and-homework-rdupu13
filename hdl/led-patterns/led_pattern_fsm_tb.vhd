library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_pattern_fsm_tb is
end entity;

architecture led_pattern_fsm_tb_arch of led_pattern_fsm_tb is
	
	constant CLK_PERIOD : time := 20 ms; -- Slower clock speed for better waveform view
	
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
		
		-- Test pattern generation
		TEST_PATTERN_GEN : process is
		begin
			case (pattern_sel_tb) is
				when "000" =>
					pattern_gen_tb <= "00001000"; wait for CLK_PERIOD * 3;
					pattern_gen_tb <= "10000100"; wait for CLK_PERIOD * 3;
				when "001" =>
					pattern_gen_tb <= "00001100"; wait for CLK_PERIOD * 3;
					pattern_gen_tb <= "10011000"; wait for CLK_PERIOD * 3;
				when "010" =>
					pattern_gen_tb <= "00000000"; wait for CLK_PERIOD * 3;
					pattern_gen_tb <= "10000001"; wait for CLK_PERIOD * 3;
					pattern_gen_tb <= "00000010"; wait for CLK_PERIOD * 3;
					pattern_gen_tb <= "10000011"; wait for CLK_PERIOD * 3;
				when "011" =>
					pattern_gen_tb <= "00000000"; wait for CLK_PERIOD * 3;
					pattern_gen_tb <= "11111111"; wait for CLK_PERIOD * 3;
					pattern_gen_tb <= "01111110"; wait for CLK_PERIOD * 3;
					pattern_gen_tb <= "11111101"; wait for CLK_PERIOD * 3;
				when "100" =>
					pattern_gen_tb <= "00001000"; wait for CLK_PERIOD * 3;
					pattern_gen_tb <= "11110111"; wait for CLK_PERIOD * 3;
				when others =>
					pattern_gen_tb <= "00000000"; wait for CLK_PERIOD * 3;
			end case;
		end process;
		
		-- DUT Stimulus
		STIMULUS : process is
		begin
			
			-- Reset
			push_button_pulse_tb <= '0';
			switches_tb <= "0000";
			rst_tb <= '0'; wait for CLK_PERIOD;
			rst_tb <= '1'; wait for CLK_PERIOD * 3;
			rst_tb <= '0';
			
			wait for CLK_PERIOD * 25;
			
			-- Switch set and button press
			switches_tb <= "0011"; wait for CLK_PERIOD * 5;
			push_button_pulse_tb <= '1'; wait for CLK_PERIOD;
			push_button_pulse_tb <= '0';
			
			wait for 1.7 sec;
			
			-- Switch set and button press
			switches_tb <= "0001"; wait for CLK_PERIOD * 5;
			push_button_pulse_tb <= '1'; wait for CLK_PERIOD;
			push_button_pulse_tb <= '0';
			
			wait for 2.3 sec;
			
			-- Switch set and button press
			switches_tb <= "0100"; wait for CLK_PERIOD * 5;
			push_button_pulse_tb <= '1'; wait for CLK_PERIOD;
			push_button_pulse_tb <= '0';
			
			wait for 1.9 sec;
			
			-- Switch set and button press
			switches_tb <= "0010"; wait for CLK_PERIOD * 5;
			push_button_pulse_tb <= '1'; wait for CLK_PERIOD;
			push_button_pulse_tb <= '0';
			
			wait for 1.5 sec;
			
			std.env.finish;
			
		end process;
		
end architecture;