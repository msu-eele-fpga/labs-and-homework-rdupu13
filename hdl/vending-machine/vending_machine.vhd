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
	
	type state is (S_ZERO_CENTS, S_FIVE_CENTS, S_TEN_CENTS, S_FIFTEEN_CENTS);
	signal curr_state : state;
	
	begin
		
		-- Next state logic process
		-- Influenced by nickel and dime inputs
		NEXT_STATE_LOGIC : process(clk, rst, curr_state, nickel, dime) is
			begin
				if falling_edge(rst) then
					-- Reset state
					curr_state <= S_ZERO_CENTS;
					
				elsif rising_edge(clk) then
					case (curr_state) is
						
					when S_ZERO_CENTS =>
						-- Nickels are ignored if dimes are inserted
						curr_state <= S_TEN_CENTS  when (nickel = '1' and dime = '1') else
									  S_TEN_CENTS  when (nickel = '0' and dime = '1') else
									  S_FIVE_CENTS when (nickel = '1' and dime = '0') else
									  S_ZERO_CENTS;
					
					when S_FIVE_CENTS =>
						-- Nickels are ignored if dimes are inserted
						curr_state <= S_FIFTEEN_CENTS  when (nickel = '1' and dime = '1') else
									  S_FIFTEEN_CENTS  when (nickel = '0' and dime = '1') else
									  S_TEN_CENTS      when (nickel = '1' and dime = '0') else
									  S_FIVE_CENTS;
					
					when S_TEN_CENTS =>
						-- Any coin insertion will change curr_state to S_FIFTEEN_CENTS
						curr_state <= S_FIFTEEN_CENTS  when (nickel = '1' or dime = '1') else
									  S_TEN_CENTS;
					
					when S_FIFTEEN_CENTS =>
						-- Next state after S_FIFTEEN_CENTS is always S_ZERO_CENTS
						curr_state <= S_ZERO_CENTS;
					
					end case;
				end if;
		end process;
		
		-- Output logic process
		-- Determined only by the current state in this Moore machine
		-- Drives the dispense and amount ports
		OUTPUT_LOGIC : process(clk, rst, curr_state) is
			begin
				case (curr_state) is
				
				-- amount displays current collected cents
				-- dispence is only driven high on S_FIFTEEN_CENTS
				when S_ZERO_CENTS =>
					dispense <= '0';
					amount <= 0;
				when S_FIVE_CENTS =>
					dispense <= '0';
					amount <= 5;
				when S_TEN_CENTS =>
					dispense <= '0';
					amount <= 10;
				when S_FIFTEEN_CENTS =>
					dispense <= '1';
					amount <= 15;
					
				end case;
		end process;

end architecture;