LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY top_ALU IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  PORT 
  (  
	Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC
  ); -- Zflag,Cflag,Nflag,Vflag
END top_ALU;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF top_ALU IS
	signal s_logic , s_addersub, s_shifter: STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    signal carry_addersub,carry_shifter: STD_LOGIC;
	signal y_logic, y_shifter, y_addersub : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	signal x_addersub, x_shifter, x_logic : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	signal v_adder, v_subber : STD_LOGIC;
	signal s_temp : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	signal z_temp : STD_LOGIC;
	
BEGIN
-----The AND gate from the schematic (zero vector if not match or same vector)

	with ALUFN_i (4 downto 3) select
			x_logic <= X_i       when "11",
					(others => '0') when others;	

	with ALUFN_i (4 downto 3) select
			y_logic <= y_i       when "11",
					(others => '0') when others;
					
	with ALUFN_i (4 downto 3) select
			x_addersub <= X_i       when "01",
					(others => '0') when others;	

	with ALUFN_i (4 downto 3) select
			y_addersub <= y_i       when "01",
					(others => '0') when others;
	with ALUFN_i (4 downto 3) select
			x_shifter <=   X_i       when "10",
					(others => '0') when others;	

	with ALUFN_i (4 downto 3) select
			y_shifter <= y_i       when "10",
					(others => '0') when others;

---calls to the lowest Entitys in thr
	lg : Logic generic map(n) port map	(Y_i => y_logic ,X_i => x_logic , ALUFN_i => ALUFN_i(2 downto 0) , res => s_logic) ;
	as : AddSub  generic map(n) port map(Y_i => y_addersub ,X_i => x_addersub , ALUFN_i => ALUFN_i(2 downto 0),Cout =>carry_addersub , s => s_addersub) ;
	sh : shifter generic map(n,k) port map (Y_i => y_shifter ,X_i => x_shifter , ALUFN_i => ALUFN_i(2 downto 0),cout =>carry_shifter ,res => s_shifter) ;


	--4 cases to overflow by TrueTable:	
	--           x   y   nflag    v
	--	         0    0    1      1
	--			 1	  1	   0      1
	---	         1	  0	   1	  1	
	--			 0	  1	   0	  1	
	v_adder <= (X_i(n-1) xor s_addersub(n-1)) and (y_i(n-1) xor s_addersub(n-1));
	v_subber <= (X_i(n-1) xor y_i(n-1)) and (y_i(n-1) xor s_addersub(n-1));		
---- The output of the Top Entity
	with ALUFN_i (4 downto 3) select
		s_temp  <=  s_addersub    when "01",
			          s_logic       when "11",
				      s_shifter    when "10",
					(others => '0') when others;	
	ALUout_o <= s_temp;

	--check if the result is zeros vector
	z_temp <= '1' when ( unsigned (s_temp)= 0) else
			  '0';							
	with ALUFN_i (4 downto 3) select
		Zflag_o  <= z_temp  when "01",
			        z_temp     when "11",
				    z_temp   when "10",
					 '1' when others;

					
---logic doest possible carry.
    with ALUFN_i (4 downto 3) select
		Cflag_o  <=  carry_addersub    when "01",
			        '0'                when "11",
				    carry_shifter      when "10",
					'0' when others;
					
--The MSB bit of the result determine the sign Positive or Negeative				
	with ALUFN_i (4 downto 3) select
		Nflag_o  <=  s_addersub(n-1)    when "01",
			         s_logic(n-1)       when "11",
				     s_shifter(n-1)    when "10",
					 '0' when others;
					
---	4 cases to overflow:				
	with ALUFN_i (4 downto 0) select
		Vflag_o  <=  v_adder    when "01000" | "01011",	
					 v_subber	when "01001" | "01100",
					'0' when others;	
			 
END struct;

