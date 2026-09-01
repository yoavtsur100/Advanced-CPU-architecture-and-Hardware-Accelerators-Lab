--------------------------------------------------------------------------------------------
-- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
--------------------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
USE work.cond_compilation_package.all;


package aux_package is

	COMPONENT RV32IMscMCU IS
	generic( 
			WORD_GRANULARITY 	: boolean 	:= G_WORD_GRANULARITY;
	    MODELSIM 					: integer 	:= G_MODELSIM;
			DATA_BUS_WIDTH 		: integer 	:= 32;
			ITCM_ADDR_WIDTH 	: integer 	:= G_ADDRWIDTH;
			DTCM_ADDR_WIDTH 	: integer 	:= G_ADDRWIDTH;
			PC_WIDTH 					: integer 	:= G_PC_WIDTH;
			MA_WIDTH 					: integer 	:= G_MA_WIDTH;
			DATA_WORDS_NUM 		: integer 	:= G_DATA_WORDSNUM;
			CLK_CNT_WIDTH 		: integer 	:= 16
	);
	PORT(	
		--Inputs
		rst_i		 					:IN	STD_LOGIC;
		clk_i							:IN	STD_LOGIC;
		divclk_i						:IN	STD_LOGIC;
		--maybe another reset for Sync and DIv!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		
		
		
		--Outputs (used also for Signal-Tap auxiliary pins)
		pc_o							:OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		instruction_o			:OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		
		RegWrite_ctrl_o		:OUT 	STD_LOGIC;
		MemWrite_ctrl_o		:OUT 	STD_LOGIC;
		Branch_ctrl_o			:OUT 	STD_LOGIC;
		MemRead_ctrl_o          :OUT    STD_LOGIC;
		
		read_data1_o 			:OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		read_data2_o 			:OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		write_data_o			:OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		
		alu_res_o 				:OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);															
		brTaken_o					:OUT 	STD_LOGIC; 
		
		dtcm_addr_o				:OUT 	STD_LOGIC_VECTOR(DTCM_ADDR_WIDTH-1 DOWNTO 0);
		dtcm_data_wr_o		:OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		dtcm_data_rd_o		:OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		
		mclk_cnt_o				:OUT	STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);
		mclk_o                  :OUT    STD_LOGIC;
		
		-- Interrupt and BUS Extensions:
		INTR_i              : IN    STD_LOGIC;
		INTA_o              : OUT   STD_LOGIC;
		GIE_o               : OUT   STD_LOGIC;
		DataBUS             : INOUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0)
	);		
END COMPONENT;

---------------------------------------------------------
COMPONENT GPIO_peripherals is
    port (
        clk_i         : in    std_logic;
        rst_i         : in    std_logic;    
       
        addr_i        : in    std_logic_vector(13 downto 0); 
        mem_write_i   : in    std_logic;                     
        mem_read_i    : in    std_logic;                     
        DataBUS       : inout std_logic_vector(31 downto 0);          
        SW_pins_i     : in    std_logic_vector(7 downto 0);
        LEDR_pins_o   : out   std_logic_vector(7 downto 0);
        HEX0_pins_o   : out   std_logic_vector(6 downto 0);
        HEX1_pins_o   : out   std_logic_vector(6 downto 0);
        HEX2_pins_o   : out   std_logic_vector(6 downto 0);
        HEX3_pins_o   : out   std_logic_vector(6 downto 0);
        HEX4_pins_o   : out   std_logic_vector(6 downto 0);
        HEX5_pins_o   : out   std_logic_vector(6 downto 0)
    );
