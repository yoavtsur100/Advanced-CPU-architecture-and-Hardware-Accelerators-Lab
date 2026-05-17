library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
USE work.aux_package.all;
--------------------------------------------------------------------------
entity top is
	generic(DataSize: INTEGER := 16;
			AddReg : INTEGER :=4;
			AddData: INTEGER :=6;
			dept : INTEGER :=64);
	port(clk,rst,ena : in std_logic;
	       ---signal for TB :
			tp_TBactive_w : in std_logic;
			tp_DTCM_tb_addr_out_w,tp_DTCM_tb_addr_in_w : in std_logic_vector(AddData-1 downto 0);
			tp_DTCM_tb_in_w : in std_logic_vector(DataSize-1 downto 0);
			tp_DTCM_tb_out_w : out std_logic_vector(DataSize-1 downto 0);
			tp_DTCM_tb_wr_w : in std_logic;
			---ProgramMemory TB:
			tp_ITCM_tb_wr_w : in std_logic;
			tp_ITCM_tb_in_w : in  std_logic_vector(DataSize-1 downto 0);
		    tp_ITCM_tb_addr_in_w : in std_logic_vector(AddData-1 downto 0);
		done : out std_logic);

end top;
--------------------------------------------------------------------------
architecture tp of top is	
	---signal use to Control and DataPath:
	signal tp_mov_w,tp_done_w,tp_and_w,tp_or_w,tp_xor_w,tp_jnc_w,tp_jc_w,tp_jmp_w,tp_sub_w,tp_add_w,tp_Nflag_w,tp_Zflag_w,tp_Cflag_w,tp_ld_w,tp_st_w,done_FSM_w : std_logic;
	signal tp_DTCM_wr_w,tp_Cin_w,tp_Cout_w,tp_DTCM_addr_in_w,tp_DTCM_out_w,tp_Ain_w,tp_RFin_w,tp_RFout_w,tp_IRin_w,tp_PCin_w,tp_Imm1_in_w,tp_Imm2_in_w : std_logic;
	signal tp_ALUFN_w : std_logic_vector(3 downto 0);
	signal tp_RFaddr_rd_w,tp_RFaddr_wr_w,tp_PCsel_w : std_logic_vector(1 downto 0);
	
begin

	--Right side (exist in TOP ) Left side (original moudle).
--------------------- PORT MAPS --------------------------------------------	
	UnitControl: control     PORT map(rst=>rst, ena=>ena, clk=>clk,mov_i=>tp_mov_w, done_i=>tp_done_w, and_i=>tp_and_w, or_i=>tp_or_w, xor_i=>tp_xor_w,
	
										jnc_i=>tp_jnc_w, jc_i=>tp_jc_w, jmp_i=>tp_jmp_w, sub_i=>tp_sub_w, add_i=>tp_add_w, Nflag_i=>tp_Nflag_w, Zflag_i=>tp_Zflag_w, Cflag_i=>tp_Cflag_w,
										
										ld_i=>tp_ld_w, st_i=>tp_st_w, done_o=>done_FSM_w, DTCM_wr_o=>tp_DTCM_wr_w, Cin_o=>tp_Cin_w,Cout_o=>tp_Cout_w,DTCM_addr_in_o=>tp_DTCM_addr_in_w,
										
										DTCM_out_o=>tp_DTCM_out_w, Ain_o=>tp_Ain_w, RFin_o=>tp_RFin_w, RFout_o=>tp_RFout_w, IRin_o=>tp_IRin_w, PCin_o=>tp_PCin_w, Imm1_in_o=>tp_Imm1_in_w,
										
										Imm2_in_o=>tp_Imm2_in_w, ALUFN_o=>tp_ALUFN_w, RFaddr_rd_o=>tp_RFaddr_rd_w, RFaddr_wr_o=>tp_RFaddr_wr_w, PCsel_o=>tp_PCsel_w);
	
	
	UnitDataPath: Datapath   generic map(DataSize=>DataSize, AddReg=>AddReg, AddData=>AddData, dept=>dept) 
	
							 PORT map(clk=>clk, rst=>rst, DTCM_wr_i=>tp_DTCM_wr_w, Cin_i=>tp_Cin_w, Cout_i=>tp_Cout_w, DTCM_addr_in_i=>tp_DTCM_addr_in_w,
							
									DTCM_out_i=>tp_DTCM_out_w, Ain_i=>tp_Ain_w, RFin_i=>tp_RFin_w, RFout_i=>tp_RFout_w,IRin_i=>tp_IRin_w, PCin_i=>tp_PCin_w,
									
									Imm1_in_i=>tp_Imm1_in_w, Imm2_in_i=>tp_Imm2_in_w, ALUFN_i=>tp_ALUFN_w, RFaddr_rd_i=>tp_RFaddr_rd_w, RFaddr_wr_i=>tp_RFaddr_wr_w,
									
									PCsel_i=>tp_PCsel_w, mov_o=>tp_mov_w, done_in_o=>tp_done_w, and_o=>tp_and_w, or_o=>tp_or_w, xor_o=>tp_xor_w, jnc_o=>tp_jnc_w, jc_o=>tp_jc_w,
									
									jmp_o=>tp_jmp_w, sub_o=>tp_sub_w, add_o=>tp_add_w, Nflag_o=>tp_Nflag_w, Zflag_o=>tp_Zflag_w, Cflag_o=>tp_Cflag_w, ld_o=>tp_ld_w, st_o=>tp_st_w,
							
									TBactive=>tp_TBactive_w , DTCM_tb_addr_out=>tp_DTCM_tb_addr_out_w ,DTCM_tb_addr_in=> tp_DTCM_tb_addr_in_w, DTCM_tb_in=> tp_DTCM_tb_in_w,

									DTCM_tb_wr=>tp_DTCM_tb_wr_w , DTCM_tb_out=>tp_DTCM_tb_out_w , ITCM_tb_wr=>tp_ITCM_tb_wr_w ,ITCM_tb_in=> tp_ITCM_tb_in_w,ITCM_tb_addr_in=>tp_ITCM_tb_addr_in_w);


	


	done<=done_FSM_w;
end tp;