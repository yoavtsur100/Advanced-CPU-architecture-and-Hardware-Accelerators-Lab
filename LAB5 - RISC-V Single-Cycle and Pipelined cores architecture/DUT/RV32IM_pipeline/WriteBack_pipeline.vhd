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
------------------------------------------------------------------------------
ENTITY WriteBack_pipeline IS
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
END WriteBack_pipeline;
------------------------------------------------------------------------------
ARCHITECTURE behavior OF WriteBack_pipeline IS
	signal first_mux_w : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	
	
	begin
	
	first_mux_w <= ALUres_i when WBSrc_i ='1' else MULres_i;
	
	wb_data_o   <= dtcm_data_rd_i when MemtoReg_ctrl_i = '1' else first_mux_w;
	
	
	--assigments:
	--rd_o			<= rd_i;
	--pc_o			<=pc_i;
	--pc_plus4_o		<=pc_plus4_i;

END behavior;