end COMPONENT;
---------------------------------------------------------  
	component control IS
  PORT( 
		--Inputs
		clk_i               : IN    STD_LOGIC;
		rst_i               : IN    STD_LOGIC;
		instruction_i 		: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		DIVbusy_i			: In STD_LOGIC;
		--Outputs
		PChold_ctrl_o 		: OUT 	STD_LOGIC;
		RegDst_ctrl_o 		: OUT 	STD_LOGIC;
		ALUSrc_ctrl_o 		: OUT 	STD_LOGIC;
		MemtoReg_ctrl_o 	: OUT 	STD_LOGIC;
		RegWrite_ctrl_o 	: OUT 	STD_LOGIC;
		MemRead_ctrl_o 		: OUT 	STD_LOGIC;
		MemWrite_ctrl_o	 	: OUT 	STD_LOGIC;
		Branch_ctrl_o 		: OUT 	STD_LOGIC;
		Jal_ctrl_o 			: OUT 	STD_LOGIC;
		Jalr_ctrl_o 		: OUT 	STD_LOGIC;
		UpperIm_ctrl_o		: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		ALUOp_ctrl_o	 	: OUT 	STD_LOGIC_VECTOR(4 DOWNTO 0);
		
		--Multiplier Extension:
		MULop_o  			: OUT STD_LOGIC;
		DIVctrl_o			: OUT STD_LOGIC;
		WBSrc0_o  			: OUT STD_LOGIC;
		WBSrc1_o			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		
		-- Interrupt Extension:
		INTR_i              : IN  STD_LOGIC;
		INTA_o              : OUT STD_LOGIC;
		ClearGIE_ctrl_o     : OUT STD_LOGIC;
		SetGIE_ctrl_o       : OUT STD_LOGIC;
		WriteTP_ctrl_o      : OUT STD_LOGIC;
		SelectTypeAddr_ctrl_o : OUT STD_LOGIC;
		IntJump_ctrl_o      : OUT STD_LOGIC;
		IntAccept_ctrl_o    : OUT STD_LOGIC
		);
END component;
---------------------------------------------------------	
	component dmemory is
		generic(
			DATA_BUS_WIDTH 	: integer := 32;
			DTCM_ADDR_WIDTH : integer := 8;
			WORDS_NUM 			: integer := 256
		);
		PORT(	
			--Inputs
			clk_i						: IN 	STD_LOGIC;
			rst_i						: IN 	STD_LOGIC;
			dtcm_addr_i 		: IN 	STD_LOGIC_VECTOR(DTCM_ADDR_WIDTH-1 DOWNTO 0);
			dtcm_data_wr_i 	: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			MemRead_ctrl_i  : IN 	STD_LOGIC;
			MemWrite_ctrl_i : IN 	STD_LOGIC;
			
			--Outputs
			dtcm_data_rd_o 	: OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0)
		);
	end component;
---------------------------------------------------------		
	component  Execute IS
	generic(
		DATA_BUS_WIDTH 	: integer := 32;
		PC_WIDTH 				: integer := 10
	);
	PORT(	
		--Inputs
		clk_i               : IN    STD_LOGIC; -- MCLK
		read_data1_i 		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		read_data2_i 		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		sign_extend_i 	: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		UpperIm_ctrl_i	: IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		ALUOp_ctrl_i	 	: IN 	STD_LOGIC_VECTOR(4 DOWNTO 0);
		ALUSrc_ctrl_i 	: IN 	STD_LOGIC;
		pc_i						: IN 	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		
			--Multiplier Extension:
		divclk_i					: IN 	STD_LOGIC;	
		MULop_i 		: IN 	STD_LOGIC;
		Div_ctrl_i		: IN 	STD_LOGIC;
		WBSrc0_i 		: IN 	STD_LOGIC;
		WBSrc1_i		: IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		rst_i			: IN 	STD_LOGIC;	
		--Outputs
		brTaken_o 			: OUT	STD_LOGIC;
		alu_res_o 			: OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		addr_gen_o 			: OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		Divbusy_o			: OUT	STD_LOGIC
	);
END component;
---------------------------------------------------------		
	component Idecode is
		generic(
			PC_WIDTH 				: integer	:= 10;
			DATA_BUS_WIDTH	: integer := 32
		);
		PORT(
			--Inputs
			clk_i						: IN 	STD_LOGIC;
			rst_i						: IN 	STD_LOGIC;
			pc_plus4_i			: IN	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			instruction_i 	: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			dtcm_data_rd_i 	: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			alu_res_i				: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			RegDst_ctrl_i 	: IN 	STD_LOGIC;
			RegWrite_ctrl_i : IN 	STD_LOGIC;
			MemtoReg_ctrl_i : IN 	STD_LOGIC;
			ClearGIE_ctrl_i : IN 	STD_LOGIC;
			SetGIE_ctrl_i   : IN 	STD_LOGIC;
			WriteTP_ctrl_i  : IN 	STD_LOGIC;
			
			--Outputs
			read_data1_o		: OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			read_data2_o		: OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			SignExt_o 			: OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			GIE_o               : OUT   STD_LOGIC
		);
	end component;
