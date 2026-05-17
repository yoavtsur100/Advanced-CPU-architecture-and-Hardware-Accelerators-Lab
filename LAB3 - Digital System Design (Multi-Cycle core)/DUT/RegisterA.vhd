LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
USE work.aux_package.all;
-------------------------------------
entity RegisterA IS 
		generic(Dwidth: integer:=16);
		port( clk,rst : in std_logic;
			--From the Control
			Ain_i : in std_logic;
			--From BUS
			DataIn_i : in std_logic_vector(Dwidth-1 downto 0);
			
			DataOut_o : Out std_logic_vector(Dwidth-1 downto 0));
end RegisterA;
-----------------------------------------
architecture RA of RegisterA IS
	signal Data_temp_q : std_logic_vector(Dwidth-1 downto 0);
begin
	--Regular process Ain is like Enable.
	process(clk, rst)
		begin
			if rst = '1' then
				 Data_temp_q <= (others => '0'); 
			elsif (clk'event and clk='1') then
				if Ain_i = '1' then
					Data_temp_q <= DataIn_i;
				end if;
			end if;
		end process;
	DataOut_o	<= Data_temp_q;

end RA;	