library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timed_counter is
	generic (
		clk_period : time;
		count_time : time
	);
	port (
		clk    : in  std_ulogic;
		enable : in  boolean;
		done   : out boolean
	);
end entity;

architecture timed_counter_arch of timed_counter is
	
	signal count         : integer range 0 to 65535 := 0;
	signal clk_period_ns : integer range 1 to 65535 := integer(clk_period / 1 ns);
	signal count_time_ns : integer range 1 to 65535 := integer(count_time / 1 ns);
	
	begin
		
		process(clk, enable) is
			begin
				
				if rising_edge(clk) then
					if enable then
						
						count <= count + clk_period_ns;
						
						if count >= count_time_ns then
							done <= true;
						else
							done <= false;
						end if;
					
					else
						
						count <= 0;
						done <= false;
						
					end if;
				end if;
				
		end process;
		
end architecture;