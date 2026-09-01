LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.aux_package.all;
-----------------------------------------------
ENTITY multiplier_16bit IS
    PORT(
        rs1_i      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        rs2_i      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		mulOP_i    : in STD_LOGIC;
        rd_o : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END multiplier_16bit;
-----------------------------------------------------------------------------------
ARCHITECTURE mul OF multiplier_16bit IS
    SIGNAL A_low, A_high   : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL B_low, B_high   : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL P0, P1, P2, P3  : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL M               : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal result 		   : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
	--From Lab 5 Algoritem:
	--16 bit MUL calculate.
	with mulOP_i select
	rd_o <= result WHEN '1',
			(others =>'0') when others;

   --8 bit:
    A_low  <= rs2_i(7 DOWNTO 0);
    A_high <= rs2_i(15 DOWNTO 8);
    B_low  <= rs1_i(7 DOWNTO 0);
    B_high <= rs1_i(15 DOWNTO 8);

    --Stage 1:
    P0 <= A_low  * B_low;
    P1 <= A_low  * B_high;
    P2 <= A_high * B_low;
    P3 <= A_high * B_high;

    -- Stage 2:
    M <= P1 + P2;
	
	--Padding+SHL:
    result <= (x"0000" & P0) + (x"00" & M & x"00") + (P3 & x"0000");
END mul;