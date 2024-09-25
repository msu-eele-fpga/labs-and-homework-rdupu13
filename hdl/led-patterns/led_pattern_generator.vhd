library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_pattern_generator is
	generic (
		system_clock_period : time := 20 ns
	);
	port (
		clk               : in  std_ulogic;                    -- System Clock
		rst               : in  std_ulogic;                    -- System reset (active high)
		base_period       : in  unsigned(7 downto 0);          -- LED blink rate
		pattern_sel       : in  std_ulogic_vector(2 downto 0); -- Select which pattern to display
		patten_gen        : out std_ulogic_vector(6 downto 0)  -- LED pattern
	);
end entity;

architecture led_pattern_generator_arch of pattern_generator is
	
	signal pattern_0 : std_ulogic_vector(6 downto 0) := "0000001";
	signal pattern_1 : std_ulogic_vector(6 downto 0) := "0000011";
	signal pattern_2 : unsigned(6 downto 0) := 0;
	signal pattern_3 : unsigned(6 downto 0) := 0;
	signal pattern_4 : std_ulogic_vector(6 downto 0) := std_ulogic_vector(base_period(6 downto 0));
	signal count     : natural := 0;
	
	constant ONE_SECOND_COUNT : natural := 1000000000 ns / system_clock_period;
	
	begin
		
		-- State 0 (reset): one shifting right      at 1/2
		-- State 1: two shifting left               at 1/4
		-- State 2: 7 bit up-counter                at 2
		-- State 3: 7 bit down-counter              at 1/8
		-- State 4: Base rate in binary alternating at 1/4
		
		PATTERN_LATCHES : process (clk, rst, base_period, 
		                           pattern_0, pattern_1, pattern_2, pattern_3, pattern_4,
								   pattern_sel) is
		begin
			if rst = '1' then
				
				pattern_0 <= "0000001";
				pattern_1 <= "0000011";
				pattern_2 <= 0;
				pattern_3 <= 0;
				pattern_4 <= std_ulogic_vector(base_period(6 downto 0));
				count     <= 0;
				
			elsif rising_edge(clk)	then
				
				if count >= ONE_SECOND_COUNT * base_period / 16;
					pattern_0 <= ror pattern_0;
					pattern_1 <= rol pattern_1;
					pattern_2 <= pattern_2 + 1;
					pattern_3 <= pattern_3 - 1;
					pattern_4 <= not pattern_4;
					count     <= 0;
				else
					pattern_0 <= pattern_0;
					pattern_1 <= pattern_1;
					pattern_2 <= pattern_2;
					pattern_3 <= pattern_3;
					pattern_4 <= pattern_4;
					count     <= count + 1;
				end if;
				
			end if;
			
			case (pattern_sel) is
				when "000"  => pattern_gen <= pattern_0;
				when "001"  => pattern_gen <= pattern_1;
				when "010"  => pattern_gen <= pattern_2;
				when "011"  => pattern_gen <= pattern_3;
				when "100"  => pattern_gen <= pattern_4;
				when others => pattern_gen <= "0000000";
			end case;
			
		end process;
		
end architecture;