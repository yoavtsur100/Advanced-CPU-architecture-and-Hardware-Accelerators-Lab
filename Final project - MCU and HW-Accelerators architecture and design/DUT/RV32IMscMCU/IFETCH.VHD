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


ENTITY Ifetch IS
	generic(
		WORD_GRANULARITY 	: boolean	:= False;
		DATA_BUS_WIDTH 		: integer	:= 32;
		PC_WIDTH 			: integer	:= 10;
		ITCM_ADDR_WIDTH 	: integer	:= 8;
		WORDS_NUM 			: integer	:= 256
	);
	PORT(
		--Inputs
		clk_i			: IN 	STD_LOGIC;
		rst_i 			: IN 	STD_LOGIC;
		addr_gen_i 		: IN 	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		Branch_ctrl_i	: IN 	STD_LOGIC;
		brTaken_i 		: IN 	STD_LOGIC;
		Jal_ctrl_i		: IN 	STD_LOGIC;
		Jalr_ctrl_i		: IN 	STD_LOGIC;
		alu_res_i 		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		PChold_i		: IN 	STD_LOGIC;
		IntAccept_ctrl_i : IN   STD_LOGIC;	--use as ENA of forward ReturnPC or NextPC
		WriteTP_ctrl_i   : IN   STD_LOGIC;	--Selector between the PCplus4 or ReturnPC
		
		--Outputs
		pc_o 					: OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		pc_plus4_o 		: OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		instruction_o : OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0)
	);
END Ifetch;


ARCHITECTURE behavior OF Ifetch IS
	SIGNAL pc_q						: STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	SIGNAL pc_plus4_q			: STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	SIGNAL pc_plus4_r 		: STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	SIGNAL itcm_addr_w		: STD_LOGIC_VECTOR(ITCM_ADDR_WIDTH-1 DOWNTO 0);
	SIGNAL next_pc_w  		: STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	SIGNAL brTaken_w  		: STD_LOGIC;
	SIGNAL rst_q  				: STD_LOGIC;
	SIGNAL itcm_addr_next : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	SIGNAL return_pc_q 		: STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);

	
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
		init_file 							=> "C:\Users\yoavt\ModelSim\FinalProject\Benchmark Apps\test\ITCM.hex",
		intended_device_family	=> "Cyclone"
	)
	PORT MAP (
		clock0    => clk_i,
		address_a	=> itcm_addr_w, 
		q_a 	   	=> instruction_o 
	);
-------------------------------------------------------------------------------------
-- rst_i synchronization
-------------------------------------------------------------------------------------
PROCESS (clk_i, rst_i)
	BEGIN
		IF rst_i = '1' THEN
			rst_q <= '1';	-- preset
		ELSIF(clk_i'EVENT  AND clk_i='1') THEN			
				rst_q <= rst_i;
		END if;
END PROCESS;

	
-----------------------------------------------------------------------------------		
	-- Adder to execute PC+4
  pc_plus4_r(PC_WIDTH-1 DOWNTO 0)	<= next_pc_w(PC_WIDTH-1 DOWNTO 0) + 4;
	
-----------------------------------------------------------------------------------
	-- Decision MUX for the next PC value
	brTaken_w <= 	Branch_ctrl_i AND brTaken_i;
	
	next_pc_w	<=	(others => '0') 									WHEN	rst_q 				ELSE
								alu_res_i(PC_WIDTH-1 DOWNTO 0)		WHEN	Jalr_ctrl_i				ELSE	-- case of jalr
								addr_gen_i(PC_WIDTH-1 DOWNTO 0)		WHEN	brTaken_w or Jal_ctrl_i ELSE	-- case of Branch Taken or jal 
								pc_plus4_q(PC_WIDTH-1 DOWNTO 0);											-- case of Branch Not-Taken 				
-----------------------------------------------------------------------------------
-- pc_plus4 register
-------------------------------------------------------------------------------------
PROCESS (clk_i, rst_i)
	BEGIN
		IF rst_i = '1' THEN
			pc_plus4_q(PC_WIDTH-1 DOWNTO 0) <= (OTHERS => '0') ; 
		ELSIF(clk_i'EVENT  AND clk_i='1') THEN
			if(PChold_i='0') then --pchold=0  is no wait
			pc_plus4_q(PC_WIDTH-1 DOWNTO 0) <= pc_plus4_r;	
		END IF;
		END IF;
END PROCESS;

-----------------------------------------------------------------------------------
-- pc register
-------------------------------------------------------------------------------------
PROCESS (clk_i, rst_i)
	BEGIN
		IF rst_i = '1' THEN
			pc_q(PC_WIDTH-1 DOWNTO 0) <= (OTHERS => '0') ; 
		ELSIF(clk_i'EVENT  AND clk_i='1') THEN
			if(PChold_i='0') then --pchold=0  is no wait
			pc_q(PC_WIDTH-1 DOWNTO 0) <= next_pc_w;	
		END IF;
		END IF;
END PROCESS;

	itcm_addr_next <= pc_q WHEN PChold_i = '1' ELSE next_pc_w;
-----------------------------------------------------------------------------------	
	-- send address to inst. memory address register
	G1: 
	if (WORD_GRANULARITY = True) generate 			-- i.e. each WORD has unike address
		itcm_addr_w <= itcm_addr_next(PC_WIDTH-1 DOWNTO 2);
	elsif (WORD_GRANULARITY = False) generate 	-- i.e. each BYTE has unike address
		itcm_addr_w <= itcm_addr_next;
	end generate;
----------------------------------------------------------------------------------------------------------------
-- return_pc register to capture correct interrupt return address(like Latch of the nextPC when Interrupt arrive)
----------------------------------------------------------------------------------------------------------------
PROCESS (clk_i, rst_i)
	BEGIN
		IF rst_i = '1' THEN
			return_pc_q <= (OTHERS => '0') ; 
		ELSIF rising_edge(clk_i) THEN
			IF IntAccept_ctrl_i = '1' THEN
				return_pc_q <= next_pc_w;	
			END IF;
		END IF;
END PROCESS;

	pc_o <= pc_q;
	
	--MUX by WriteTP_ctrl_i (1=return_pc_q , 0=pc_plus4_q)
	pc_plus4_o	<= 	return_pc_q WHEN WriteTP_ctrl_i = '1' ELSE pc_plus4_q;	
---------------------------------------------------------------------------------------
	
END behavior;


