LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
USE work.aux_package.all;
-------------------------------------
entity DataPath is
	generic(DataSize: INTEGER := 16;
			AddReg : INTEGER :=4;
			AddData: INTEGER :=6;
			dept : INTEGER :=64);
	port(clk, rst : in std_logic;
		--From Control:
		DTCM_wr_i,Cin_i,Cout_i,DTCM_addr_in_i,DTCM_out_i,Ain_i,RFin_i,RFout_i,IRin_i,PCin_i,Imm1_in_i,Imm2_in_i : in std_logic;		
		ALUFN_i : in std_logic_vector(3 downto 0);
		RFaddr_rd_i,RFaddr_wr_i,PCsel_i : in std_logic_vector(1 downto 0);
		
		--To Control:
		mov_o,done_in_o,and_o,or_o,xor_o,jnc_o,jc_o,jmp_o,sub_o,add_o,Nflag_o,Zflag_o,Cflag_o,ld_o,st_o : out std_logic;
		
		---DataMemory TB:
		TBactive: in std_logic;
		DTCM_tb_addr_out,DTCM_tb_addr_in : in std_logic_vector(AddData-1 downto 0);
		DTCM_tb_in : in std_logic_vector(DataSize-1 downto 0);
		DTCM_tb_wr : in std_logic;
		DTCM_tb_out :out std_logic_vector(DataSize-1 downto 0);
		---ProgramMemory TB:
		ITCM_tb_wr : in std_logic;
		ITCM_tb_in :in std_logic_vector(DataSize-1 downto 0);
		ITCM_tb_addr_in :in std_logic_vector(AddData-1 downto 0));
 
end DataPath;
----------------------------------------------
architecture dp of DataPath is
	signal busData_w : std_logic_vector(DataSize-1 downto 0):= (others => '0');
	signal ALUtoC_w : std_logic_vector(DataSize-1 downto 0);
	signal AtoALU_w,CtoBus_w,Imm1toBus_w,Imm2toBus_w,RFtoBus_w : std_logic_vector(DataSize-1 downto 0);
	signal RaAddress_w,RbAddress_w,RcAddress_w,WriteAddrRF_w,ReadAddrRF_w : std_logic_vector(AddReg-1 downto 0);
	--signal for flags:
	signal Zflag_w,Cflag_w,Nflag_w : std_logic;
	signal Zflag_q,Cflag_q,Nflag_q : std_logic;
	---Merge to IR<7....0> go to PC.
	signal rbAndrc_w : std_logic_vector(7 downto 0);
	signal opIRtoALU_w :std_logic_vector(3 downto 0);
	
	-------------- ProgramMemory--------------------------------------------
	--From Pc to Program Memory:
	signal cpu_ReadAddrProgMem_w :std_logic_vector(AddData-1 downto 0);
	--ProgramMemory to IR:
	signal cpu_dataOutProgramMem_w : std_logic_vector(DataSize-1 downto 0);
	-------------------------------------------------------------------------
	
	----------------- DataMemory:--------------------------------------------
	--Flop to DataMemory.
	signal cpu_writeAddrDataMEM_w :std_logic_vector(AddData-1 downto 0);
	---Out Data Memory:
	--Data Memory to Bus:
	signal cpu_dataOutDataMem_w : std_logic_vector(DataSize-1 downto 0);
    -------------------------------------------------------------------------
	
	---signal use to the MUX:
	signal final_readAddrDataMEM_w,final_writeAddrDataMEM_w : std_logic_vector(AddData-1 downto 0);
	signal final_datainDataMEM_w : std_logic_vector(DataSize-1 downto 0);
	signal final_wrenDataMEM_w : std_logic;
------------------------------------------------------------------------------------
	--bus signals:
	signal bustoRF_w : std_logic_vector(DataSize-1 downto 0);
	
	--------------------------
	begin	
	---Merge to IR<7....0> go to PC.
	 rbAndrc_w <= RbAddress_w & RcAddress_w;	
	 
	 --The sign Ext IR<7...0> , <3..0> go to Tristate:
	 Imm1toBus_w(7 downto 0)  <= rbAndrc_w;
	 Imm1toBus_w(15 downto 8) <= (others => RbAddress_w(AddReg-1)); -- Sign Ext
	
	 Imm2toBus_w(3 downto 0)  <= RcAddress_w;
	 Imm2toBus_w(15 downto 4) <= (others => RcAddress_w(AddReg-1)); -- Sign Ext
	 ------------------------------------------------------------
	 	 
	 ---Temp signal
	 --opIRtoALU_w <=ALUFN_i;
	 
	--Right side (exist in DataPath ) Left side (original moudle).
