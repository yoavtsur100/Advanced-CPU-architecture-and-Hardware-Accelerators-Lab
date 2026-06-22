LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.cond_compilation_package.ALL;
USE work.aux_package.ALL;
--------------------------------------------------------------

ENTITY FPGA_Top_SingleCycle IS
    GENERIC (
        WORD_GRANULARITY : boolean := G_WORD_GRANULARITY;
        DATA_BUS_WIDTH   : integer := 32;
        ITCM_ADDR_WIDTH  : integer := G_ADDRWIDTH;
        DTCM_ADDR_WIDTH  : integer := G_ADDRWIDTH;
        PC_WIDTH         : integer := G_PC_WIDTH;
        MA_WIDTH         : integer := G_MA_WIDTH;
        DATA_WORDS_NUM   : integer := G_DATA_WORDSNUM;
        CLK_CNT_WIDTH    : integer := 16
    );
    PORT (
        CLOCK_50 : IN  STD_LOGIC;
        SW0      : IN  STD_LOGIC;

        pc_o             : OUT STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
        instruction_o    : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);

        RegWrite_ctrl_o  : OUT STD_LOGIC;
        MemWrite_ctrl_o  : OUT STD_LOGIC;
        Branch_ctrl_o    : OUT STD_LOGIC;

        read_data1_o     : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        read_data2_o     : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        write_data_o     : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);

        alu_res_o        : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        brTaken_o        : OUT STD_LOGIC;

        dtcm_addr_o      : OUT STD_LOGIC_VECTOR(DTCM_ADDR_WIDTH-1 DOWNTO 0);
        dtcm_data_wr_o   : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        dtcm_data_rd_o   : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);

        mclk_cnt_o       : OUT STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0)
    );
END FPGA_Top_SingleCycle;
-------------------------------------------------------------------------------

ARCHITECTURE tp_sc OF FPGA_Top_SingleCycle IS

BEGIN

    CORE : RV32I_CORE
        GENERIC MAP (
            WORD_GRANULARITY => WORD_GRANULARITY,
            MODELSIM         => G_MODELSIM,  -- FPGA / Quartus mode, activates PLL inside RV32I_CORE
            DATA_BUS_WIDTH   => DATA_BUS_WIDTH,
            ITCM_ADDR_WIDTH  => ITCM_ADDR_WIDTH,
            DTCM_ADDR_WIDTH  => DTCM_ADDR_WIDTH,
            PC_WIDTH         => PC_WIDTH,
            MA_WIDTH         => MA_WIDTH,
            DATA_WORDS_NUM   => DATA_WORDS_NUM,
            CLK_CNT_WIDTH    => CLK_CNT_WIDTH
        )
        PORT MAP (
            rst_i            => SW0,
            clk_i            => CLOCK_50,

            pc_o             => pc_o,
            instruction_o    => instruction_o,

            RegWrite_ctrl_o  => RegWrite_ctrl_o,
            MemWrite_ctrl_o  => MemWrite_ctrl_o,
            Branch_ctrl_o    => Branch_ctrl_o,

            read_data1_o     => read_data1_o,
            read_data2_o     => read_data2_o,
            write_data_o     => write_data_o,

            alu_res_o        => alu_res_o,
            brTaken_o        => brTaken_o,

            dtcm_addr_o      => dtcm_addr_o,
            dtcm_data_wr_o   => dtcm_data_wr_o,
            dtcm_data_rd_o   => dtcm_data_rd_o,

            mclk_cnt_o       => mclk_cnt_o
        );

END tp_sc;