library ieee;
use ieee.std_logic_1164.all;
use work.print_pkg.all;
use work.assert_pkg.all;
use work.tb_pkg.all;

entity timed_counter_tb is
end entity;

architecture timed_counter_tb_arch of timed_counter_tb is
	
	signal clk_tb : std_ulogic := '0';
	
	constant COUNT_TIME_1  : time := 100 ns;
	signal enable_time1_tb : boolean := false;
	signal done_time1_tb   : boolean;
	
	constant COUNT_TIME_2  : time := 60 ns;
	signal enable_time2_tb : boolean := false;
	signal done_time2_tb   : boolean;
	
	component timed_counter is
		generic (
			clk_period : time;
			count_time : time
		);
		port (
			clk    : in  std_ulogic;
			enable : in  boolean;
			done   : out boolean
		);
	end component;
	
	procedure predict_counter_done (
		constant count_time : in time;
		signal enable       : in boolean;
		signal done         : in boolean;
		constant count_iter : in natural
	) is
		begin
			
			if enable then
				if count_iter < (count_time / CLK_PERIOD) then
					assert_false(done, "Counter shouldn't be done but got done=true.");
				else
					assert_true(done, "Counter should be done but got done=false.");
				end if;
			else
				assert_false(done, "Counter isn't enabled but got done=true.");
			end if;
			
	end procedure;
	
	begin
		
		DUT_100NS_COUNTER : component timed_counter
			generic map (
				clk_period => CLK_PERIOD,
				count_time => COUNT_TIME_1
			)
			port map (
				clk    => clk_tb,
				enable => enable_time1_tb,
				done   => done_time1_tb
			);
			
		DUT_64NS_COUNTER : component timed_counter
			generic map (
				clk_period => CLK_PERIOD,
				count_time => COUNT_TIME_2
			)
			port map (
				clk    => clk_tb,
				enable => enable_time2_tb,
				done   => done_time2_tb
			);
		
		clk_tb <= not clk_tb after CLK_PERIOD / 2;
		
		STIMULI_AND_CHECKER : process is
			begin
			
			-- Count time 1 - 100 ns:
				-- Timer asserts done after 100 ns:
				print("Testing 100 ns timer: enabled.");
				wait_for_clock_edge(clk_tb);
				enable_time1_tb <= true;
				-- Loop for the number of clock cycles that is equal to the timer's period
				for i in 0 to (COUNT_TIME_1 / CLK_PERIOD) loop
					-- Test whether the counter's done output is correct or not
					wait_for_clock_edge(clk_tb);
					predict_counter_done(COUNT_TIME_1, enable_time1_tb, done_time1_tb, i);
				end loop;
				
				-- Timer doesn't assert done when disabled after 200 ns:
				print("Testing 200 ns timer: disabled.");
				wait_for_clock_edge(clk_tb);
				enable_time1_tb <= false;
				-- Loop for the number of clock cycles that is equal to TWICE the timer's period
				for i in 0 to (2 * COUNT_TIME_1 / CLK_PERIOD) loop
					-- Test whether the counter's done output is correct or not
					wait_for_clock_edge(clk_tb);
					predict_counter_done(COUNT_TIME_1, enable_time1_tb, done_time1_tb, i);
				end loop;
				
				-- Timer doesn't assert done when disabled after 200 ns:
				print("Testing 200 ns timer: enabled.");
				wait_for_clock_edge(clk_tb);
				enable_time1_tb <= true;
				-- Loop for the number of clock cycles that is equal to TWICE the timer's period
				for i in 0 to (2 * COUNT_TIME_1 / CLK_PERIOD) loop
					-- Test whether the counter's done output is correct or not
					wait_for_clock_edge(clk_tb);
					predict_counter_done(COUNT_TIME_1, enable_time1_tb, done_time1_tb, i);
				end loop;
			
			-- Count time 2 - 60 ns:
				-- Timer asserts done after 60 ns:
				print("Testing 60 ns timer: enabled.");
				wait_for_clock_edge(clk_tb);
				enable_time2_tb <= true;
				-- Loop for the number of clock cycles that is equal to the timer's period
				for i in 0 to (COUNT_TIME_2 / CLK_PERIOD) Loop
					-- Test whether the counter's done output is correct or not
					wait_for_clock_edge(clk_tb);
					predict_counter_done(COUNT_TIME_2, enable_time2_tb, done_time2_tb, i);
				end loop;
				
				-- Timer doesn't assert done when disabled after 120 ns:
				print("Testing 120 ns timer: disabled.");
				wait_for_clock_edge(clk_tb);
				enable_time2_tb <= false;
				-- Loop for the number of clock cycles that is equal to TWICE the timer's period
				for i in 0 to (2 * COUNT_TIME_2 / CLK_PERIOD) loop
					-- Test whether the counter's done output is correct or not
					wait_for_clock_edge(clk_tb);
					predict_counter_done(COUNT_TIME_2, enable_time2_tb, done_time2_tb, i);
				end loop;
				
				-- Timer doesn't assert done when disabled after 120 ns:
				print("Testing 120 ns timer: enabled.");
				wait_for_clock_edge(clk_tb);
				enable_time2_tb <= true;
				-- Loop for the number of clock cycles that is equal to TWICE the timer's period
				for i in 0 to (2 * COUNT_TIME_2 / CLK_PERIOD) loop
					-- Test whether the counter's done output is correct or not
					wait_for_clock_edge(clk_tb);
					predict_counter_done(COUNT_TIME_2, enable_time2_tb, done_time2_tb, i);
				end loop;
				
				std.env.finish;
				wait;
				
		end process;
		
end architecture;