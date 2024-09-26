library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity led_pattern_generator is
	generic (
		system_clock_period : time := 20 ns
	);
	port (
		clk         : in  std_ulogic;                    -- System Clock
		rst         : in  std_ulogic;                    -- System reset (active high)
		base_period : in  unsigned(7 downto 0);          -- LED blink rate
		pattern_sel : in  std_ulogic_vector(2 downto 0); -- Select which pattern to display
		pattern_gen : out std_ulogic_vector(7 downto 0)  -- LED pattern
	);
end entity;

architecture led_pattern_generator_arch of led_pattern_generator is
	
	signal bit_seven : std_ulogic;
	signal pattern_0 : unsigned(6 downto 0);
	signal pattern_1 : unsigned(6 downto 0);
	signal pattern_2 : unsigned(6 downto 0);
	signal pattern_3 : unsigned(6 downto 0);
	signal pattern_4 : unsigned(6 downto 0);
	
	constant ONE_SECOND_COUNT  : natural := 1000000000 ns / system_clock_period;
	signal   base_period_count : natural := (ONE_SECOND_COUNT * to_integer(base_period)) / 4;
	
	signal count        : natural := 0;
	signal clock_vector : unsigned(4 downto 0);
	
	begin
		
		-- State 0 (reset): one shifting right      at 1/2
		-- State 1: two shifting left               at 1/4
		-- State 2: 7 bit up-counter                at 2
		-- State 3: 7 bit down-counter              at 1/8
		-- State 4: Base rate in binary alternating at 1/4
		
		CLOCK_GEN : process (clk, rst, count, clock_vector) is
		begin
			if rst = '1' then
				count <= 0;
				clock_vector <= to_unsigned(0, 5);
			elsif rising_edge(clk) then
				-- LSB of clock_vector blinks at 1/8 of base period
				if count >= base_period_count / 8 then
					clock_vector <= clock_vector + to_unsigned(1, 5);
					count <= 0;
				else
					count <= count + 1;
				end if;
			end if;
			
		end process;
		
		PATTERN_LATCHES : process (clock_vector, rst, base_period,
								   pattern_0, pattern_1, pattern_2, pattern_3, pattern_4,
								   pattern_sel) is
		begin
			if rst = '1' then
				pattern_0 <= to_unsigned(1, 7);
				pattern_1 <= to_unsigned(3, 7);
				pattern_2 <= to_unsigned(0, 7);
				pattern_3 <= to_unsigned(0, 7);
				pattern_4 <= base_period(6 downto 0);
				
			elsif rising_edge(clock_vector(0)) then -- 1/8 * base_period
				pattern_3 <= pattern_3 - to_unsigned(1, 7);
				
			elsif rising_edge(clock_vector(1)) then -- 1/4 * base_period
				pattern_1 <= rotate_left(pattern_1, 1);
				pattern_4 <= not pattern_4;
			
			elsif rising_edge(clock_vector(2)) then -- 1/2 * base_period
				pattern_0 <= rotate_right(pattern_0, 1);
			
			elsif rising_edge(clock_vector(3)) then -- 1 * base_period
				bit_seven <= not bit_seven;
				
			elsif rising_edge(clock_vector(4)) then -- 2 * base_period
				pattern_2 <= pattern_2 + to_unsigned(1, 7);
				
			end if;
			
		end process;
		
		with pattern_sel select pattern_gen <=
			bit_seven & std_ulogic_vector(pattern_0) when "000",
			bit_seven & std_ulogic_vector(pattern_1) when "001",
			bit_seven & std_ulogic_vector(pattern_2) when "010",
			bit_seven & std_ulogic_vector(pattern_3) when "011",
			bit_seven & std_ulogic_vector(pattern_4) when "100",
			bit_seven & "0000000"                    when others;
		
end architecture;