
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE work.cond_compilation_package_pipeline.all;
USE work.aux_package_pipeline.all;

-------------------------------------------------------------------
ENTITY RV32I_CORE_pipeline IS
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
END RV32I_CORE_pipeline;


--============================================================================
ARCHITECTURE structure OF RV32I_CORE_pipeline IS
	  constant NOP_INSTRUCTION : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0) := (others => '0');
	  signal mclk_w :STD_LOGIC;
	  signal rst_sync_mclk : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '1');
	  signal mclk_cnt_q : STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);
	  signal stl_cnt_q : STD_LOGIC_VECTOR(7 DOWNTO 0);
	  signal fhl_cnt_q : STD_LOGIC_VECTOR(7 DOWNTO 0);
	  signal STRIGGER_w : STD_LOGIC;
	  signal dtcm_addr_w : STD_LOGIC_VECTOR(DTCM_ADDR_WIDTH-1 DOWNTO 0);
	  signal PCwrite_w_muxed : STD_LOGIC;
		 --------------------------------------------------------------------
    -- IF stage signals
    --------------------------------------------------------------------
    signal IF_pc_w          : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
    signal IF_pc_next_w     : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
    signal IF_instruction_w : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    --------------------------------------------------------------------
    -- IF/ID pipeline register signals
    --------------------------------------------------------------------
    signal IFID_pc_q          : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
    signal IFID_instruction_q : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	signal IFID_pc_plus4_q 	    	:STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
 --------------------------------------------------------------------
    -- ID stage signals
    --------------------------------------------------------------------
    signal ID_rs1_w : STD_LOGIC_VECTOR(4 DOWNTO 0);
    signal ID_rs2_w : STD_LOGIC_VECTOR(4 DOWNTO 0);
    signal ID_rd_w  : STD_LOGIC_VECTOR(4 DOWNTO 0);
    signal ID_read_data1_w : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal ID_read_data2_w : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal ID_imm_w        : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	signal ID_pc_w				:STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	signal ID_pc_plus4_w		:STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
    --------------------------------------------------------------------
    -- Control signals from Control Unit
    --------------------------------------------------------------------
	signal WBSrc_w				: STD_LOGIC;
	signal MULop_w				: STD_LOGIC;
	SIGNAL alu_src_w 			: STD_LOGIC;
	SIGNAL branch_w 			: STD_LOGIC;
	SIGNAL Jal_ctrl_w 			: STD_LOGIC;
	SIGNAL Jalr_ctrl_w 			: STD_LOGIC;
	SIGNAL reg_write_w 			: STD_LOGIC;
	SIGNAL reg_dst_w 			: STD_LOGIC;
	SIGNAL mem_write_w 			: STD_LOGIC;
	SIGNAL MemtoReg_w 			: STD_LOGIC;
	SIGNAL mem_read_w 			: STD_LOGIC;
	SIGNAL upper_im_w			: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL alu_op_w 			: STD_LOGIC_VECTOR(4 DOWNTO 0);
    --------------------------------------------------------------------
    -- Control signals after Stall mux
    -- These are the actual control signals entering ID/EX
    --------------------------------------------------------------------
    signal IDEX_WBSrc_w				: STD_LOGIC;
	signal IDEX_MULop_w				: STD_LOGIC;
	SIGNAL IDEX_alu_src_w 			: STD_LOGIC;
	SIGNAL IDEX_branch_w 			: STD_LOGIC;
	SIGNAL IDEX_Jal_ctrl_w 			: STD_LOGIC;
	SIGNAL IDEX_Jalr_ctrl_w 		: STD_LOGIC;
	SIGNAL IDEX_reg_write_w 		: STD_LOGIC;
	SIGNAL IDEX_reg_dst_w 			: STD_LOGIC;
	SIGNAL IDEX_mem_write_w 		: STD_LOGIC;
	SIGNAL IDEX_MemtoReg_w 			: STD_LOGIC;
	SIGNAL IDEX_mem_read_w 			: STD_LOGIC;
	SIGNAL IDEX_upper_im_w			: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL IDEX_alu_op_w 			: STD_LOGIC_VECTOR(4 DOWNTO 0);
    --------------------------------------------------------------------
    -- ID/EX pipeline register signals
    --------------------------------------------------------------------
    signal IDEX_pc_q          : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	signal IDEX_pc_plus4_q          : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
    signal IDEX_instruction_q : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal IDEX_read_data1_q : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal IDEX_read_data2_q : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal IDEX_imm_q        : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal IDEX_rs1_q : STD_LOGIC_VECTOR(4 DOWNTO 0);
    signal IDEX_rs2_q : STD_LOGIC_VECTOR(4 DOWNTO 0);
    signal IDEX_rd_q  : STD_LOGIC_VECTOR(4 DOWNTO 0);
    signal IDEX_WBSrc_q				: STD_LOGIC;
	signal IDEX_MULop_q				: STD_LOGIC;
	SIGNAL IDEX_alu_src_q 			: STD_LOGIC;
	SIGNAL IDEX_branch_q 			: STD_LOGIC;
	SIGNAL IDEX_Jal_ctrl_q 			: STD_LOGIC;
	SIGNAL IDEX_Jalr_ctrl_q 		: STD_LOGIC;
	SIGNAL IDEX_reg_write_q 		: STD_LOGIC;
	SIGNAL IDEX_reg_dst_q 			: STD_LOGIC;
	SIGNAL IDEX_mem_write_q 		: STD_LOGIC;
	SIGNAL IDEX_MemtoReg_q 			: STD_LOGIC;
	SIGNAL IDEX_mem_read_q 			: STD_LOGIC;
	SIGNAL IDEX_upper_im_q			: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL IDEX_alu_op_q 			: STD_LOGIC_VECTOR(4 DOWNTO 0);
    --------------------------------------------------------------------
    -- EX stage signals
    --------------------------------------------------------------------
	signal EX_addr_gen_w : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
    signal EX_alu_res_w : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal EX_Branch_or_jal_w : STD_LOGIC;
	signal EX_MULres_s1_w	: STD_LOGIC_VECTOR(63 DOWNTO 0);
	signal EX_RF_rs2_w			: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    --------------------------------------------------------------------
    -- EX/MEM pipeline register signals
    --------------------------------------------------------------------
    signal EXMEM_pc_q          : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	signal EXMEM_pc_plus4_q          : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
    signal EXMEM_instruction_q : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal EXMEM_alu_res_q    : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal EXMEM_write_data_q : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal EXMEM_rd_q         : STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal EXMEM_Branch_or_jal_q : STD_LOGIC;
	signal EXMEM_addr_gen_q : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	signal EXMEM_MULres_s1_q	: STD_LOGIC_VECTOR(63 DOWNTO 0);
	signal EXMEM_jalr_q			: STD_LOGIC;
	signal EXMEMWBSrc_q		: STD_LOGIC;
    signal EXMEM_MemtoReg_q : STD_LOGIC;
    signal EXMEM_RegWrite_q : STD_LOGIC;
    signal EXMEM_MemRead_q  : STD_LOGIC;
    signal EXMEM_MemWrite_q : STD_LOGIC;
	SIGNAL EXMEMmULop_q		: STD_LOGIC;
	signal EXMEM_reg_dst_q	: STD_LOGIC;
    --------------------------------------------------------------------
    -- MEM stage signals
    --------------------------------------------------------------------
    signal MEM_read_data_w : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal MEM_flush_w     : STD_LOGIC;
	signal MEM_mulres_s2_w	: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	signal MEM_result_w     : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    --------------------------------------------------------------------
    -- MEM/WB pipeline register signals
    --------------------------------------------------------------------
    signal MEMWB_pc_q          : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	signal MEMWB_pc_plus4_q    : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
    signal MEMWB_instruction_q : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal MEMWB_read_data_q : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal MEMWB_alu_res_q   : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	signal MEMWB_Mul_q			: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal MEMWB_rd_q        : STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal MEMWB_reg_dst_q	: STD_LOGIC;
    signal MEMWB_MemtoReg_q : STD_LOGIC;
	signal MEMWB_WBSrc_q : STD_LOGIC;	
    signal MEMWB_RegWrite_q : STD_LOGIC;
    --------------------------------------------------------------------
    -- WB stage signals
    --------------------------------------------------------------------
    signal WB_write_data_w : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    --------------------------------------------------------------------
    -- Stall / Flush / Counters/Forwarding
    --------------------------------------------------------------------
    signal stall_w       : STD_LOGIC;
    signal IFID_write_w  : STD_LOGIC;
    signal PCwrite_w     : STD_LOGIC;

    signal clkcnt_q : STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);
    signal stcnt_q  : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal fhcnt_q  : STD_LOGIC_VECTOR(7 DOWNTO 0);	
	signal forward_Ain_w :STD_LOGIC_VECTOR(1 DOWNTO 0);
	signal forward_Bin_w :STD_LOGIC_VECTOR(1 DOWNTO 0);
	--signal rd_stage5_w 
