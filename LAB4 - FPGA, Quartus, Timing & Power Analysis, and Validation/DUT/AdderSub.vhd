library ieee;
use ieee.std_logic_1164.all;
USE work.aux_package.all;
----------------------------------------------
entity AddSub IS
GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1) 
PORT 
  (  
	Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		  Cout: OUT STD_LOGIC;
		  s :out STD_LOGIC_VECTOR (n-1 DOWNTO 0)); 
end AddSub;
  ---------------------------------------------
 architecture As of AddSub IS
		signal reg : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		signal x_afterXor : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		signal x_temp : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		signal SubCont : STD_LOGIC;
		signal y_temp : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		signal s_temp : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		
begin
-------- validition legal OPCODE:
        with ALUFN_i select			
				s <= s_temp when "000" |"001" |"010" | "011" | "100",
					  (others => '0') when others;
					  
        with ALUFN_i select			
				Cout <= reg(n-1) when "000" |"001" |"010" | "011" | "100",
					  '0' when others;
	
--------if there is odd 1 so the subcont 1 else 0 if there is no ileagal opcode  subcont is 0
		
		SubCont <= (ALUFN_i(0) xor ALUFN_i(1) xor ALUFN_i(2)); 
	
--------- when op code 011 or 100 x=2 else if x is 000 001 010 doesnt change. 			  
		with ALUFN_i select 
				x_temp <= ( 1 => '1' , others => '0') when  "011",
						  ( 1 => '1' , others => '0') when  "100",
						  X_i  when others;
							
--------- applying x xor 1 = not x ,  x xor 0 = x  (the sign + or - between the number)	
		with SubCont select
		            x_afterXor <= x_temp when '0',
					  not (x_temp) when others;
		
---------4 cases from the 5 option the Y dont change, the others  (neg opperation and ileagal opcode Y is 0) (if Y is 0 or not).							
		with ALUFN_i select 
				y_temp <= Y_i when  "000" |"001" | "011" | "100",
						  (others =>'0') when others;
						  					
--------- initinal FA operation
		first : FA port map	( xi => x_afterXor(0) , yi => y_temp(0) , cin => SubCont , s => s_temp(0), cout => reg(0)) ;
		
--------- rest FA loop 
		rest: for i in 1 to n-1 generate
			chain: FA PORT map (  xi => x_afterXor(i) , yi => y_temp(i) , cin => reg(i-1) , s => s_temp(i), cout => reg(i)) ;
		end generate;	
	
	
end As;
			
	
  