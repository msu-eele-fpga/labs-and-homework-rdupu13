library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_controller_tb is
end entity;

architecture pwm_controller_tb_arch of pwm_controller_tb is
	
	constant DUT_CLK_PERIOD : time := 10 ms;
	constant NUM_RUN_CYC    : natural := 5 sec / DUT_CLK_PERIOD;
	
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
			period     : in  unsigned(16 downto 0);
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
		
		-- Reset 
		clk_tb        <= '0';
		rst_tb        <= '1';
		wait for DUT_CLK_PERIOD * 2;
		rst_tb        <= '0';
		wait for DUT_CLK_PERIOD * 2;
		
		-- Period = 0.78125 s
		-- Duty cycle = 1.00 s
		period_tb     <= "00000011001000000";
		duty_cycle_tb <=      "110010000000";
		for i in 0 to NUM_RUN_CYC loop
			clk_tb <= '1'; wait for DUT_CLK_PERIOD / 2;
			clk_tb <= '0'; wait for DUT_CLK_PERiOD / 2;
		end loop;
		
		-- Period = 0.1.
		-- Duty cycle = 
		period_tb     <= "0000011010011001";
		duty_cycle_tb <=      "010101010101";
		for i in 0 to NUM_RUN_CYC loop
			clk_tb <= '1'; wait for DUT_CLK_PERIOD / 2;
			clk_tb <= '0'; wait for DUT_CLK_PERiOD / 2;
		end loop;
		
		-- Period = 
		-- Duty cycle = 
		period_tb     <= "00000000000011000";
		duty_cycle_tb <=      "001010101010";
		for i in 0 to NUM_RUN_CYC loop
			clk_tb <= '1'; wait for DUT_CLK_PERIOD / 2;
			clk_tb <= '0'; wait for DUT_CLK_PERiOD / 2;
		end loop;
		
		-- Period = 
		-- Duty cycle = 
		period_tb     <= "00000000010000000";
		duty_cycle_tb <=      "000001111111";
		for i in 0 to NUM_RUN_CYC loop
			clk_tb <= '1'; wait for DUT_CLK_PERIOD / 2;
			clk_tb <= '0'; wait for DUT_CLK_PERiOD / 2;
		end loop;
	
	end process;
		
end architecture;
