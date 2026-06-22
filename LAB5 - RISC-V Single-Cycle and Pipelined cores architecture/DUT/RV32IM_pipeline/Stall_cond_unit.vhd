LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE work.const_package_pipeline.all;
USE work.aux_package_pipeline.all;
------------------------------------------------------
ENTITY Stall_cond_unit IS
    PORT (
        -- instruction currently in IF/ID
        IFID_instruction_i : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- info from ID/EX stage
        IDEX_rd_i          : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
        IDEX_MemRead_i     : IN  STD_LOGIC;--load op

        -- outputs
        stall_o            : OUT STD_LOGIC;
        PCwrite_o          : OUT STD_LOGIC;
        IFID_write_o       : OUT STD_LOGIC
    );
END Stall_cond_unit;

ARCHITECTURE behave OF Stall_cond_unit IS

    SIGNAL IFID_rs1_w        : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL IFID_rs2_w        : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL load_use_hazard_w : STD_LOGIC;

BEGIN

    -- Extract rs1/rs2 from instruction in IF/ID
    IFID_rs1_w <= IFID_instruction_i(19 DOWNTO 15);
    IFID_rs2_w <= IFID_instruction_i(24 DOWNTO 20);

    -- Detect load-use hazard
    load_use_hazard_w <= '1' WHEN
        IDEX_MemRead_i = '1' AND
        IDEX_rd_i /= "00000" AND
        (
            IDEX_rd_i = IFID_rs1_w OR
            IDEX_rd_i = IFID_rs2_w
        )
    ELSE '0';

    -- Outputs
    stall_o      <= load_use_hazard_w;

    PCwrite_o    <= '0' WHEN load_use_hazard_w = '1' ELSE '1';

    IFID_write_o <= '0' WHEN load_use_hazard_w = '1' ELSE '1';

END behave;