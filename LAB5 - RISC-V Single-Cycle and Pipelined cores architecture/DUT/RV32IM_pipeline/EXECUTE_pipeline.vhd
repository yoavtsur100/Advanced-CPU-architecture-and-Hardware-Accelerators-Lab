--============================================================================
-- Copyright 2026 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
-- Execute module (implements the data ALU and Branch Address Adder) 
--============================================================================
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE work.const_package_pipeline.all;
USE work.aux_package_pipeline.all;

ENTITY  Execute_pipeline IS
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
END Execute_pipeline;


ARCHITECTURE struct OF Execute_pipeline IS
	signal forwarded_read_data2_w : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL 	ain_w 					: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL 	bin_w 					: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	signal 	first_mux_w				: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	signal  second_mux_w			: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	
	SIGNAL A_low, A_high   			: STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL B_low, B_high   			: STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL P0, P1, P2, P3  			: STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL 	sub_res_w 			: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL 	ltu_res_w 			: STD_LOGIC;
	SIGNAL 	eq_res_w				: STD_LOGIC;
	SIGNAL	msbneq_res_w		: STD_LOGIC;
	SIGNAL	alu_res_r 			: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL	brTaken_w 			: STD_LOGIC;
	
	SIGNAL	brl_shl_s1_r		: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL	brl_shl_s2_r		: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL	brl_shl_s3_r		: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL	brl_shl_s4_r		: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	
	SIGNAL	brl_shr_s1_r		: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL	brl_shr_s2_r		: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL	brl_shr_s3_r		: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL	brl_shr_s4_r		: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL	brl_shr_pad_r		: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	signal resmul 				: STD_LOGIC_VECTOR(63 DOWNTO 0);
	
		
BEGIN

	--======================================================================================================
	--				MUX
	--======================================================================================================
	-- First MUX:
	--first_mux_w <= 	read_data2_i	WHEN  ALUSrc_ctrl_i ='0' ELSE
					--sign_extend_i(DATA_BUS_WIDTH-1 DOWNTO 0);
	-- Second Mux:
	with UpperIm_ctrl_i SELECT
	second_mux_w <= read_data1_i  											WHEN	"00",
					((DATA_BUS_WIDTH-PC_WIDTH-1) DOWNTO 0 => '0') & pc_i	WHEN	"01",
					(others => '0')											WHEN	OTHERS;
	--Upper Mux:
	ain_w		<=	alu_res_i			when 	(forward_Ain_i = "10" and UpperIm_ctrl_i = "00") else
					wb_data_i			when 	(forward_Ain_i = "01" and UpperIm_ctrl_i = "00") else
					second_mux_w;
	--Lower Mux:
	bin_w		<=	alu_res_i			when 	(forward_Bin_i = "10" and ALUSrc_ctrl_i = '0') else
					wb_data_i			when 	(forward_Bin_i = "01" and ALUSrc_ctrl_i = '0') else
					read_data2_i		WHEN  	ALUSrc_ctrl_i ='0' ELSE
					sign_extend_i(DATA_BUS_WIDTH-1 DOWNTO 0); 
					--others => '0')		WHEN	OTHERS;
					
					
	
	forwarded_read_data2_w <= alu_res_i			when 	forward_Bin_i = "10" else
				wb_data_i		when 	forward_Bin_i = "01" else
				read_data2_i;
	
	
					--first_mux_w			when 	"00",
					--wb_data_i			when 	"01",
					--alu_res_i			when 	"10",
					--(others => '0')		WHEN	OTHERS;
	--------------------------------------------------------------------------------------------------------
	--Multiplier 
	with MULop_i select
	MULres_o <= resmul WHEN '1',
				(others =>'0') when others;

   --8 bit:
    A_low  <= ain_w(7 DOWNTO 0);
    A_high <= ain_w(15 DOWNTO 8);
    B_low  <= bin_w(7 DOWNTO 0);
    B_high <= bin_w(15 DOWNTO 8);

    --Stage 1:
    P0 <= A_low  * B_low;
    P1 <= A_low  * B_high;
    P2 <= A_high * B_low;
    P3 <= A_high * B_high;
	
	resmul	<=	P3 & P2 & P1 & P0;
--======================================================================================================	
--				ALU
--======================================================================================================
	
