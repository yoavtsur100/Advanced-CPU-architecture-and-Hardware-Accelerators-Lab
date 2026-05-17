LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
USE work.aux_package.all;
-------------------------------------
entity ALU is
	GENERIC (length : INTEGER := 16);
	PORT ( a_i, b_i: IN STD_LOGIC_VECTOR (length-1 DOWNTO 0);
          ALUFN_i :IN STD_LOGIC_VECTOR (3 downto 0);
            res_o: OUT STD_LOGIC_VECTOR (length-1 DOWNTO 0);
         Z_flag_o,C_flag_o,N_flag_o : out std_logic);
END ALU;
--------------------------------------------------------------------------
ARCHITECTURE al of ALU is
	signal s_or_w,s_and_w,s_xor_w : STD_LOGIC_VECTOR (length-1 DOWNTO 0):= (others => '0');
	signal s_adder_w,s_sub_w : STD_LOGIC_VECTOR (length-1 DOWNTO 0):= (others => '0');
	signal b_not_w : STD_LOGIC_VECTOR (length-1 DOWNTO 0):= (others => '0');
	signal carry_adder_w,carry_sub_w: STD_LOGIC;
	--signal z_w : STD_LOGIC;
	constant zero_vec : std_logic_vector(length-1 downto 0) := (others => '0');
	signal s_w : STD_LOGIC_VECTOR (length-1 DOWNTO 0):= (others => '0');


begin
	b_not_w <= not(b_i);
	s_or_w <= a_i or b_i;
	s_and_w <= a_i and b_i;
	s_xor_w <= a_i xor b_i;
	RipAdder : Adder generic map (length => length)  port map (  a_i => a_i  , b_i => b_i  , cin_i => '0' , s_o => s_adder_w, cout_o => carry_adder_w ) ;
	RipSubber : Adder generic map (length => length)  port map (  a_i => a_i  , b_i => b_not_w  , cin_i => '1' , s_o => s_sub_w, cout_o => carry_sub_w ) ;
	
	---jmp,ld,st are used with adder instruction because 2-compliment.
	--done is under others.
	with ALUFN_i select	
		s_w <= s_adder_w when "0000"|"1101"|"1110",
			   s_sub_w when "0001",
			   s_and_w when "0010",
			   s_or_w when "0011",
			   s_xor_w when "0100",
			 --XXX when "0101",
			 --XXX when "0110",
			 --XXX when "1010",  
			 --XXX when "1011",
			 a_i when others;
	
	res_o <= s_w;
	
	C_flag_o <= carry_adder_w when (ALUFN_i = "0000" and carry_adder_w /= 'X') else
				carry_sub_w   when (ALUFN_i = "0001" and carry_sub_w /= 'X') else
				'0';
	
	N_flag_o <= s_w(length-1) when (ALUFN_i = "0000" or ALUFN_i = "0001" or ALUFN_i = "0010" or ALUFN_i = "0011" or ALUFN_i = "0100") 
                              and (not is_x(s_w)) 
				else '0';
	--check if the result is zeros vector
	--z_w <= '1' when (s_w = (s_w'range => '0') and ALUFN_i /= "1111") else '0';
	
	--with ALUFN_i select
	--Z_flag_o <= z_w when "0000",
	--		   z_w when "0001",
	--		   z_w when "0010",
	--		   z_w when "0011",
	--		   z_w when "0100",
	--		 --ISA in RealTime Task, need to check if the flag is relevant.
	--		 --XXX when "0101",
	--		 --XXX when "0110",
	--		 --XXX when "1010",  
	--		 --XXX when "1011",
	--		 '0' when others;
		
	
	--check if the result is negative	
	--with ALUFN_i select
	--N_flag_o <= s_w(length-1) when "0000"|"0001"|"0010"|"0011"|"0100",
	--		 --ISA in RealTime Task, need to check if the flag is relevant.
	--		 --XXX when "0101",
	--		 --XXX when "0110",
	--		 --XXX when "1010",  
	--		 --XXX when "1011",
	--		  '0' when others;
	
	
	
	
	
	--N_flag_o <= unaffected when (ALUFN_i = "1111" or ALUFN_i = "1110" or ALUFN_i = "1101" or ALUFN_i ="1101" or ALUFN_i = "1100" or 
									--ALUFN_i = "1001" or ALUFN_i = "1000" or ALUFN_i = "0111") else s_w(length-1);   --Check MSB of the result 
	Z_flag_o <= unaffected when (ALUFN_i = "1111" or ALUFN_i = "1110" or ALUFN_i = "1101" or ALUFN_i ="1101" or ALUFN_i = "1100" or 
									ALUFN_i = "1001" or ALUFN_i = "1000" or ALUFN_i = "0111") else 	'1' WHEN (s_w = zero_vec) ELSE '0'; -- Compare with zero vector
	
 end al;

