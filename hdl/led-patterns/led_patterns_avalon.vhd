library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_patterns_avalon is
	port (
		clk           : in std_logic;
		rst           : in std_logic;
		-- Avalon memory-mapped slave interface
		avs_read      : in  std_logic;
		avs_write     : in  std_logic;
		avs_address   : in  std_logic_vector(1 downto 0);
		avs_readdata  : out std_logic_vector(31 downto 0);
		avs_writedata : in  std_logic_vector(31 downto 0);
		-- External I/O; export to top-level
		push_button   : in  std_logic;
		switches      : in  std_logic_vector(3 downto 0);
		led           : out std_logic_vector(7 downto 0)
	);
end entity;

architecture led_patterns_avalon_arch of led_patterns_avalon is
	
	signal hps_led_control : std_logic_vector(31 downto 0);
	signal led_reg         : std_logic_vector(31 downto 0);
	signal base_period     : std_logic_vector(31 downto 0);
	
	component led_patterns is
		generic (
			system_clock_period : time := 20 ns
		);
		port (
			clk             : in  std_logic;                    -- System clock
			rst             : in  std_logic;                    -- System reset (active high)
			push_button     : in  std_logic;                    -- Push button to change state (active high)
			switches        : in  std_logic_vector(3 downto 0); -- Switches that determine next state
			hps_led_control : in  boolean;                      -- Software is in control when =1
			base_period     : in  unsigned(7 downto 0);         -- LED blink rate
			led_reg         : in  std_logic_vector(7 downto 0); -- LED register
			led             : out std_logic_vector(7 downto 0)  -- LED pins on board
		);
	end component;
	
	begin
		
		LED_PATTERNS_DESIGN : led_patterns
			generic map(
				system_clock_period => 20 ns
			)
			port map(
				clk             => clk,
				rst             => rst,
				push_button     => push_button,
				switches        => switches,
				hps_led_control => (hps_led_control(0) = '1'),
				base_period     => unsigned(base_period(7 downto 0)),
				led_reg         => led_reg(7 downto 0),
				led             => led
			);
		
		AVALON_REGISTER_READ : process(clk, avs_read) is
		begin
			if rising_edge(clk) and avs_read = '1' then
				case avs_address is
					
					when "00"   => avs_readdata <= hps_led_control;
					when "01"   => avs_readdata <= led_reg;
					when "10"   => avs_readdata <= base_period;
					when others => avs_readdata <= (others => '0');
					
				end case;
			end if;
		end process;
		
		AVALON_REGISTER_WRITE : process (clk, rst, avs_write) is
		begin
			if rst = '1' then
				hps_led_control <= "00000000000000000000000000000000"; -- HPS control off
				led_reg         <= "00000000000000000000000000000000"; -- LED reg 0x00
				base_period     <= "00000000000000000000000000000010"; -- BP = 0.125 s
				
			elsif rising_edge(clk) and avs_write = '1' then
				case avs_address is
					
					when "00"   => hps_led_control <= avs_writedata;
					when "01"   => led_reg         <= avs_writedata;
					when "10"   => base_period     <= avs_writedata;
					when others => null; -- Ignore writes to unused registers
					
				end case;
			end if;
		end process;

end architecture;
