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
		base_period     : in  unsigned(7 downto 0);          -- 
		led_reg         : in  std_ulogic_vector(7 downto 0); -- LED register
		led             : out std_ulogic_vector(7 downto 0)  -- LED pins on board
	);
end entity;

architecture led_patterns_arch of led_patterns is
	
	signal push_button_pulse : std_ulogic;
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
			clk             : in  std_ulogic;                    -- System clock
			rst             : in  std_ulogic;                    -- System reset (active high)
			
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
			hps_led_control   : in  boolean;
			base_period       : in  unsigned(7 downto 0);
			led_pattern       : out std_ulogic_vector(7 downto 0)
		);
	end component;
	
	begin
		
		-- Asynchronous conditioner
		BOTTON_PULSE : async_conditioner
			generic map (
				clk_period    => system_clock_period,
				debounce_time => 5 us
			);
			port map (
				clk   => clk
				rst   => rst
				async => push_button
				sync  => push_button_pulse
			);
		
		-- Pattern generator
		PATTERN_GEN : led_pattern_generator
			port map (
				
			);
		
		-- Finite state machine for pattern switching
		FSM : led_pattern_fsm
			generic map (
				system_clock_period => system_clock_period
			);
			port map (
				clk               => clk,
				rst               => rst,
				push_button_pulse => push_button_pulse
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