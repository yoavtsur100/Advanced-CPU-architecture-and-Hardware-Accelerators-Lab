LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE work.cond_compilation_package.all;
USE work.aux_package.all;
-----------------------------------------------------------------

entity BidirPin is
	generic( width: integer:=16 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
end BidirPin;
--Bidirectional BUS: Use as Tri-state.
architecture comb of BidirPin is
begin 

	Din  <= IOpin;
	IOpin <= Dout when(en='1') else (others => 'Z');
	
end comb;

