library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_controller_tb is
end entity;

architecture pwm_controller_tb_arch of pwm_controller_tb is
	
	constant DUT_CLK_PERIOD : time := 20 ns;
	constant NUM_RUN_CYC    : natural := 500; -- * (1000000000 / DUT_CLK_PERIOD);
	
	signal clk_tb        : std_logic;
	signal rst_tb        : std_logic;
	signal period_tb     : unsigned(16 downto 0);
	signal duty_cycle_tb : unsigned(11 downto 0);
	signal output_tb     : std_logic;
	
	component pwm_controller is
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
			period     : in  unsigned(16 downto 0);
			-- PWM duty cycle between 0 and 1, out-of-range values are hard-limited
			-- duty_cycle = 30.29
			duty_cycle : in  unsigned(11 downto 0);
			output     : out std_logic
		);
	end component;
	
begin
	
	-- Device under test: PWM controller
	DUT : pwm_controller
		generic map
		(
			CLK_PERIOD => DUT_CLK_PERIOD
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
	STIMULUS : process
	begin
		clk_tb <= '0';
		rst_tb <= '1'; wait for DUT_CLK_PERIOD * 5;
		rst_tb <= '0';
		period_tb     <= "00000100000000000";
		duty_cycle_tb <=      "010010000000";
		wait for DUT_CLK_PERIOD * 5;
		
		for i in 0 to NUM_RUN_CYC loop
			clk_tb <= '1'; wait for DUT_CLK_PERIOD / 2;
			clk_tb <= '0'; wait for DUT_CLK_PERiOD / 2;
		end loop;
		
	end process;
	
end architecture;
