---------------------------------------------------------------------------------------------
-- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
USE work.cond_compilation_package_pipeline.all;


package aux_package_pipeline is

	component RV32I_CORE_pipeline is
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
        BPADDR_i 						: IN STD_LOGIC_VECTOR(7 DOWNTO 0);-- Breakpoint address for SignalTap
		--Outputs 
		clkcnt_o						:OUT	STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);
		IFpc_o							:OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		IFinstruction_o			 		: OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		 IDpc_o      				    : OUT STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		IDinstruction_o				    : OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		 EXpc_o         			    : OUT STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		EXinstruction_o 				: OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		MEMpc_o         				: OUT STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		MEMinstruction_o				: OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		WBpc_o         				    : OUT STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		WBinstruction_o 				: OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		STRIGGER_o     		    		 : OUT STD_LOGIC;
		FHCNT_o         				: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		STCNT_o        				    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)	
	);				
	end component;
---------------------------------------------------------  
	component control_pipeline is
  PORT( 
		--Inputs
		instruction_i 		: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		
		--Outputs
		RegDst_ctrl_o 		: OUT 	STD_LOGIC;
		ALUSrc_ctrl_o 		: OUT 	STD_LOGIC;
		MemtoReg_ctrl_o 	: OUT 	STD_LOGIC;
		RegWrite_ctrl_o 	: OUT 	STD_LOGIC;
		MemRead_ctrl_o 		: OUT 	STD_LOGIC;
		MemWrite_ctrl_o	 	: OUT 	STD_LOGIC;
		Branch_ctrl_o 		: OUT 	STD_LOGIC;
		Jal_ctrl_o 				: OUT 	STD_LOGIC;
		Jalr_ctrl_o 			: OUT 	STD_LOGIC;
		UpperIm_ctrl_o		: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		ALUOp_ctrl_o	 		: OUT 	STD_LOGIC_VECTOR(4 DOWNTO 0);
		--Multiplier Extension:
		MULop_o  				: OUT STD_LOGIC;
		WBSrc_o  				: OUT STD_LOGIC
		);
	end component;
---------------------------------------------------------	
	component dmemory_pipeline is
		generic(
		DATA_BUS_WIDTH 	: integer := 32;
		DTCM_ADDR_WIDTH : integer := 8;
		WORDS_NUM 		: integer := 256;
		PC_WIDTH 		: integer	:= 10
	);
	PORT(	
		--Inputs
		Jalr_ctrl_i		: IN 	STD_LOGIC; --1
		Branch_or_jal_i	: IN 	STD_LOGIC; --2 
		dtcm_addr_i		: IN 	STD_LOGIC_VECTOR(DTCM_ADDR_WIDTH-1 DOWNTO 0);--3 come from alu_res_o
		dtcm_data_wr_i	: IN	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);--4 come from RF_rs2_o
		MULres_i		: IN	STD_LOGIC_VECTOR(63 DOWNTO 0);				--5	The result of the Multiplier 16-bit Stage 1.
		MULop_i 		: IN 	STD_LOGIC;									--6 Selector	
		clk_i			: IN 	STD_LOGIC;									--9	
		MemWrite_ctrl_i : IN 	STD_LOGIC;									--11 Enable
		MemRead_ctrl_i  : IN 	STD_LOGIC;									--12 Enable		
		--Outputs		
		Flush_o			: OUT 	STD_LOGIC;									--2
		dtcm_data_rd_o 	: OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);	--3	
		MULres_o		: OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0)--6	The result of the Multiplier 16-bit 										    --11 	
	);
	end component;
---------------------------------------------------------		
	component Execute_pipeline is
		generic(
		DATA_BUS_WIDTH 	: integer := 32;
		PC_WIDTH 				: integer := 10
	);
	PORT(	
		--Inputs
		pc_i						: IN 	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);			--1
		sign_extend_i 				: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);	--2 first Mux entery 1
		read_data2_i 				: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);	--3	first Mux entery 0	
		read_data1_i 				: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);	--4	second Mux entery 0
		UpperIm_ctrl_i				: IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);					--5 selector second Mux
		forward_Ain_i				: IN	STD_LOGIC_VECTOR(1 DOWNTO 0);					--6 selector UpperMUX
		wb_data_i					: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);	--7 Upper and lower MUX entery 1
		alu_res_i 					: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);	--8 Upper and lower MUX entery 2
		forward_Bin_i				: IN	STD_LOGIC_VECTOR(1 DOWNTO 0);					--9 selector Lower MUX
		ALUSrc_ctrl_i 				: IN 	STD_LOGIC;										--10 selector first Mux between read_data2 and sign_extend
		ALUOp_ctrl_i	 			: IN 	STD_LOGIC_VECTOR(4 DOWNTO 0);					--11 Selector Which OP ALU do
		Branch_ctrl_i				: IN 	STD_LOGIC;										--13 Upper entery AND gate
		Jal_ctrl_i					: IN 	STD_LOGIC;										--14 Upper entery OR gate
		MULop_i 					: IN 	STD_LOGIC;										--15 Enable Multiplier (stage 1)
		--Outputs
		addr_gen_o 					: OUT 	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0); 			--1 branch/jal target = PC + imm
		alu_res_o 					: OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);	--2 Alu result
		Branch_or_jal_o				: OUT 	STD_LOGIC; 										--3 The result of the OR Gate between jump,Branch
		MULres_o					: OUT	STD_LOGIC_VECTOR(63 DOWNTO 0);					--4	The result of the Multiplier 16-bit Stage 1.
		RF_rs2_o					: OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0)
	);
	end component;