----------------------------------------- PORT MAPS --------------------------------------------	
	UnitA: RegisterA          generic map(Dwidth => DataSize)               PORT map(clk=>clk, rst=>rst,Ain_i=>Ain_i, DataIn_i=>busData_w , DataOut_o=>AtoALU_w );
	
	UnitC: RegisterC          generic map(Dwidth=>DataSize)                 PORT map(clk=>clk ,rst=>rst,Cin_i=>Cin_i,DataIn_i=>ALUtoC_w,DataOut_o=>CtoBus_w);
	
	UnitALU: ALU              generic map(length=>DataSize)                 PORT map(a_i=>AtoALU_w, b_i=>busData_w, ALUFN_i=>ALUFN_i, res_o=>ALUtoC_w,
																					Z_flag_o=>Zflag_w, C_flag_o=>Cflag_w, N_flag_o=>Nflag_w);
	
	UnitFlipFlop: DFlop       generic map(Dwidth=>DataSize)                 PORT map(clk=>clk, rst=>rst ,ena=>DTCM_addr_in_i,DataIn_i=>busData_w,
																						DataOut_o=>cpu_writeAddrDataMEM_w);
	
	UnitIR: IR                generic map(Awidth=>AddReg, Dwidth=>DataSize) PORT map(clk=>clk, rst=>rst, IRin_i=>IRin_i,DataIn_i=>cpu_dataOutProgramMem_w,
																						OPC_o=>opIRtoALU_w, Ra_o=>RaAddress_w, Rb_o=>RbAddress_w, Rc_o=>RcAddress_w);
							
	UnitRF : RF               generic map(Dwidth=>DataSize,Awidth=>AddReg)  PORT map(clk=>clk, rst=>rst, WregEn=>RFin_i, WregData=>bustoRF_w,
																						WregAddr=>WriteAddrRF_w , RregAddr=>ReadAddrRF_w, RregData=>RFtoBus_w);
							
	UnitDecode: OPcodeDecoder generic map(Size=>AddReg)                     PORT map(Opc_i=>opIRtoALU_w,add_o=>add_o,sub_o=>sub_o,and_o=>and_o,or_o=>or_o,
																						xor_o=>xor_o,jmp_o=>jmp_o,jc_o=>jc_o,jnc_o=>jnc_o,mov_o=>mov_o,
																						ld_o=>ld_o,st_o=>st_o,done_op_o=>done_in_o);
																
	UnitPC: ProgramCounter    generic map(Awidth=>AddData)                  PORT map(clk=>clk,rst=>rst,PCin_i=>PCin_i,PCsel_i=>PCsel_i,
																						IRoffset_i=>rbAndrc_w, PCout_o=>cpu_ReadAddrProgMem_w);
																						
																						
																						
	UnitProgramMemory : progMem   generic map(Dwidth=>DataSize, Awidth=>AddData, dept=>dept) PORT map(clk=>clk, memEn=>ITCM_tb_wr,
	
																										WmemData=>ITCM_tb_in, WmemAddr=>ITCM_tb_addr_in,
																										
																										RmemAddr=>cpu_ReadAddrProgMem_w,
																										
																										RmemData=>cpu_dataOutProgramMem_w);
	
	---Almost all the entiry comes from The MUX.
	UnitDataMemory : dataMem      generic map(Dwidth=>DataSize, Awidth=>AddData, dept=>dept) PORT map(clk=>clk, memEn=>final_wrenDataMEM_w,
	
																										WmemData=>final_datainDataMEM_w,
																										
																										WmemAddr=>final_writeAddrDataMEM_w,
																										
																										RmemAddr=>final_readAddrDataMEM_w,
																										
																										RmemData=>cpu_dataOutDataMem_w);																					

----------------------------------------- Tristate --------------------------------------------	
	TristateC: BidirPin	    generic map(width=>DataSize) PORT map(Dout=>CtoBus_w, en=>Cout_i, Din=>open, IOpin=>busData_w);
	
	TristateDTCM: BidirPin	generic map(width=>DataSize) PORT map(Dout=>cpu_dataOutDataMem_w, en=>DTCM_out_i, Din=>open, IOpin=>busData_w);
	
	TristateRF: BidirPin	generic map(width=>DataSize) PORT map(Dout=>RFtoBus_w, en=>RFout_i, Din=>bustoRF_w, IOpin=>busData_w);
	
	TristateImm1: BidirPin	generic map(width=>DataSize) PORT map(Dout=>Imm1toBus_w, en=>Imm1_in_i, Din=>open, IOpin=>busData_w);
	
	TristateImm2: BidirPin	generic map(width=>DataSize) PORT map(Dout=>Imm2toBus_w, en=>Imm2_in_i, Din=>open, IOpin=>busData_w);
	
----------------------------------------MUX between IR and RF-----------------------------------------------------
	with RFaddr_wr_i select	
		WriteAddrRF_w <= RaAddress_w when "10",
					   RbAddress_w when "01",
					   RcAddress_w when "00",
					 (others=> '0') when others;					
		
	with RFaddr_rd_i select	
		ReadAddrRF_w <=	RaAddress_w when "00",
					   RbAddress_w when "01",
					   RcAddress_w when "10",
					 (others=> '0') when others;		
----------------------MUX Between TB to CPU for DataMEM----------------------------
	--First MUX readAddr entiry in DataMemory.
	with TBactive select
	final_readAddrDataMEM_w <= DTCM_tb_addr_out when '1',
							busData_w(AddData-1 downto 0) when others;
	
	--second MUX wrireAddr entiry in DataMemory.
	with TBactive select
	final_writeAddrDataMEM_w <= DTCM_tb_addr_in when '1',
							cpu_writeAddrDataMEM_w when others;
							
	--Third MUX datain entiry in DataMemory.
	with TBactive select
	final_datainDataMEM_w <= DTCM_tb_in when '1',
							busData_w when others;
							
	--Fourth MUX wren entiry in DataMemory.
	with TBactive select
	final_wrenDataMEM_w <= DTCM_tb_wr when '1',
						 DTCM_wr_i when others;	
						
	
	--------------------process for the flags:----------------------
	process(clk, rst)
	begin
		if rst = '1' then
			zflag_q <= '0';
			cflag_q <= '0';
			nflag_q <= '0';

		elsif rising_edge(clk) then
			if Cin_i = '1' then
				zflag_q <= zflag_w;
				cflag_q <= cflag_w;
				nflag_q <= nflag_w;
			end if;
		end if;
	end process;
	--output falgs:
	Zflag_o <= zflag_q;
	Cflag_o <= cflag_q;
	Nflag_o <= nflag_q;
	
	----------------------------------------------------------------
	---Only for TB:
	DTCM_tb_out <= cpu_dataOutDataMem_w;








end dp;		


