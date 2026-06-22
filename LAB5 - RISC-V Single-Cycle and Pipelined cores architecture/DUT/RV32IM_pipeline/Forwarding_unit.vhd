LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE work.const_package_pipeline.all;
---------------------------------------

ENTITY Forwarding_unit IS
	generic(
		PC_WIDTH 				: integer	:= 10;
		DATA_BUS_WIDTH			: integer := 32
	);
	PORT(
	ExMem_rd_i			    : in STD_LOGIC_VECTOR(4 DOWNTO 0);
	ExMem_RegWrite_i	    : in std_logic;
	MemWB_rd_i				: in STD_LOGIC_VECTOR(4 DOWNTO 0);
	MEM_WB_RegWrite_i 		: in std_logic;
	IDEX_rs1_i				: in STD_LOGIC_VECTOR(4 DOWNTO 0);
	IDEX_rs2_i				: in STD_LOGIC_VECTOR(4 DOWNTO 0);
	--output:
	forward_Ain_o			: out STD_LOGIC_VECTOR(1 DOWNTO 0);
	forward_Bin_o			: out STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END Forwarding_unit;
--------------------------------------------------------------------------
ARCHITECTURE behavior OF Forwarding_unit IS

	BEGIN
	
	PROCESS(ExMem_rd_i, ExMem_RegWrite_i, MemWB_rd_i, MEM_WB_RegWrite_i, IDEX_rs1_i, IDEX_rs2_i)
		BEGIN
		 -- Default: no forwarding
        forward_Ain_o <= "00";
        forward_Bin_o <= "00";
		
		-------------------------------------------------
        -- Forwarding for ALU input A = rs1
        --------------------------------------------------

        -- EX hazard:
        -- instruction in EX needs rs1,
        -- and previous instruction in MEM is going to write it
        IF (ExMem_RegWrite_i = '1') AND
           (ExMem_rd_i /= "00000") AND
           (ExMem_rd_i = IDEX_rs1_i) THEN

            forward_Ain_o <= "10";

        -- MEM hazard:
        -- instruction in EX needs rs1,
        -- and instruction in WB is going to write it
        ELSIF (MEM_WB_RegWrite_i = '1') AND
              (MemWB_rd_i /= "00000") AND
              (MemWB_rd_i = IDEX_rs1_i) THEN

            forward_Ain_o <= "01";
        END IF;


        --------------------------------------------------
        -- Forwarding for ALU input B = rs2
        --------------------------------------------------

        -- EX hazard
        IF (ExMem_RegWrite_i = '1') AND
           (ExMem_rd_i /= "00000") AND
           (ExMem_rd_i = IDEX_rs2_i) THEN

            forward_Bin_o <= "10";

        -- MEM hazard
        ELSIF (MEM_WB_RegWrite_i = '1') AND
              (MemWB_rd_i /= "00000") AND
              (MemWB_rd_i = IDEX_rs2_i) THEN

            forward_Bin_o <= "01";
        END IF;

    END PROCESS;

END behavior;




	