---------------------------------------------------------		
	component Idecode_pipeline is
		generic(
		PC_WIDTH 				: integer	:= 10;
		DATA_BUS_WIDTH	: integer := 32
	);
	PORT(
		--Inputs
		clk_i						: IN 	STD_LOGIC;							     --1
		rst_i						: IN 	STD_LOGIC;								 --2
		wb_data_i				: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0); --3 entery to mux in  0. come from Stage 5
		wb_pc_plus4_i			: IN	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);			 --4 entery to mux in 1.
		RegDst_i 	: IN 	STD_LOGIC;											  --5 Selector MUX 
		instruction_i   : IN STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);		      --6
		RegWrite_ctrl_i : IN 	STD_LOGIC;											  --7 Enable Write to RF
		WriteRegister_i : IN STD_LOGIC_VECTOR(4 DOWNTO 0);							--8 To Which register need to write come form WB	
		--Outputs
		read_data1_o		: OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);--1
		read_data2_o		: OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);--2
		rs1_o			: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);--3	
	    rs2_o			: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);--4
        rd_o		: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);--5
		SignExt_o 			: OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0)--6		
	);
	end component;
---------------------------------------------------------		
	component Ifetch_pipeline is
		generic(
		WORD_GRANULARITY 	: boolean	:= False;
		DATA_BUS_WIDTH 		: integer	:= 32;
		PC_WIDTH 					: integer	:= 10;
		ITCM_ADDR_WIDTH 	: integer	:= 8;
		WORDS_NUM 				: integer	:= 256
	);
	PORT(
		--Inputs
		clk_i					: IN 	STD_LOGIC; --1
		rst_i 				: IN 	STD_LOGIC;--2
		PCwrite_i : in STD_LOGIC; -- from stall condition unit--3
		Jalr_ctrl_i		: IN 	STD_LOGIC; --lower mux takes uppermux unless jalr operation --4
		Branch_or_jal_i	: IN 	STD_LOGIC; --selector for branch control upper mux --5
		addr_gen_i 		: IN 	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0); --branch/jal target = PC + imm--6
		alu_res_i 		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0); ---- jalr target = rs1 + imm --7
		
		--Outputs TO REG IF/ID
		pc_o 					: OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0); --FROM PC TO ITCM
		pc_plus4_o 		: OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0); --FROM ADDER TO UPPER MUX
		instruction_o : OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0) --FROM ITCM TO IR
	);
	end component;
---------------------------------------------------------
	COMPONENT PLL_pipeline IS
		port(
			areset		: IN STD_LOGIC  := '0';
			inclk0		: IN STD_LOGIC  := '0';
			c0     		: OUT STD_LOGIC ;
			locked		: OUT STD_LOGIC 
		);
  END COMPONENT;
---------------------------------------------------------	
COMPONENT WriteBack_pipeline IS
	generic(
		DATA_BUS_WIDTH 	: integer := 32;
		DTCM_ADDR_WIDTH : integer := 8;
		WORDS_NUM 		: integer := 256;
		PC_WIDTH 		: integer	:= 10
	);
	PORT(
		--Inputs
		dtcm_data_rd_i : IN STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);		--1
		ALUres_i		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);	--2
		MULres_i		: IN	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);	--3	The result of the Multiplier 16-bit 
		MemtoReg_ctrl_i	: IN 	STD_LOGIC;										--7 Selector between second Mux to read data
		WBSrc_i			: IN 	STD_LOGIC;										--8 Selector between ALUres to MULres	
		--Outputs
		wb_data_o		: OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0) 	--1
	);
END COMPONENT;
-------------------
COMPONENT Forwarding_unit IS
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
END COMPONENT;

COMPONENT Stall_cond_unit IS
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
END COMPONENT;
-------------------------------------------------------------------

end aux_package_pipeline;


