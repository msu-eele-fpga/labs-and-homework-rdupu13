library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_controller_tb is
end entity;

architecture pwm_controller_tb_arch of pwm_controller_tb is
	
	signal clk_tb        : std_logic;
	signal rst_tb        : std_logic;
	signal period_tb     : unsigned(W_PERIOD - 1 downto 0);
	signal duty_cycle_tb : std_logic_vector(W_DUTY_CYCLE - 1 downto 0);
	signal outpu_tb      : std_logic;
	
	entity pwm_controller is
		generic
		(
			CLK_PERIOD : time := 20 ns
		);
		port
		(
			clk        : in  std_logic;
			rst        : in  std_logic;
			-- PWM period in milliseconds
			-- period = 28.22
			period     : in  unsigned(W_PERIOD - 1 downto 0);
			-- PWM duty cycle between 0 and 1, out-of-range values are hard-limited
			-- duty_cycle = 30.29
			duty cycle : in  std_logic_vector(W_DUTY_CYCLE - 1 downto 0);
			output     : out std_logic
		);
	end entity;
	
	begin
		
		-- Device under test: PWM controller
		DUT : pwm_controller
			generic map
			(
				CLK_PERIOD => 20 ns
			)
			port map
			(
				clk        => clk_tb,
				rst        => rst_tb,
				period     => period_tb,
				duty_cycle => duty_cycle_tb,
				output     => output_tb
			);
		
		-- PWM stimulation (clk and rst)
		STIMULUS : process ()
		begin
			
		end process;
		
end architecture;
