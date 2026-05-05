library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb_top is
	constant n : integer := 8;
end tb_top;
---------------------------------------------------------
architecture rtb of tb_top is
	SIGNAL rst,ena,clk : std_logic;
	SIGNAL x : std_logic_vector(n-1 downto 0);
	SIGNAL DetectionCode : integer range 0 to 3;
	SIGNAL detector : std_logic;
begin
	L0 : top generic map (8,7,3) port map(rst,ena,clk,x,DetectionCode,detector);
    
	------------ start of stimulus section --------------
	
        gen_clk : process
        begin
		  clk <= '0';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
		
		gen_x : process
			variable j : integer := 0;
        begin
		
		---First loop: legal loop checking if detector is 1 from 7 to 15 iteraition.
		--(0-1600ns)
		  x <= (others => '0');
		  DetectionCode <= 0;
		  for i in 0 to 15 loop
			wait for 100 ns;
			x <= x+1;
		  end loop;
		  
		  ---Second loop check if the enable oparites correctly.
		  --(1600-2900ns)
		  DetectionCode <= 1;
		  x <= (others => '0');
		  for i in 0 to 12 loop
			wait for 100 ns;
			x <= x+2;
		  end loop;
		  
		  ---Third loop check how wrong differance affect on the detector and the counting valid.
		  --(2900-4600ns)
		  --3200 the wrong differance
		  DetectionCode <= 2;
		  x <= (others => '0');
		  for i in 0 to 5 loop
			wait for 100 ns;
			x <= x+3;
		  end loop;
		  x <= x+10;
		  wait for 100 ns;
		  for i in 0 to 9 loop
			wait for 100 ns;
			x <= x+3;
		  end loop;
		  
		  --Four loop check if the reset oparites correctly.
		  --(4600- 5900ns)
		  DetectionCode <= 3;
		  x <= (others => '0');
		  for i in 0 to 12 loop
			wait for 100 ns;
			x <= x+4;
		  end loop;
		  
		  
		  wait;
		  end process;
		
		---change reset during simulation , (if reset =1 resrt the counting). 
		gen_rst : process
        begin
		  rst <='1','0' after 100 ns, '1' after 5100ns , '0' after 5300ns;
		  wait;
        end process; 
		----change enable during the simulation, (if ena =0 there is no possible valid) drop 3 sampales.
		gen_ena : process
        begin
		  ena <='0','1' after 200ns,'0' after 2000ns,'1' after 2200ns;
		  wait;
        end process;
  
end architecture rtb;
