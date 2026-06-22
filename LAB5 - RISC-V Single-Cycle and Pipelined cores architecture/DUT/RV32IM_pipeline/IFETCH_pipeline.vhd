--============================================================================
-- Copyright 2026 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
-- Top Level Structural Model for Single-Cycle RISC-V Core
-- IFETCH module provides the PC and the ITCM of the RISC-V core)
--============================================================================
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;


ENTITY Ifetch_pipeline IS
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
END Ifetch_pipeline;

ARCHITECTURE behavior OF Ifetch_pipeline IS
	SIGNAL pc_q						: STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0); -- OUTPUT pc_o AND GO TO ADDER
	SIGNAL pc_plus4_w			: STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0); --TO BE USED FOR UPPERMUX ENTRY 0 AND AS OUTPUT pc_plus4_o
	SIGNAL itcm_addr_w		: STD_LOGIC_VECTOR(ITCM_ADDR_WIDTH-1 DOWNTO 0); --TO BE USED OUTPUT FROM MEMORY instruction_o
	SIGNAL upper_mux_w : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	SIGNAL lower_mux_w : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	SIGNAL next_pc_addr_w : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	--SIGNAL brTaken_w  		: STD_LOGIC;
	--SIGNAL rst_q  				: STD_LOGIC; 
	
BEGIN
	--=======================================
	-- ITCM (ROM) connection
	--=======================================
	inst_memory: altsyncram
	GENERIC MAP (
		operation_mode					=> "ROM",
		width_a 								=> DATA_BUS_WIDTH,
		widthad_a 							=> ITCM_ADDR_WIDTH,
		numwords_a 							=> WORDS_NUM,
		lpm_hint 								=> "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = ITCM",
		lpm_type 								=> "altsyncram",
		outdata_reg_a 					=> "UNREGISTERED",
		init_file 							=> "C:\Users\yoavt\ModelSim\Lab5\BACKUP\Benchmark Apps\test\ITCM.hex",
		intended_device_family	=> "Cyclone"
	)
	PORT MAP (
		clock0    => clk_i,
		address_a	=> itcm_addr_w, 
		q_a 	   	=> instruction_o 
	);
-------------------------------------------------------------------------------------
	-- Adder to execute PC+4
  pc_plus4_w(PC_WIDTH-1 DOWNTO 0)	<= pc_q(PC_WIDTH-1 DOWNTO 0) + 4;
	
-----------------------------------------------------------------------------------
	-- Decision MUX for the next PC value
	upper_mux_w <= addr_gen_i when Branch_or_jal_i ='1' else 
					pc_plus4_w;
	
	lower_mux_w <= upper_mux_w when Jalr_ctrl_i = '0' else 
				   alu_res_i(PC_WIDTH-1 DOWNTO 0);
				   
    

-----------------------------------------------------------------------------------
-- pc register
-------------------------------------------------------------------------------------
PROCESS (clk_i)
	BEGIN
		IF(clk_i'EVENT AND clk_i='1') THEN
			IF rst_i = '1' THEN
				pc_q(PC_WIDTH-1 DOWNTO 0) <= (OTHERS => '0') ; 
			ELSIF PCwrite_i = '1' THEN
				pc_q(PC_WIDTH-1 DOWNTO 0) <= lower_mux_w;
			END IF;
		END IF;
END PROCESS;
-----------------------------------------------------------------------------------	
	-- send address to inst. memory address register
	next_pc_addr_w <= lower_mux_w when PCwrite_i = '1' else pc_q;
	
	G1: 
	if (WORD_GRANULARITY = True) generate 			-- i.e. each WORD has unike address--pc_q
		itcm_addr_w <= next_pc_addr_w(PC_WIDTH-1 DOWNTO 2);
	elsif (WORD_GRANULARITY = False) generate 	-- i.e. each BYTE has unike address
		itcm_addr_w <= next_pc_addr_w;--pc_q
	end generate;
---------------------------------------------------------------------------------------
	pc_o 				<= 	pc_q;
	pc_plus4_o	<= 	pc_plus4_w;	
---------------------------------------------------------------------------------------
	
END behavior;


