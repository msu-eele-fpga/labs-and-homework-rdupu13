library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity async_conditioner_tb is
end entity;

architecture async_conditioner_tb_arch of async_conditioner_tb is
	
	constant CLK_PERIOD      : time := 20 ns;
	constant DEBOUNCE_TIME_0 : time := 1000 ns;
	constant DEBOUNCE_TIME_1 : time := 10000 ns;
	
	signal clk_tb   : std_ulogic;
	signal rst_tb   : std_ulogic;
	signal async_tb : std_ulogic;
	signal sync_tb  : std_ulogic_vector(1 downto 0);
	
	component async_conditioner is
		generic (
			clk_period    : time;
			debounce_time : time
		);
		port (
			clk   : in  std_ulogic;
			rst   : in  std_ulogic;
			async : in  std_ulogic;
			sync  : out std_ulogic
		);
	end component;
	
	begin
		
		DUT_1 : async_conditioner
			generic map (
				clk_period    => CLK_PERIOD,
				debounce_time => DEBOUNCE_TIME_0
			)
			port map (
				clk   => clk_tb,
				rst   => rst_tb,
				async => async_tb,
				sync  => sync_tb(0)
			);
		
		DUT_2 : async_conditioner
			generic map (
				clk_period    => CLK_PERIOD,
				debounce_time => DEBOUNCE_TIME_1
			)
			port map (
				clk   => clk_tb,
				rst   => rst_tb,
				async => async_tb,
				sync  => sync_tb(1)
			);
		
		-- Device testing
		STIMULUS : process is
		begin
			
			
			
		end process;
		
end architecture;