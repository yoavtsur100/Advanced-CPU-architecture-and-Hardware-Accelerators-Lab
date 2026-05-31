LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
------------------------------------
entity SystemTop is
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
end SystemTop;
-------------------------------------------------------------------------
architecture tp of SystemTop is
	signal y_PWM , x_PWM : STD_LOGIC_VECTOR (n-1 DOWNTO 0); 
	signal ena_PWM : std_logic;
	begin
	
	
-----The AND gate from the schematic (zero vector if not match or same vector)	
	with ALUFN (4 downto 3) select
			x_PWM <= X_i       when "00",
					(others => '0') when others;

	with ALUFN (4 downto 3) select
			y_PWM <= Y_i       when "00",
					(others => '0') when others;
	
	with ALUFN (4 downto 3) select
			ena_PWM <= ENA       when "00",
					'0' when others;	
---------------------------------------------
--if we need to ALU operaition X and Y send as they ,
-- in the ALU top the AND GATE relevant will be USE.
--if we need to do PWM operaition X and Y send after the and Gate.
---------------------------------------------

    --First Part:
    ALU_Part : top_ALU generic map (n => 8, k => 3 , m =>4) port map (Y_i=> Y_i(7 DOWNTO 0),X_i => X_i(7 DOWNTO 0), ALUFN_i  => ALUFN, ALUout_o => ALUout,
															Nflag_o  => Neg, Cflag_o  => C, Zflag_o  => Z, Vflag_o  => V );

	--Second Part:
    PWM_Part : PWM port map (Y_i=> y_PWM,X_i => x_PWM, MODE=> ALUFN(2 downto 0), EN => ena_PWM, rst=> RST, clk => CLK, PWMout => PWMout);
	
end tp;