BEGIN

	--=======================================
	-- PLL module connection
	--=======================================
	G0:
	if (MODELSIM = 0) generate
	  MCLK: PLL_pipeline
		PORT MAP (
			inclk0 	=> clk_i,
			c0 		=> mclk_w
		);
	else generate
		mclk_w <= clk_i;
	end generate;
	
	PCwrite_w_muxed <= PCwrite_w when rst_sync_mclk(1) = '0' else '0';

	--=======================================
	-- Reset Synchronizer (CDC)
	--=======================================
	process(mclk_w)
	begin
		if rising_edge(mclk_w) then
			rst_sync_mclk(0) <= rst_i;
			rst_sync_mclk(1) <= rst_sync_mclk(0);
		end if;
	end process;
	--===========================================
	-- IFETCH (including ITCM) module connection
	--===========================================
	IFE : IFETCH_pipeline
	generic map(
		WORD_GRANULARITY			=> 	WORD_GRANULARITY,
		DATA_BUS_WIDTH				=> 	DATA_BUS_WIDTH, 
		PC_WIDTH					=>	PC_WIDTH,
		ITCM_ADDR_WIDTH				=>	ITCM_ADDR_WIDTH,
		WORDS_NUM					=>	DATA_WORDS_NUM
	)
	PORT MAP (
		--Inputs
		--left there right here
		clk_i 					=> mclk_w ,  
		rst_i 					=> rst_sync_mclk(1),  
		PCwrite_i 				=> PCwrite_w_muxed ,  
		Jalr_ctrl_i 			=>  EXMEM_jalr_q,
		Branch_or_jal_i			=>  EXMEM_Branch_or_jal_q,
		addr_gen_i 				=>  EXMEM_addr_gen_q,
		alu_res_i				=>  EXMEM_alu_res_q,	
		--Outputs
		pc_o 					=> IF_pc_w ,
		pc_plus4_o	 			=> IF_pc_next_w ,
		instruction_o 			=> IF_instruction_w   
	);
	--=======================================
	-- Register IF/ID connection
	--=======================================	
	process(mclk_w)
	BEGIN
		if rising_edge(mclk_w) then
			if (rst_sync_mclk(1) = '1') then
				IFID_pc_plus4_q <= (others => '0');
				IFID_instruction_q <= (others => '0');
				IFID_pc_q <= (others => '0');
			elsif (MEM_flush_w = '1') then
				IFID_pc_plus4_q <= (others => '0');
				IFID_instruction_q <= (others => '0');
				IFID_pc_q <= (others => '0');
			elsif IFID_write_w = '1' then
				IFID_pc_plus4_q <= IF_pc_next_w ;
				IFID_instruction_q <= IF_instruction_w;
				IFID_pc_q <=IF_pc_w;
			end if;

		end if;
	end process;
	--=======================================
	-- IDECODE module connection
	--=======================================
	ID : Idecode_pipeline
  generic map(
		PC_WIDTH				=>	PC_WIDTH,
		DATA_BUS_WIDTH			=>  DATA_BUS_WIDTH
	)
	PORT MAP (	
		--Inputs
		clk_i 					=> mclk_w,  
		rst_i 					=> rst_sync_mclk(1),
		wb_data_i	 			=> WB_write_data_w,
		wb_pc_plus4_i 			=> MEMWB_pc_plus4_q,
		RegDst_i 				=> MEMWB_reg_dst_q,--MEMWB_MemtoReg_q
		instruction_i 			=> IFID_instruction_q,
		RegWrite_ctrl_i			=> MEMWB_RegWrite_q,
		WriteRegister_i 		=> MEMWB_rd_q,
		--Outputs
		read_data1_o 			=> ID_read_data1_w,
		read_data2_o 			=> ID_read_data2_w,
		rs1_o 					=> ID_rs1_w, 	 
		rs2_o					=> ID_rs2_w,
		rd_o				    => ID_rd_w,
		SignExt_o 				=> ID_imm_w
	);
	--=======================================
	-- CONTROL module connection
	--=======================================
	CTL:   control_pipeline
	PORT MAP ( 	
		--Inputs
		instruction_i 		=> IFID_instruction_q,	
		--Outputs
		RegDst_ctrl_o		=> reg_dst_w,
		ALUSrc_ctrl_o 		=> alu_src_w,
		MemtoReg_ctrl_o 	=> MemtoReg_w,
		RegWrite_ctrl_o 	=> reg_write_w,
		MemRead_ctrl_o 		=> mem_read_w,
		MemWrite_ctrl_o 	=> mem_write_w,
		Branch_ctrl_o 		=> branch_w,
		Jal_ctrl_o 			=> Jal_ctrl_w,
		Jalr_ctrl_o			=> Jalr_ctrl_w,
		UpperIm_ctrl_o 		=> upper_im_w,
		ALUOp_ctrl_o 		=> alu_op_w,
		MULop_o             =>	MULop_w,
		WBSrc_o             =>	WBSrc_w
	);
	--=======================================
	--  MUX between Stall and Control connection
	--=======================================
	 IDEX_WBSrc_w		<=	WBSrc_w		when stall_w = '0' else '0';
	 IDEX_MULop_w		<=	MULop_w		when stall_w = '0' else '0';			
	 IDEX_alu_src_w 	<=	alu_src_w	when stall_w = '0' else '0';		
	 IDEX_branch_w 		<=	branch_w	when stall_w = '0' else '0';	
	 IDEX_Jal_ctrl_w 	<=	Jal_ctrl_w	when stall_w = '0' else '0';		
	 IDEX_Jalr_ctrl_w 	<=	Jalr_ctrl_w	when stall_w = '0' else '0';	
	 IDEX_reg_write_w 	<=	reg_write_w	when stall_w = '0' else '0';	
	 IDEX_reg_dst_w 	<=	reg_dst_w 	when stall_w = '0' else '0';		
	 IDEX_mem_write_w 	<=	mem_write_w	when stall_w = '0' else '0';	
	 IDEX_MemtoReg_w 	<=	MemtoReg_w	when stall_w = '0' else '0';		
	 IDEX_mem_read_w 	<=	mem_read_w	when stall_w = '0' else '0';		
	 IDEX_upper_im_w	<=	upper_im_w	when stall_w = '0' else  (others =>'0');		
	 IDEX_alu_op_w 		<=	alu_op_w 	when stall_w = '0' else	(others =>'0');
	
	--=======================================
	-- Register ID/EX connection
	--=======================================	
	process(mclk_w)
	BEGIN
		if rising_edge(mclk_w) then
			if (rst_sync_mclk(1) = '1')  then
				 IDEX_read_data1_q<= (others => '0');
				 IDEX_read_data2_q<= (others => '0');
				 IDEX_rs1_q<= (others => '0');
				 IDEX_rs2_q<= (others => '0');
				 IDEX_rd_q<= (others => '0');
				 IDEX_imm_q<= (others => '0');
				 IDEX_pc_q<= (others => '0');
				 IDEX_pc_plus4_q<= (others => '0');
				IDEX_WBSrc_q		<=	'0';
				IDEX_MULop_q		<=	 '0';			
				IDEX_alu_src_q 		<=	'0';		
				IDEX_branch_q 		<=	 '0';	
				IDEX_Jal_ctrl_q 	<=	 '0';		
				IDEX_Jalr_ctrl_q 	<=	 '0';	
				IDEX_reg_write_q 	<=	 '0';	
				IDEX_reg_dst_q 		<=	'0';	
				IDEX_mem_write_q 	<=	'0';	
				IDEX_MemtoReg_q 	<=	'0';		
				IDEX_mem_read_q 	<=	'0';		
				IDEX_upper_im_q	<=	(others =>'0');		
				IDEX_alu_op_q <= (others =>'0');
				IDEX_instruction_q  <=(others =>'0');
			elsif (MEM_flush_w = '1') then
				 IDEX_read_data1_q<= (others => '0');
				 IDEX_read_data2_q<= (others => '0');
				 IDEX_rs1_q<= (others => '0');
				 IDEX_rs2_q<= (others => '0');
				 IDEX_rd_q<= (others => '0');
				 IDEX_imm_q<= (others => '0');
				 IDEX_pc_q<= (others => '0');
				 IDEX_pc_plus4_q<= (others => '0');
				IDEX_WBSrc_q		<=	'0';
				IDEX_MULop_q		<=	 '0';			
				IDEX_alu_src_q 		<=	'0';		
				IDEX_branch_q 		<=	 '0';	
				IDEX_Jal_ctrl_q 	<=	 '0';		
				IDEX_Jalr_ctrl_q 	<=	 '0';	
				IDEX_reg_write_q 	<=	 '0';	
				IDEX_reg_dst_q 		<=	'0';	
				IDEX_mem_write_q 	<=	'0';	
				IDEX_MemtoReg_q 	<=	'0';		
				IDEX_mem_read_q 	<=	'0';		
				IDEX_upper_im_q	<=	(others =>'0');		
				IDEX_alu_op_q <= (others =>'0');
				IDEX_instruction_q  <=(others =>'0');
			ELSE
				IDEX_read_data1_q	<= ID_read_data1_w;
				IDEX_read_data2_q	<= ID_read_data2_w;
				IDEX_rs1_q			<= ID_rs1_w;
				IDEX_rs2_q			<= ID_rs2_w;
				IDEX_rd_q			<= ID_rd_w;
				IDEX_imm_q			<= ID_imm_w;
				IDEX_pc_q			<= IFID_pc_q;
				IDEX_pc_plus4_q		<= IFID_pc_plus4_q;
				IDEX_WBSrc_q		<=	IDEX_WBSrc_w;
				IDEX_MULop_q		<=	 IDEX_MULop_w;			
				IDEX_alu_src_q 		<=	IDEX_alu_src_w;		
				IDEX_branch_q 		<=	 IDEX_branch_w;	
				IDEX_Jal_ctrl_q 	<=	 IDEX_Jal_ctrl_w;		
				IDEX_Jalr_ctrl_q 	<=	 IDEX_Jalr_ctrl_w;	
				IDEX_reg_write_q 	<=	 IDEX_reg_write_w;	
				IDEX_reg_dst_q 		<=	IDEX_reg_dst_w;	
				IDEX_mem_write_q 	<=	IDEX_mem_write_w;	
				IDEX_MemtoReg_q 	<=	IDEX_MemtoReg_w;		
				IDEX_mem_read_q 	<=	IDEX_mem_read_w;		
				IDEX_upper_im_q		<=	IDEX_upper_im_w;		
				IDEX_alu_op_q 		<= IDEX_alu_op_w;	
				IDEX_instruction_q  <= IFID_instruction_q;
			END IF;
		END IF;
	end process;

	--=======================================
	-- EXECUTE module connection
	--=======================================
	EXE:  Execute_pipeline
  generic map(
		DATA_BUS_WIDTH 			=> 	DATA_BUS_WIDTH,
		PC_WIDTH 				=>	PC_WIDTH
	)
	PORT MAP (	
		--Inputs
		pc_i 					=>IDEX_pc_q ,
		sign_extend_i 			=> IDEX_imm_q,
		read_data2_i 			=> IDEX_read_data2_q,
		read_data1_i 			=> IDEX_read_data1_q,
		UpperIm_ctrl_i 			=> IDEX_upper_im_q,
		forward_Ain_i 			=> forward_Ain_w,
		wb_data_i				=> WB_write_data_w,
		alu_res_i             	=> MEM_result_w,
		forward_Bin_i           => forward_Bin_w,
		ALUSrc_ctrl_i			=> IDEX_alu_src_q,
		ALUOp_ctrl_i			=> IDEX_alu_op_q,
		Branch_ctrl_i			=> IDEX_branch_q,
		Jal_ctrl_i				=> IDEX_Jal_ctrl_q,
		MULop_i					=> IDEX_MULop_q,									
		--Outputs
		addr_gen_o 				=> EX_addr_gen_w,
		alu_res_o				=> EX_alu_res_w,
		Branch_or_jal_o 		=> EX_Branch_or_jal_w,
		MULres_o				=> EX_MULres_s1_w,
		RF_rs2_o				=> EX_RF_rs2_w
	);
	--=======================================
	-- Register EX/MEM connection
	--=======================================	
	process(mclk_w)
	BEGIN
		if rising_edge(mclk_w) then
			if (rst_sync_mclk(1) = '1') then 
				EXMEM_pc_q 			<= (others => '0');
				EXMEM_pc_plus4_q 	<= (others => '0');
				EXMEM_instruction_q <= (others => '0');
				EXMEM_rd_q 			<= (others => '0');
				EXMEM_alu_res_q 	<= (others => '0');
				EXMEM_write_data_q 	<= (others => '0');
				EXMEM_addr_gen_q 	<= (others => '0');
				EXMEM_MULres_s1_q 	<= (others => '0');
				EXMEMmULop_q		<=	'0';
				EXMEMWBSrc_q		<=	 '0';			
				EXMEM_Branch_or_jal_q <=	'0';		
				EXMEM_jalr_q 		<=	 '0';	
				EXMEM_MemWrite_q 	<=	 '0';		
				EXMEM_MemRead_q 	<=	 '0';	
				EXMEM_MemtoReg_q 	<=	 '0';	
				EXMEM_RegWrite_q 	<=	'0';	
				EXMEM_reg_dst_q 	<=	'0';
			elsif (MEM_flush_w = '1') then
				EXMEM_pc_q 			<= (others => '0');
				EXMEM_pc_plus4_q 	<= (others => '0');
				EXMEM_instruction_q <= (others => '0');
				EXMEM_rd_q 			<= (others => '0');
				EXMEM_alu_res_q 	<= (others => '0');
				EXMEM_write_data_q 	<= (others => '0');
				EXMEM_addr_gen_q 	<= (others => '0');
				EXMEM_MULres_s1_q 	<= (others => '0');
				EXMEMmULop_q		<=	'0';
				EXMEMWBSrc_q		<=	 '0';			
				EXMEM_Branch_or_jal_q <=	'0';		
				EXMEM_jalr_q 		<=	 '0';	
				EXMEM_MemWrite_q 	<=	 '0';		
				EXMEM_MemRead_q 	<=	 '0';	
				EXMEM_MemtoReg_q 	<=	 '0';	
				EXMEM_RegWrite_q 	<=	'0';	
				EXMEM_reg_dst_q 	<=	'0';			 	
			ELSE
				EXMEM_pc_q 			<= IDEX_pc_q;
				EXMEM_pc_plus4_q 	<= IDEX_pc_plus4_q;
				EXMEM_instruction_q <= IDEX_instruction_q;
				EXMEM_rd_q 			<= IDEX_rd_q;
				EXMEM_alu_res_q 	<= EX_alu_res_w;
				EXMEM_write_data_q 	<= EX_RF_rs2_w;
				EXMEM_addr_gen_q 	<= EX_addr_gen_w;
				EXMEM_MULres_s1_q 	<= EX_MULres_s1_w;
				EXMEMmULop_q		<= IDEX_MULop_q;
				EXMEMWBSrc_q		<= IDEX_WBSrc_q ;			
				EXMEM_Branch_or_jal_q <= EX_Branch_or_jal_w	;		
				EXMEM_jalr_q 		<=	IDEX_Jalr_ctrl_q;	
				EXMEM_MemWrite_q 	<=	IDEX_mem_write_q ;		
				EXMEM_MemRead_q 	<=	IDEX_mem_read_q ;	
				EXMEM_MemtoReg_q 	<=	IDEX_MemtoReg_q ;	
				EXMEM_RegWrite_q 	<=	IDEX_reg_write_q;	
				EXMEM_reg_dst_q 	<=	IDEX_reg_dst_q;		
			END IF;
		end if;
	end process;
	
	--=======================================
	-- DTCM module connection
	--=======================================
	G1: 
	if (WORD_GRANULARITY = True) generate -- i.e. each WORD has a unike address
		dtcm_addr_w	<= EXMEM_alu_res_q(MA_WIDTH-1 DOWNTO 2); -- increment memory address by 4;
	elsif (WORD_GRANULARITY = False) generate -- i.e. each BYTE has a unike address
		dtcm_addr_w	<= EXMEM_alu_res_q(MA_WIDTH-1 DOWNTO 0);
	end generate;
	
	MEM:  dmemory_pipeline
	generic map(
		DATA_BUS_WIDTH		=> 	DATA_BUS_WIDTH, 
		DTCM_ADDR_WIDTH		=> 	DTCM_ADDR_WIDTH,
		WORDS_NUM			=>	DATA_WORDS_NUM
	)
	PORT MAP (	
		--Inputs
		Jalr_ctrl_i 			=> EXMEM_jalr_q,  
		Branch_or_jal_i 		=> EXMEM_Branch_or_jal_q,
		dtcm_addr_i 			=> dtcm_addr_w,
		dtcm_data_wr_i 			=> EXMEM_write_data_q,
		MULres_i 				=> EXMEM_MULres_s1_q, 
		MULop_i 				=> EXMEMmULop_q,
		clk_i					=> mclk_w,
		MemWrite_ctrl_i			=> EXMEM_MemWrite_q,
		MemRead_ctrl_i			=> EXMEM_MemRead_q,				
		--Outputs
		Flush_o					=> MEM_flush_w ,
		dtcm_data_rd_o			=> MEM_read_data_w,
		MULres_o				=> MEM_mulres_s2_w						
	);	
	
	MEM_result_w <= MEM_mulres_s2_w when EXMEMmULop_q = '1' else EXMEM_alu_res_q;
	--=======================================
	-- Register MEM/WB connection
	--=======================================	
	process(mclk_w)
	BEGIN
		if rising_edge(mclk_w) then
			if (rst_sync_mclk(1) = '1') then
						MEMWB_pc_q			<= (others => '0');
						MEMWB_pc_plus4_q	<= (others => '0');
						MEMWB_instruction_q	<= (others => '0');
						MEMWB_rd_q			<= (others => '0');
						MEMWB_read_data_q	<= (others => '0');
						MEMWB_alu_res_q		<= (others => '0');
						MEMWB_Mul_q			<= (others => '0');
						MEMWB_reg_dst_q		<=	'0';
						MEMWB_MemtoReg_q	<=	 '0';			
						MEMWB_WBSrc_q		<=	'0';		
						MEMWB_RegWrite_q	<=	 '0';				 	
			else
				 		MEMWB_pc_q			<=EXMEM_pc_q ;
						MEMWB_pc_plus4_q	<=EXMEM_pc_plus4_q ;
						MEMWB_instruction_q	<=EXMEM_instruction_q ;
				 		MEMWB_rd_q			<=EXMEM_rd_q ;
						MEMWB_Mul_q			<= MEM_mulres_s2_w;
						MEMWB_read_data_q	<= MEM_read_data_w;
						MEMWB_alu_res_q		<= EXMEM_alu_res_q;
						MEMWB_reg_dst_q		<=EXMEM_reg_dst_q ;
						MEMWB_MemtoReg_q	<=EXMEM_MemtoReg_q ;
						MEMWB_WBSrc_q		<= EXMEMWBSrc_q;
						MEMWB_RegWrite_q	<=EXMEM_RegWrite_q ;										
			end if;
		end if;
	end process;	
	--=======================================
	-- WriteBack module connection
	--=======================================
	WB:  WriteBack_pipeline
	generic map(
		DATA_BUS_WIDTH			=> DATA_BUS_WIDTH,
		DTCM_ADDR_WIDTH			=> DTCM_ADDR_WIDTH,
		WORDS_NUM				=> DATA_WORDS_NUM,
		PC_WIDTH				=>  PC_WIDTH
	)
	PORT MAP (	
		--Inputs
		dtcm_data_rd_i 			=> MEMWB_read_data_q,  
		ALUres_i 				=> MEMWB_alu_res_q,
		MULres_i 				=> MEMWB_Mul_q,
		MemtoReg_ctrl_i			=> MEMWB_MemtoReg_q,
		WBSrc_i					=> MEMWB_WBSrc_q,
		--Outputs
		wb_data_o 				=> WB_write_data_w	
	);	
	--=======================================
	-- ForwardUnit module connection
	--=======================================
	FU:  Forwarding_unit
	generic map(
		PC_WIDTH 				=>	PC_WIDTH,
		DATA_BUS_WIDTH 			=> 	DATA_BUS_WIDTH		
	)
	PORT MAP (	
		--Inputs
		ExMem_rd_i 				=> EXMEM_rd_q,  
		ExMem_RegWrite_i 		=> EXMEM_RegWrite_q,
		MemWB_rd_i 				=> MEMWB_rd_q,
		MEM_WB_RegWrite_i 		=> MEMWB_RegWrite_q,
		IDEX_rs1_i 				=> IDEX_rs1_q , 
		IDEX_rs2_i 				=> IDEX_rs2_q,	
		--Outputs
		forward_Ain_o 			=> forward_Ain_w,
		forward_Bin_o			=> forward_Bin_w
	);	
	--=======================================
	-- StallUnit module connection
	--=======================================
	ST:  Stall_cond_unit
	PORT MAP (	
		--Inputs
		IFID_instruction_i 	=> IFID_instruction_q,  
		IDEX_rd_i 			=> IDEX_rd_q,
		IDEX_MemRead_i 		=> IDEX_mem_read_q,
		--Outputs
		stall_o 			=> stall_w,
		PCwrite_o			=> PCwrite_w,
		IFID_write_o		=> IFID_write_w
	);	
	--=======================================
	-- MCLK counter register connection
	--=======================================									
	process (mclk_w)
	begin
		if rising_edge(mclk_w) then
			if rst_sync_mclk(1) = '1' then
				mclk_cnt_q	<=	(others	=> '0');
			else
				mclk_cnt_q	<=	mclk_cnt_q + '1';
			end if;
		end if;
	end process;
	
	--=======================================
	-- STL counter register connection
	--=======================================	
	process(mclk_w)
	begin
		if rising_edge(mclk_w) then       
			if rst_sync_mclk(1) = '1' then
				stl_cnt_q <= (others => '0');
			elsif stall_w = '1' then
				stl_cnt_q <= stl_cnt_q + '1';

			end if;
		end if;
	end process;
	--=======================================
	-- Flush counter register connection
	--=======================================	
	process(mclk_w)
	begin
		if rising_edge(mclk_w) then       
			if rst_sync_mclk(1) = '1' then
				fhl_cnt_q <= (others => '0');
			elsif MEM_flush_w = '1' then
				fhl_cnt_q <= fhl_cnt_q + '1';

			end if;
		end if;
	end process;
	
	
	STRIGGER_w <= '1' when IF_pc_w(9 DOWNTO 2) = BPADDR_i else '0'; 
---------------------------------------------------------------------------------------
-- Copying out important signals only for Verification and FPGA Velidation(Signal-TAP)
---------------------------------------------------------------------------------------
	clkcnt_o				<= mclk_cnt_q	;		
	IFpc_o					<=IF_pc_w;			
	IFinstruction_o			<=IF_instruction_w	;	 		
	IDpc_o      			<=IFID_pc_q	;		   
	IDinstruction_o			<=IFID_instruction_q	;		   
	EXpc_o         			<=IDEX_pc_q	;		   
	EXinstruction_o 		<=IDEX_instruction_q	;			
	MEMpc_o         		<=EXMEM_pc_q	;			
	MEMinstruction_o		<=EXMEM_instruction_q	;			
	WBpc_o         			<=MEMWB_pc_q	;		    
	WBinstruction_o 		<=MEMWB_instruction_q	;			
	STRIGGER_o     		    <=	STRIGGER_w;			 
	FHCNT_o         		<= fhl_cnt_q	;			
	STCNT_o        			<= stl_cnt_q	;									
	
---------------------------------------------------------------------------------------

END structure;

