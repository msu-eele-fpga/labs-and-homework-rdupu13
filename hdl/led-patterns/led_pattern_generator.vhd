library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pattern_generator is
	generic (
		system_clock_period : time := 20 ns
	);
	port (
		clk             : in  std_ulogic;                    -- System clock
		rst             : in  std_ulogic;                    -- System reset (active high)
		
	);
end entity;

architecture pattern_generator_arch of pattern_generator is
	
	
	
	begin
		
		
		
end architecture;