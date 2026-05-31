library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity shifter IS
GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
port
	(
		Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		  cout : out STD_LOGIC ;
		  res : out STD_LOGIC_VECTOR (n-1 DOWNTO 0));
end shifter;

---------------------------------------------------------
architecture sh of shifter is 
	type matrix is array (0 to k) of STD_LOGIC_VECTOR(n-1 downto 0); ---matrix(K+1xN)
	signal mat : matrix;
	signal dir : STD_LOGIC;
	signal carry : STD_LOGIC_VECTOR (k downto 0);
	
	begin
	---- validition legal OPCODE:

	 with ALUFN_i select			
				res <=  mat(k) when "000" |"001" ,
					  (others => '0') when others;
					  
    with ALUFN_i select			
				Cout <= carry(k) when "000" |"001" ,
					  '0' when others;
	
	----The LSB og ALU (SHL or SHR)
		dir <= ALUFN_i(0);
		----initinal
		mat(0) <= Y_i;
		carry(0) <= '0';
	
		shift: for i in 0 to k-1 generate
	---if X_i(i)= 0 no shifting 
	---dir=1 SHR dir =0 SHL
	---& is for sequence of 0
					mat(i+1) <=  mat(i) when X_i(i) = '0' else 
								(mat(i)(n-1 -(2**i)DOWNTO 0)&((2**i)-1 downto 0 => '0')) when dir = '0' else
								(((2**i)-1 downto 0 => '0') & mat(i)(n-1 downto 2**i));
		--	if X_i(i)= 0 carry is the same like the previos.
		--  dir = '0' shift left carry is the last MSB dump
		--  dir = 1 shift right carry is the last LSB dump
					carry(i+1) <= carry(i) when X_i(i) = '0' else
								(mat(i)(n-(2**i))) when  dir = '0' else
								mat(i)((2**i)-1);
		end generate;						

end architecture sh;

