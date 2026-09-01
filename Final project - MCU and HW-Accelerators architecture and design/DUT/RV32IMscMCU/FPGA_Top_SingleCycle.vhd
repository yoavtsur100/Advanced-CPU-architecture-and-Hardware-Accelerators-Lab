LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.cond_compilation_package.ALL;
USE work.aux_package.ALL;

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
        KEY      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0); -- KEY0 is System Reset (active-low)
        SW       : IN  STD_LOGIC_VECTOR(9 DOWNTO 0); -- SW7-SW0 are switches
        LEDR     : OUT STD_LOGIC_VECTOR(9 DOWNTO 0); -- LEDR7-LEDR0 are LEDs, LEDR9-8 are unused for now
        HEX0     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        HEX1     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        HEX2     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        HEX3     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        HEX4     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        HEX5     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        GPIO     : INOUT STD_LOGIC_VECTOR(39 DOWNTO 0) := (OTHERS => '0');

        -- Verification outputs (retaining original outputs for tb compatibility)
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

ARCHITECTURE tp_sc OF FPGA_Top_SingleCycle IS

    -- Internal Signals
    SIGNAL rst_w               : STD_LOGIC;
    SIGNAL key0_pressed_seen_q : STD_LOGIC := '0';
    SIGNAL rst_req_w           : STD_LOGIC;
    SIGNAL rst_sync_reg        : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '1');
    SIGNAL DataBUS_w           : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    SIGNAL mclk_w              : STD_LOGIC;
    SIGNAL accelclk_w          : STD_LOGIC;
    SIGNAL smclk_w             : STD_LOGIC;
    
    SIGNAL INTR_w              : STD_LOGIC := '0';
    SIGNAL INTA_w              : STD_LOGIC;
    SIGNAL gie_w               : STD_LOGIC;
    SIGNAL mem_write_w         : STD_LOGIC;
    SIGNAL mem_read_w          : STD_LOGIC;
    SIGNAL dtcm_addr_internal_w: STD_LOGIC_VECTOR(DTCM_ADDR_WIDTH-1 DOWNTO 0);
    SIGNAL dtcm_data_rd_internal_w: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    SIGNAL dtcm_data_wr_internal_w: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    SIGNAL alu_res_internal_w  : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    
    SIGNAL mclk_clk_w          : STD_LOGIC;
    SIGNAL smclk_clk_w         : STD_LOGIC;

    -- Basic Timer Signals
    SIGNAL btifg_w             : STD_LOGIC;
    SIGNAL pwmout_w            : STD_LOGIC;