---------------------------------------------------------		
	component Ifetch IS
	generic(
		WORD_GRANULARITY 	: boolean	:= False;
		DATA_BUS_WIDTH 		: integer	:= 32;
		PC_WIDTH 					: integer	:= 10;
		ITCM_ADDR_WIDTH 	: integer	:= 8;
		WORDS_NUM 				: integer	:= 256
	);
	PORT(
		--Inputs
		clk_i					: IN 	STD_LOGIC;
		rst_i 				: IN 	STD_LOGIC;
		addr_gen_i 		: IN 	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		Branch_ctrl_i	: IN 	STD_LOGIC;
		brTaken_i 		: IN 	STD_LOGIC;
		Jal_ctrl_i		: IN 	STD_LOGIC;
		Jalr_ctrl_i		: IN 	STD_LOGIC;
		alu_res_i 		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		PChold_i		: IN 	STD_LOGIC;
		IntAccept_ctrl_i : IN   STD_LOGIC;
		WriteTP_ctrl_i   : IN   STD_LOGIC;
		
		--Outputs
		pc_o 					: OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		pc_plus4_o 		: OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		instruction_o : OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0)
	);
END component;
---------------------------------------------------------
	COMPONENT PLL IS
		port(
			areset		: IN STD_LOGIC  := '0';
			inclk0		: IN STD_LOGIC  := '0';
			c0     		: OUT STD_LOGIC ;
			locked		: OUT STD_LOGIC 
		);
  END COMPONENT;
---------------------------------------------------------	
COMPONENT multiplier_16bit IS
    PORT(
        rs1_i      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        rs2_i      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		mulOP_i    : in STD_LOGIC;
        rd_o : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END COMPONENT;

-------------------
COMPONENT Divider_32bit IS
    GENERIC (
        N : INTEGER := 32
    );
    PORT (
        DIVCLK_i    : IN  STD_LOGIC;
        DIVRST_i    : IN  STD_LOGIC;
        DIVENA_i    : IN  STD_LOGIC;

        DIVIDEND_i  : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        DIVISOR_i   : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);

        DIVBUSY_o   : OUT STD_LOGIC;
        QUOTIENT_o  : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        RESIDUE_o   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
    );
END COMPONENT;
-----------------------
COMPONENT Sync is 
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
end COMPONENT;
--------------------------------
COMPONENT BidirPin is
	generic( width: integer:=16 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
end COMPONENT;
---------------------------------
COMPONENT SevenSegDecoder IS
 
  PORT (data		: in STD_LOGIC_VECTOR (3 DOWNTO 0);
		seg   		: out STD_LOGIC_VECTOR (6 downto 0));
END COMPONENT;
-----------------------------------
COMPONENT InterruptController IS
    PORT (
        clk_i         : IN STD_LOGIC;
        rst_i         : IN STD_LOGIC;
        addr_i        : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
        mem_write_i   : IN STD_LOGIC;
        mem_read_i    : IN STD_LOGIC;
        KEY_pins_i    : IN STD_LOGIC_VECTOR(3 DOWNTO 1);
        BTIFG_i       : IN STD_LOGIC;
        INTR_o        : OUT STD_LOGIC;
        INTA_i        : IN STD_LOGIC;
        GIE_i         : IN STD_LOGIC;
        DataBUS       : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END COMPONENT;
-----------------------------------
COMPONENT BasicTimer IS
    PORT(
        clk_i         : IN    STD_LOGIC;
        rst_i         : IN    STD_LOGIC;
        addr_i        : IN    STD_LOGIC_VECTOR(13 DOWNTO 0);
        mem_write_i   : IN    STD_LOGIC;
        mem_read_i    : IN    STD_LOGIC;
        DataBUS       : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        CAPIN1_i      : IN    STD_LOGIC;
        CAPIN2_i      : IN    STD_LOGIC;
        BTIFG_o       : OUT   STD_LOGIC;
        PWMout_o      : OUT   STD_LOGIC
    );
END COMPONENT;
-----------------------------------
COMPONENT FPGA_Top_SingleCycle IS
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
END COMPONENT;

end aux_package;


