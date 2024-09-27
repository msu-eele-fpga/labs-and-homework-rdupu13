library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_patterns is
	generic (
		system_clock_period : time := 20 ns
	);
	port (
		clk             : in  std_ulogic;                    -- System clock
		rst             : in  std_ulogic;                    -- System reset (active high)
		push_button     : in  std_ulogic;                    -- Push button to change state (active high)
		switches        : in  std_ulogic_vector(3 downto 0); -- Switches that determine next state
		hps_led_control : in  boolean;                       -- Software is in control when =1
		base_period     : in  unsigned(7 downto 0);          -- LED blink rate
		led_reg         : in  std_ulogic_vector(7 downto 0); -- LED register
		led             : out std_ulogic_vector(7 downto 0)  -- LED pins on board
	);
end entity;

architecture led_patterns_arch of led_patterns is
	
	signal push_button_n : std_ulogic;
	
	signal push_button_pulse : std_ulogic;
	signal pattern_gen       : std_ulogic_vector(7 downto 0);
	signal pattern_sel       : std_ulogic_vector(2 downto 0);
	signal led_pattern       : std_ulogic_vector(7 downto 0);
	
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
	
	component led_pattern_generator is
		generic (
			system_clock_period : time := 20 ns
		);
		port (
			clk         : in  std_ulogic;
			rst         : in  std_ulogic;
			base_period : in  unsigned(7 downto 0);
			pattern_sel : in  std_ulogic_vector(2 downto 0);
			pattern_gen : out std_ulogic_vector(7 downto 0)
		);
	end component;
	
	component led_pattern_fsm is
		generic (
			system_clock_period : time := 20 ns
		);
		port (
			clk               : in  std_ulogic;
			rst               : in  std_ulogic;
			push_button_pulse : in  std_ulogic;
			switches          : in  std_ulogic_vector(3 downto 0);
			pattern_gen       : in  std_ulogic_vector(7 downto 0);
			led_pattern       : out std_ulogic_vector(7 downto 0);
			pattern_sel       : out std_ulogic_vector(2 downto 0)
		);
	end component;
	
	begin
		
		-- Asynchronous conditioner
		BOTTON_PULSE : async_conditioner
			generic map (
				clk_period    => system_clock_period,
				debounce_time => 5 us                 -- Experiment with this!!!
			)
			port map (
				clk   => clk,
				rst   => rst,
				async => push_button,
				sync  => push_button_pulse
			);
		
		-- Pattern generator
		PATTERN_GENERATION : led_pattern_generator
			generic map (
				system_clock_period => system_clock_period
			)
			port map (
				clk         => clk,
				rst         => rst,
				base_period => base_period,
				pattern_sel => pattern_sel,
				pattern_gen => pattern_gen
			);
		
		-- Finite state machine for pattern switching
		FSM : led_pattern_fsm
			generic map (
				system_clock_period => system_clock_period
			)
			port map (
				clk               => clk,
				rst               => rst,
				push_button_pulse => push_button_pulse,
				switches          => switches,
				pattern_gen       => pattern_gen,
				led_pattern       => led_pattern,
				pattern_sel       => pattern_sel
			);
		
		-- Multiplexer to assign control to either hps (=1) or fsm (=0)
		LED_MUX : process (hps_led_control, led_reg, led_pattern) is
		begin
			if hps_led_control then
				led <= led_reg;
			else
				led <= led_pattern;
			end if;
		end process;
		
end architecture;