BEGIN

    -- Reset Latching & Synchronization process 
    -- Remember if KEY0  has been pressed at least once
    process(mclk_clk_w)
    begin
        if rising_edge(mclk_clk_w) then
            if KEY(0) = '0' then
                key0_pressed_seen_q <= '1';
            end if;
        end if;
    end process;

    -- Reset request:  reset is asserted on startup until KEY0 is pressed once or if KEY0 is currently being pressed.
    rst_req_w <= '1' WHEN (key0_pressed_seen_q = '0') OR (KEY(0) = '0') ELSE '0';

    -- Synchronize reset request to mclk_clk_w to prevent metastability
    process(mclk_clk_w)
    begin
        if rising_edge(mclk_clk_w) then
            rst_sync_reg <= rst_sync_reg(0) & rst_req_w;
        end if;
    end process;

    rst_w <= rst_sync_reg(1);
    
    -- Clock Tree  (3 separate PLLs from one pll unit in the FPGA for CPU, Peripherals, and Divider clock domains)
    G_PLL_HW: if G_MODELSIM = 0 generate
        -- PLL for CPU clock (MCLK)
        MCLK_PLL : entity work.PLL_mclk
            PORT MAP (
                inclk0 => CLOCK_50,
                c0     => mclk_w
            );
        -- PLL for Peripheral clock (SMCLK)
        SMCLK_PLL : entity work.PLL_smclk
            PORT MAP (
                inclk0 => CLOCK_50,
                c0     => smclk_w
            );
        -- PLL for Divider Accelerator clock (DIVCLK)
        DIVCLK_PLL : entity work.PLL_divclk
            PORT MAP (
                inclk0 => CLOCK_50,
                c0     => accelclk_w
            );
    end generate;

    G_PLL_SIM: if G_MODELSIM = 1 generate
        mclk_w     <= CLOCK_50;
        smclk_w    <= CLOCK_50;
        accelclk_w <= CLOCK_50;
    end generate;

    -- Clock selection to prevent VHDL delta-cycle simulation hazards
    mclk_clk_w  <= CLOCK_50 WHEN G_MODELSIM = 1 ELSE mclk_w;
    smclk_clk_w <= CLOCK_50 WHEN G_MODELSIM = 1 ELSE smclk_w;

    -- MCU Core instance
    CORE_inst : RV32IMscMCU
        GENERIC MAP (
            WORD_GRANULARITY => WORD_GRANULARITY,
            MODELSIM         => G_MODELSIM,
            DATA_BUS_WIDTH   => DATA_BUS_WIDTH,
            ITCM_ADDR_WIDTH  => ITCM_ADDR_WIDTH,
            DTCM_ADDR_WIDTH  => DTCM_ADDR_WIDTH,
            PC_WIDTH         => PC_WIDTH,
            MA_WIDTH         => MA_WIDTH,
            DATA_WORDS_NUM   => DATA_WORDS_NUM,
            CLK_CNT_WIDTH    => CLK_CNT_WIDTH
        )
        PORT MAP (
            rst_i            => rst_w,
            clk_i            => mclk_clk_w,
            divclk_i         => accelclk_w,
            
            pc_o             => pc_o,
            instruction_o    => instruction_o,

            RegWrite_ctrl_o  => RegWrite_ctrl_o,
            MemWrite_ctrl_o  => mem_write_w,
            Branch_ctrl_o    => Branch_ctrl_o,
            MemRead_ctrl_o   => mem_read_w,

            read_data1_o     => read_data1_o,
            read_data2_o     => read_data2_o,
            write_data_o     => write_data_o,

            alu_res_o        => alu_res_internal_w,
            brTaken_o        => brTaken_o,

            dtcm_addr_o      => dtcm_addr_internal_w,
            dtcm_data_wr_o   => dtcm_data_wr_internal_w,
            dtcm_data_rd_o   => dtcm_data_rd_internal_w,

            mclk_cnt_o       => mclk_cnt_o,
            mclk_o           => open,
            
            INTR_i           => INTR_w, 
            INTA_o           => INTA_w,
            GIE_o            => gie_w,
            DataBUS          => DataBUS_w
        );

    -- GPIO Peripherals instance
    GPIO_inst : GPIO_peripherals
        PORT MAP (
            clk_i            => smclk_clk_w,
            rst_i            => rst_w,
            addr_i           => alu_res_internal_w(13 downto 0),
            mem_write_i      => mem_write_w,
            mem_read_i       => mem_read_w,
            DataBUS          => DataBUS_w,
            SW_pins_i        => SW(7 DOWNTO 0),
            LEDR_pins_o      => LEDR(7 DOWNTO 0),
            HEX0_pins_o      => HEX0,
            HEX1_pins_o      => HEX1,
            HEX2_pins_o      => HEX2,
            HEX3_pins_o      => HEX3,
            HEX4_pins_o      => HEX4,
            HEX5_pins_o      => HEX5
        );

    INTC_inst : InterruptController
        PORT MAP (
            clk_i            => smclk_clk_w,
            rst_i            => rst_w,
            addr_i           => alu_res_internal_w(13 downto 0),
            mem_write_i      => mem_write_w,
            mem_read_i       => mem_read_w,
            
            KEY_pins_i       => KEY(3 DOWNTO 1),
            BTIFG_i          => btifg_w,
            
            INTR_o           => INTR_w,
            INTA_i           => INTA_w,
            GIE_i            => gie_w,
            
            DataBUS          => DataBUS_w
        );

    Timer_inst : BasicTimer
        PORT MAP (
            clk_i            => smclk_clk_w,
            rst_i            => rst_w,
            addr_i           => alu_res_internal_w(13 downto 0),
            mem_write_i      => mem_write_w,
            mem_read_i       => mem_read_w,
            DataBUS          => DataBUS_w,
            CAPIN1_i         => GPIO(0),
            CAPIN2_i         => GPIO(1),
            BTIFG_o          => btifg_w,
            PWMout_o         => pwmout_w
        );
    -- Tie unused LEDs to 0
    LEDR(9 DOWNTO 8) <= (others => '0');
	
    -- Drive PWM signal onto GPIO(9) for oscilloscope measurement
    GPIO(9) <= pwmout_w;

    -- Forward verification ports
    MemWrite_ctrl_o <= mem_write_w;
    alu_res_o       <= alu_res_internal_w;
    dtcm_addr_o     <= dtcm_addr_internal_w;
    dtcm_data_wr_o  <= dtcm_data_wr_internal_w;
    dtcm_data_rd_o  <= dtcm_data_rd_internal_w;

END tp_sc;