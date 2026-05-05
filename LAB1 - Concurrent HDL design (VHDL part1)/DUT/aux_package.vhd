library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------
	component top is
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
	end component;
--------------------------FA component------------------------------  
	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;
-------------------------LOGIC component----------------------------
	component Logic IS
	GENERIC (n : INTEGER := 8;
			k : integer := 3;   -- k=log2(n)
			m : integer := 4	); -- m=2^(k-1) 
	PORT 
	(  
		Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			ALUFN_i : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			res: OUT STD_LOGIC_VECTOR(n-1 downto 0)		  
	); 
	end component;
--------------------------ADD/sub component--------------------------
	component AddSub IS
	GENERIC (n : INTEGER := 8;
			   k : integer := 3;   -- k=log2(n)
			   m : integer := 4	); -- m=2^(k-1) 
	PORT 
	  (  
		Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			  ALUFN_i : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			  Cout: OUT STD_LOGIC;
			  s :out STD_LOGIC_VECTOR (n-1 DOWNTO 0)); 
	end component;
	---------------------shifter-------------------------------------
	component shifter IS
	GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
	port
		(	
			Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			  ALUFN_i : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			  cout : out STD_LOGIC ;
			  res : out STD_LOGIC_VECTOR (n-1 DOWNTO 0));
	end component;
end aux_package;	


