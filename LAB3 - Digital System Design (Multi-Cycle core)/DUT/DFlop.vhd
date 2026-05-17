LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
USE work.aux_package.all;
-------------------------------------
entity Dflop is 
	generic( Dwidth: integer:=16);
	port(clk,rst,ena : in std_logic;
		DataIn_i : in std_logic_vector(Dwidth-1 downto 0);
		DataOut_o : out std_logic_vector(5 downto 0));
end Dflop;
-------------------------------------
architecture df of Dflop is
	signal temp_q :std_logic_vector(Dwidth-1 downto 0);

	begin
		process(clk, rst)
		begin
			if rst = '1' then
				temp_q <= (others=>'0');
			elsif (clk'event and clk='1') then
				if ena = '1' then				
					temp_q <= DataIn_i;
				end if;
			end if;
		end process;
		DataOut_o <= temp_q(5 downto 0);
end df;