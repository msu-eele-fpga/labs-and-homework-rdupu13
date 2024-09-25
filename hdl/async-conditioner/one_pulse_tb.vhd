library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity one_pulse_tb is
end entity;

architecture one_pulse_tb_arch of one_pulse_tb is
	
	component one_pulse is
		port (
			clk   : in  std_ulogic;
			rst   : in  std_ulogic;
			input : in  std_ulogic;
			pulse : out std_ulogic
		);
	end component;
	
	begin
		
		DUT : one_pulse
			port map (
				clk   => clk_tb,
				rst   => rst_tb,
				input => pulse
			);
		
		STIMULUS : process is
		begin
			
			
			
		end process;
		
end architecture;