---------------------------------------------------------------------------------------------
-- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
--  Dmemory module (implements the data memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY dmemory_pipeline IS
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
END dmemory_pipeline;

-----------------------------------------------------------------------------------------------------

ARCHITECTURE behavior OF dmemory_pipeline IS
	SIGNAL wrclk_w : STD_LOGIC;
	signal resmul  : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL P0, P1, P2, P3  : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL M               : STD_LOGIC_VECTOR(15 DOWNTO 0);

	
BEGIN
	data_memory : altsyncram
	GENERIC MAP  (
		operation_mode					=> "SINGLE_PORT",
		width_a									=> DATA_BUS_WIDTH,
		widthad_a								=> DTCM_ADDR_WIDTH,
		numwords_a 							=> WORDS_NUM,
		lpm_hint 								=> "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = DTCM",
		lpm_type 								=> "altsyncram",
		outdata_reg_a 					=> "UNREGISTERED",
		init_file 							=> "C:\Users\yoavt\ModelSim\Lab5\BACKUP\Benchmark Apps\test\DTCM.hex",
		intended_device_family 	=> "Cyclone"
	)
	PORT MAP (
		wren_a 									=> MemWrite_ctrl_i,
		clock0									=> wrclk_w,
		address_a								=> dtcm_addr_i,
		data_a									=> dtcm_data_wr_i,
		q_a											=> dtcm_data_rd_o	
	);
	--Multiplier 
	with MULop_i select
	MULres_o <= resmul WHEN '1',
				(others =>'0') when others;
				
	 P3 <= MULres_i(63 DOWNTO 48);
	 P2 <= MULres_i(47 DOWNTO 32);
	 P1 <= MULres_i(31 DOWNTO 16);
	 P0 <= MULres_i(15 DOWNTO 0);
	 -- Stage 2:
    M <= P1 + P2;
	
	--Padding+SHL:
    resmul <= (x"0000" & P0) + (x"00" & M & x"00") + (P3 & x"0000");			
				

	wrclk_w <= NOT clk_i;	-- Load memory address register with write clock
	
	
	--assigments:
	Flush_o							<= Branch_or_jal_i or Jalr_ctrl_i;
	
	---------------------------------------------------------------------------
END behavior;

