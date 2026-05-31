library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------
component top_ALU IS
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
END component;
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
	---------------------------------------------------
component PWM IS
		port
		(
		Y_i,X_i: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		  MODE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		  EN : in std_logic;
		  rst :in std_logic;
		  clk : in std_logic;
		  PWMout : out std_logic );
end component;
----------------------------------------------------------
component SystemTop is
    generic (
        n : integer := 16;
        k : integer := 4;
		m : integer :=8);
    port (
        -- Inputs
        Y_i      : in  std_logic_vector(n-1 downto 0);
        X_i      : in  std_logic_vector(n-1 downto 0);
        ALUFN    : in  std_logic_vector(4 downto 0);
        ENA      : in  std_logic;
        RST      : in  std_logic;
        CLK      : in  std_logic;
        
        -- Outputs from Combinatorial Part
        ALUout   : out std_logic_vector(7 downto 0);
        V, Z, C, Neg : out std_logic;
        
        -- Output from Synchronous Part
        PWMout   : out std_logic
    );
	
end component;
--------------------------------------------------------
component FPGA_Top IS
	generic (
        n : integer := 16;
        k : integer := 4;
		m : integer :=8);
	PORT(
    CLK_50MHZ : IN std_logic;
    KEY      : IN std_logic_vector(3 downto 0);
    SW       : IN std_logic_vector(9 downto 0);

    LEDR     : OUT std_logic_vector(9 downto 0);
    HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : OUT std_logic_vector(6 downto 0);
    GPIO9     : OUT std_logic);

END component;
-----------------------------------------------------------
component PLL IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0				: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
END component;
--------------
component SevenSegDecoder IS
  PORT (data		: in STD_LOGIC_VECTOR (3 DOWNTO 0);
		seg   		: out STD_LOGIC_VECTOR (6 downto 0));
END component;





end aux_package;	


