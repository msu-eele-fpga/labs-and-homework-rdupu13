library ieee;
use ieee.std_logic_1164.all;
use work.print_pkg.all;
use work.assert_pkg.all;
use work.tb_pkg.all;

entity vending_machine is
	port (
		clk	     : in  std_ulogic;
		rst	     : in  std_ulogic;
		nickel   : in  std_ulogic;
		dime     : in  std_ulogic;
		dispense : out std_ulogic;
		amount   : out natural range 0 to 15
	);
end entity;

architecture vending_machine_arch of vending_machine is

	begin
		
		NEXT_STATE_LOGIC : process(clk, rst) is
			begin
				if rising_edge(clk) then
					
				end if;
		end process;
		
		OUTPUT_LOGIC : process(clk, rst) is
			begin
		
		end process;

end architecture;