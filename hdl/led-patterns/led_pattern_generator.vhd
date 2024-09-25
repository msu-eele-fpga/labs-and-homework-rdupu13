library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_pattern_generator is
	generic (
		system_clock_period : time := 20 ns
	);
	port (
		clk             : in  std_ulogic;                    -- System clock
		rst             : in  std_ulogic;                    -- System reset (active high)
		
	);
end entity;

architecture led_pattern_generator_arch of pattern_generator is
	
	signal state_0 : std_ulogic_vector(6 downto 0);
	signal state_1 : std_ulogic_vector(6 downto 0);
	signal state_2 : std_ulogic_vector(6 downto 0);
	signal state_3 : std_ulogic_vector(6 downto 0);
	signal state_4 : std_ulogic_vector(6 downto 0);
	
	begin
		
		-- State 0 (reset): one shifting right   at 1/2
		-- State 1: two shifting left            at 1/4
		-- State 2: 7 bit up-counter             at 2
		-- State 3: 7 bit down-counter           at 1/8
		-- State 4: Base rate in binary rotating at 1/4
		
		
		
end architecture;