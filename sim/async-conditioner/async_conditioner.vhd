library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity async_conditioner is
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
end entity;

architecture async_conditioner_arch of async_conditioner is
	
	signal synchronized : std_ulogic;
	signal debounced    : std_ulogic;
	signal pulsed       : std_ulogic;
	
	component synchronizer is
		port(
			clk   : in  std_ulogic;
			async : in  std_ulogic;
			sync  : out std_ulogic
		);
	end component;
	
	component debouncer is
		generic(
			clk_period    : time := 20 ns;
			debounce_time : time
		);
		port (
			clk       : in  std_ulogic;
			rst       : in  std_ulogic;
			input     : in  std_ulogic;
			debounced : out std_ulogic
		);
	end component;
	
	component one_pulse is
		port (
			clk   : in  std_ulogic;
			rst   : in  std_ulogic;
			input : in  std_ulogic;
			pulse : out std_ulogic
		);
	end component;
	
	begin
		
		-- Input async first travels through the ynchronizer ...
		SYNCHRONIZER_COMP : synchronizer
			port map (
				clk   => clk,
				async => async,
				sync  => synchronized
			);
		
		-- ... once synchronized, it's then debounced ...
		DEBOUNCER_COMP : debouncer
			generic map (
				clk_period    => clk_period,
				debounce_time => debounce_time
			)
			port map (
				clk       => clk,
				rst       => rst,
				input     => synchronized,
				debounced => debounced
			);
		
		-- ... after debounced, it's shortened to the length of
		-- a single clock pulse ...
		ONE_PULSE_COMP : one_pulse
			port map (
				clk   => clk,
				rst   => rst,
				input => debounced,
				pulse => pulsed
			);
		
		-- ... and it becomes the output.
		sync <= pulsed;
		
end architecture;