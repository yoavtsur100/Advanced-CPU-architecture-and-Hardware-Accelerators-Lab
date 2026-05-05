LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
USE ieee.std_logic_arith.all;

--------------------------------------------------------------
entity top is
	generic (
		n : positive := 8 ;
		m : positive := 7 ;
		k : positive := 3
	); -- where k=log2(m+1)
	port(
		rst,ena,clk : in std_logic;
		x : in std_logic_vector(n-1 downto 0);
		DetectionCode : in integer range 0 to 3;
		detector : out std_logic
	);
end top;
------------- complete the top Architecture code --------------
architecture arc_sys of top is
--2 flipflops :
	signal ff1 :std_logic_vector (n-1 downto 0);
	signal ff2 :std_logic_vector (n-1 downto 0);
--to use the adder:	
	signal  b_not :STD_LOGIC_VECTOR (n-1 DOWNTO 0); 
	signal  res: STD_LOGIC_VECTOR (n-1 DOWNTO 0); 
	signal Cout :std_logic;
--counter to count the m series.
-- valid to check  detection code fits the gap between the 2 sample.
	signal valid : std_logic;
	signal Counter : integer range 0 to m;

begin
	sampling:process(clk, rst)
			begin
			--if reset is 1 the vectors are zero
				if(rst = '1') then
					ff1 <= (others => '0');
					ff2 <= (others => '0');
			-- if there is rising edge in the clock and enable is 1 :sample x and use 2 FlipFlop to memory		
				elsif (clk' event and clk = '1' ) then	
					if (ena = '1') then
			-- signal only change at the end of the process.
						ff1 <= x;
						ff2 <= ff1;
					End if;
				End if;
			End process;

-----------------------------------------------------------------------------------------------------------------------------------			
-- (x[j-1] - x[j-2]) by cin =1 and not b as vector we use compliment 2 method.	
	b_not <= not(ff2);
	RippleAdder : Adder generic map (length => n)  port map (  a => ff1  , b => b_not  , cin => '1' , s => res, cout => Cout ) ;
	
--Convert and compare (detectionCode +1) to n bit vector becasue the table ,check validition by condition.
	valid <= '1' when (res = conv_std_logic_vector(DetectionCode + 1 ,n)) else '0';
------------------------------------------------------------------------------------------------------------------------------------
	
	valid_series : process(clk , rst )
				   begin
				   ---if there is reset to the clock reset counter --> detector =0.
						if(rst = '1') then
							Counter <= 0;
					--- if there is rising edge and enable "high" we handle the counter.		
						elsif (clk' event and clk = '1' ) then	
							if (ena = '1') then
								if (valid = '1') then 
									if (counter < m ) then		
										counter <= Counter +1;
									End if;
								else
								----if no valid detection code reset the counter.
									counter <= 0;
								End if;
								
							End if;
						end if;	
					End process;
----change the detector by mux, outside the process for real time changes.					
				with Counter select
				detector <= '1' when m, 
							'0' when others;

end arc_sys;







