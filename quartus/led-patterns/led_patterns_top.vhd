library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_patterns_top is
	generic (
		system_clock_period : time := 20 ns
	);
	port (
		clk             : in  std_ulogic;                    -- System clock
		rst             : in  std_ulogic;                    -- System reset (active high)
		push_button     : in  std_ulogic;                    -- Push button to change state (active high)
		switches        : in  std_ulogic_vector(3 downto 0); -- Switches that determine next state
		hps_led_control : in  boolean;                       -- Software is in control when =1
		base_period     : in  unsigned(7 downto 0);          -- 
		led_reg         : in  std_ulogic_vector(7 downto 0); -- LED register
		led             : out std_ulogic_vector(7 downto 0)  -- LED pins on board
	);
end entity;

architecture led_patterns_top_arch of led_patterns_top is
	
	
	
	begin
		
		
		
end architecture;