--Reused resuls 
sub_res_w			<= ain_w - bin_w;
ltu_res_w			<= '1' WHEN ain_w < bin_w 					ELSE '0';
eq_res_w			<= '1' WHEN ain_w = bin_w 					ELSE '0'; 
msbneq_res_w		<= '1' WHEN ain_w(31) /= bin_w(31) 			ELSE '0';


PROCESS (all)
BEGIN
	-- default values
	alu_res_r 		<= (others => '0');
	brTaken_w 		<= '0';
	brl_shl_s1_r	<= (others => '0');
	brl_shl_s2_r	<= (others => '0');
	brl_shl_s3_r	<= (others => '0'); 
	brl_shl_s4_r	<= (others => '0');
	brl_shr_s1_r	<= (others => '0');
	brl_shr_s2_r	<= (others => '0');
	brl_shr_s3_r	<= (others => '0'); 
	brl_shr_s4_r	<= (others => '0');
	brl_shr_pad_r	<= (others => '0');
	
	
 	CASE ALUOp_ctrl_i IS	-- Select ALU operation
		------------------------------------------------------
    -- Arithmetic
    ------------------------------------------------------
		-- add, addi, auipc, jal, jalr
		WHEN ALU_ADD 	=>
			alu_res_r	<= ain_w + bin_w;
			brTaken_w	<= '0';
		
		-- sub
		WHEN ALU_SUB	=>
			alu_res_r	<= sub_res_w;		 
			brTaken_w	<= '0';
		------------------------------------------------------
    -- Logic
    ------------------------------------------------------
		-- and, andi	
    WHEN	ALU_AND 	=>
			alu_res_r	<= ain_w and bin_w;
			brTaken_w	<= '0';
		
		-- or, ori		
	 	WHEN ALU_OR	=>
			alu_res_r	<= ain_w or bin_w;
			brTaken_w	<= '0';
		
		-- xor, xori
		WHEN ALU_XOR 	=>
			alu_res_r	<= ain_w xor bin_w;
			brTaken_w	<= '0';
				
		------------------------------------------------------
    -- Shift Left
    ------------------------------------------------------
		-- sll, slli
 	 	WHEN ALU_SHIFTL	=>
			-- Barrel-Shifter SHL stage 0
			if (bin_w(0) = '1') then
				brl_shl_s1_r <= (ain_w(30 DOWNTO 0) & '0');
			else
				brl_shl_s1_r <= ain_w;
			end if;
					
			-- Barrel-Shifter SHL stage 1
			if (bin_w(1) = '1') then
				brl_shl_s2_r <= (brl_shl_s1_r(29 DOWNTO 0) & "00");
			else
				brl_shl_s2_r <= brl_shl_s1_r;
			end if;
					
			-- Barrel-Shifter SHL stage 2
			if (bin_w(2) = '1')	then
				brl_shl_s3_r <= (brl_shl_s2_r(27 DOWNTO 0) & "0000");
			else
				brl_shl_s3_r <= brl_shl_s2_r;
			end if;
					
			-- Barrel-Shifter SHL stage 3
			if (bin_w(3) = '1')	then
				brl_shl_s4_r <= (brl_shl_s3_r(23 DOWNTO 0) & "00000000");
			else
				brl_shl_s4_r <= brl_shl_s3_r;
			end if;
					
			-- Barrel-Shifter SHL stage 4
			if (bin_w(4) = '1')	then
				alu_res_r <= (brl_shl_s4_r(15 DOWNTO 0) & "0000000000000000");
			else
				alu_res_r <= brl_shl_s4_r;
			end if;
				      
			brTaken_w	<= '0';
		------------------------------------------------------
    -- Shift Right
    ------------------------------------------------------		
		-- srl, srli, sra, srai	
 	 	WHEN ALU_SHIFTR | ALU_SHIFTR_ARITH 	=>
			--if sra? pad with 1's else pad with 0's 
			if (ain_w(31) = '1' and (ALUOp_ctrl_i = ALU_SHIFTR_ARITH)) then
				brl_shr_pad_r <= 32x"FFFF";
			else
				brl_shr_pad_r <= 32x"0000";
			end if;
			
			-- Barrel-Shifter SHR stage 0
			if (bin_w(0) = '1') then
				brl_shr_s1_r <= (brl_shr_pad_r(31) & ain_w(31 DOWNTO 1));
			else
				brl_shr_s1_r <= ain_w;
			end if;
			
			-- Barrel-Shifter SHR stage 1
			if (bin_w(1) = '1') then
				brl_shr_s2_r <= (brl_shr_pad_r(31 DOWNTO 30) & brl_shr_s1_r(31 DOWNTO 2));
			else
				brl_shr_s2_r <= brl_shr_s1_r;
			end if;
			
			-- Barrel-Shifter SHR stage 2
			if (bin_w(2) = '1') then
				brl_shr_s3_r <= (brl_shr_pad_r(31 DOWNTO 28) & brl_shr_s2_r(31 DOWNTO 4));
			else
				brl_shr_s3_r <= brl_shr_s2_r;
			end if;
			
			-- Barrel-Shifter SHR stage 3
			if (bin_w(3) = '1') then
				brl_shr_s4_r <= (brl_shr_pad_r(31 DOWNTO 24) & brl_shr_s3_r(31 DOWNTO 8));
			else
				brl_shr_s4_r <= brl_shr_s3_r;
			end if;
			
			-- Barrel-Shifter SHR stage 4
			if (bin_w(4) = '1')	then
				alu_res_r <= (brl_shr_pad_r(31 DOWNTO 16) & brl_shr_s4_r(31 DOWNTO 16));
			else
				alu_res_r <= brl_shr_s4_r;
			end if;
				   
			brTaken_w	<= '0';		 	 				
		------------------------------------------------------
    -- Comparision
    ------------------------------------------------------
		-- slt, slti
		WHEN ALU_LESS_THAN_SIGNED	=>
			brTaken_w	<= '0';
			IF msbneq_res_w THEN
				IF ain_w(31) THEN
					alu_res_r	<= (0 => '1', others => '0');	--32'h1
				ELSE
					alu_res_r	<= (others => '0');						--32'h0
				END IF;
			ELSE
				IF sub_res_w(31) THEN
					alu_res_r	<= (0 => '1', others => '0');	--32'h1	
				ELSE
					alu_res_r	<= (others => '0');						--32'h0
				END IF;
			END IF;
		
		-- sltu, sltiu 
		WHEN ALU_LESS_THAN_UNSIGNED	=>
			brTaken_w	<= '0';
			IF ltu_res_w THEN
				alu_res_r	<= (0 => '1', others => '0');		--32'h1
			ELSE
				alu_res_r	<= (others => '0');							--32'h0
			END IF;

		------------------------------------------------------
    -- Condional Branch 
    ------------------------------------------------------
		-- beq
		WHEN ALU_BEQ	=>
			alu_res_r	<= (others => '0');
			brTaken_w	<= eq_res_w;
		
		-- bne
		WHEN ALU_BNE	=>
			alu_res_r	<= (others => '0');
			brTaken_w	<= not eq_res_w;
		
		-- blt
		WHEN ALU_BLT	=>
			alu_res_r	<= (others => '0');
			IF msbneq_res_w THEN
				brTaken_w	<= ain_w(31);
			ELSE
				brTaken_w	<= sub_res_w(31);
			END IF;
		
		-- bge
		WHEN ALU_BGE	=>
			alu_res_r	<= (others => '0');
			IF msbneq_res_w THEN
				brTaken_w	<= bin_w(31);
			ELSE
				brTaken_w	<= not sub_res_w(31);
			END IF;
		
		-- bltu
		WHEN ALU_BLTU	=>
			alu_res_r	<= (others => '0');
			brTaken_w	<= ltu_res_w;
		
		-- bgeu
		WHEN ALU_BGEU	=>
			alu_res_r	<= (others => '0');
			brTaken_w	<= not ltu_res_w;
		
 	 	WHEN OTHERS	=>
			alu_res_r	<= (others => '0');
			brTaken_w	<= '0';
			
  END CASE;
		
END PROCESS;
	

	

---------------------------------------------------------------------------------------------------------
--Asigments:
	--rd_o		 <=	rd_i;
	RF_rs2_o	 <= forwarded_read_data2_w;--read_data2_i;
	--pc_plus4_o   <= pc_plus4_i;
	--pc_o		 <=pc_i;
	alu_res_o <= alu_res_r;
	Branch_or_jal_o	<= Jal_ctrl_i or (brTaken_w AND Branch_ctrl_i );
	--------------------------------------------------------------------------------------------------------
	-- Branch Address Adder
	-- addr_gen_o = pc_i + (sign_extend_i << 2)
	--------------------------------------------------------------------------------------------------------					  
	addr_gen_o	<= pc_i(PC_WIDTH-1 DOWNTO 0) + (sign_extend_i(PC_WIDTH-3 DOWNTO 0) & '0');
	--------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
 
END struct;

