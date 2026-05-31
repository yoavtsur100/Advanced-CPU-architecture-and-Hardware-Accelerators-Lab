library IEEE;
use ieee.std_logic_1164.all;

--------------------------------------------------------
entity Logic IS
GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1) 
PORT 
  (  
	Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		  res: OUT STD_LOGIC_VECTOR(n-1 downto 0)); 
  end Logic;
  -------------------------------------------------------
  ARCHITECTURE lg OF logic IS 
  begin
  --CHOOSE OPERATION BY 'XXX' OPCODE....generic
		with ALUFN_i select 
			res <=  not (Y_i) when "000",
					Y_i or x_i  when  "001",
					Y_i and x_i when "010", 	
					Y_i xor x_i when  "011", 	
					Y_i nor x_i when "100" ,	
					Y_i nand x_i when "101" , 	
					Y_i xnor x_i when "110" ,	
					(others =>'0') when others;
End lg;		
	
	