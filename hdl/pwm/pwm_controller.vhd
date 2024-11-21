library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
		-- period data type: u17.11
		period     : in  unsigned(16 downto 0);
		-- PWM duty cycle between 0 and 1, out-of-range values are hard-limited
		-- duty_cycle data type: u12.11
		duty cycle : in  unsigned(11 downto 0);
		output     : out std_logic;
	);
end entity;

architecture pwm_controller_arch of pwm_controller is
	
	
	signal cyc_per_period : natural
		:= natural(period(16 downto 11)) / CLK_PERIOD
		 + natural(period(10 downto 0)) / (2048 * CLK_PERIOD);
	
	signal cyc_per_dc : natural
		:= natural(duty_cycle(10 downto 0)) * cyc_per_period / CLK_PERIOD;
	
	signal dc_is_one : boolean := boolean(duty_cycle(11));
	signal counter   : natural := 0;
	
	begin
		
		PULSE_WIDTH_MODULATION : process (clk, rst, cyc_per_period, cyc_per_dc)
		begin
			if rst = '1' then
				output <= '0';
				counter <= 0;
				
			elsif rising_edge(clk) then
				if dc_is_one then
					output <= '1';
					counter <= 0;
					
				else
					if counter < cyc_per_dc then
						output <= '1';
						counter <= counter + 1;
						
					elsif counter >= cyc_per_dc and counter < cyc_per_period then
						output <= '0';
						counter <= counter + 1;
						
					else
						output <= '1';
						counter <= 1;
						
					end if;
				end if;
			end if;
		end process;
		
end architecture;
