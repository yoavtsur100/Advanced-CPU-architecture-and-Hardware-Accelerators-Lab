library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb_logic is
	constant n : integer := 8;
	--constant k : integer := 5;   -- k=log2(n)
	--constant m : integer := 16;   -- m=2^(k-1)
	constant ROWmax : integer := 8; --  9 input (7 legal and 2 wrong)
end tb_logic;
------------------------------------------------------------------------------
architecture lg of tb_logic is
	type mem is array (0 to ROWmax) of std_logic_vector(2 downto 0);
	SIGNAL Y,X:  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	SIGNAL ALUFN :  STD_LOGIC_VECTOR (2 DOWNTO 0);
	signal res : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	SIGNAL Icache : mem := ("000","001","010","011","100","101","110","111","Z10");

begin
	L0 : logic generic map (n) port map(Y_i => Y, X_i => X, ALUFN_i =>ALUFN , res => res);	
	
		--------- start of stimulus section ---------------------------------------		
        tb_x_y : process
		begin		
		  x <= (others => '0');
		  y <= (others => '1');
		  wait for 50 ns;
		  for i in 0 to 16 loop --change x,y values total time 900 ns because 9 inputs
			x <= x+5;
			y <= y-2;
			wait for 50 ns;
		  end loop;
		  wait;
        end process;


		tb_ALUFN : process
        begin
		  ALUFN <= (others => '0');
		  for i in 0 to ROWmax loop
			ALUFN <= Icache(i);
			wait for 100 ns;
		  end loop;
		  wait;
        end process;
end architecture lg;
		
	
	
