LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE work.const_package.all;
USE work.aux_package.all;
-----------------------------------
ENTITY Sync is
	GENERIC (
        DATA_BUS_WIDTH : INTEGER := 32
    );
	PORT(	
		Ain_i	: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		Bin_i	: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		divclk_i : in std_logic;
		DIVRST_i	: in std_logic;	
		Ain_o	: out 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		Bin_o	: out 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0)
		);
end sync;
------------------------------------
ARCHITECTURE sy OF Sync IS
	signal Ain_q1 :STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	signal Bin_q1 : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	signal Ain_q2 : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	signal Bin_q2 : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	
	--CDC of 2 clocks use by 2 reg each input:
	begin
	PROCESS(divclk_i, DIVRST_i)
    BEGIN
        IF DIVRST_i = '1' THEN
             Ain_q1<= (OTHERS => '0');
             Bin_q1<= (OTHERS => '0');
			 Ain_q2<= (OTHERS => '0');
             Bin_q2<= (OTHERS => '0');
        ELSIF rising_edge(divclk_i) THEN
			Ain_q2 <= Ain_q1;
            Ain_q1 <= Ain_i	;
			Bin_q2 <= Bin_q1;
            Bin_q1 <= Bin_i	;			
        END IF;
    END PROCESS;
	
	Ain_o <= Ain_q2;
	Bin_o <= Bin_q2;

end sy;		