LIBRARY ieee;
USE ieee.std_logic_1164.all;

package aux_package is
	constant dataMemResult:	 	string(1 to 67) :=
		"C:\Users\yoavt\ModelSim\Lab3\Task3\SW-QA\Ex1\output\DTCMcontent.txt";
	
		constant dataMemLocation: 	string(1 to 61) :=
		"C:\Users\yoavt\ModelSim\Lab3\Task3\SW-QA\Ex1\bin\DTCMinit.txt";
	
		constant progMemLocation: 	string(1 to 61) :=
		"C:\Users\yoavt\ModelSim\Lab3\Task3\SW-QA\Ex1\bin\ITCMinit.txt";
-----------------------------------------------------------------
component OpcodeDecoder is
	generic( Size : integer :=4);
	port(Opc_i : in  std_logic_vector(Size-1 downto 0);
	     add_o,sub_o,and_o,or_o,xor_o,jmp_o,jc_o,jnc_o,mov_o,ld_o,st_o,done_op_o :out std_logic);
		  ---IN real time Task need to add another bit output.
 end  component;
 ----------------------------------------------------------------
 component Adder IS
  GENERIC (length : INTEGER := 16);
  PORT ( a_i, b_i: IN STD_LOGIC_VECTOR (length-1 DOWNTO 0);
          cin_i: IN STD_LOGIC;
            s_o: OUT STD_LOGIC_VECTOR (length-1 DOWNTO 0);
         cout_o: OUT STD_LOGIC);
END component;
-------------------------------------------------------------------
component ALU is
		GENERIC (length : INTEGER := 16);
		PORT ( a_i, b_i: IN STD_LOGIC_VECTOR (length-1 DOWNTO 0);
          ALUFN_i :IN STD_LOGIC_VECTOR (3 downto 0);
            res_o: OUT STD_LOGIC_VECTOR (length-1 DOWNTO 0);
         Z_flag_o,C_flag_o,N_flag_o : out std_logic);
END component;
-------------------------------------------------------------------
 component ProgramCounter is
		generic( Awidth: integer:=6);
		port( clk,rst,PCin_i : in std_logic;
			  -- 2-bit MUX selector
			  PCsel_i : in std_logic_vector(1 downto 0);
			  --IR<7...0>
			  IRoffset_i :in std_logic_vector(7 downto 0);
			  --Go to progamMemory (readAddr)
			  PCout_o: out std_logic_vector(Awidth-1 downto 0));
END component;
 -------------------------------------------------------------------
 component IR is 
	generic( Awidth: integer:=4;			
			Dwidth: integer:=16);
	port( clk,rst : in std_logic;
			--From the Control
			IRin_i : in std_logic;
			--From ProgramMemory
			DataIn_i : in std_logic_vector(Dwidth-1 downto 0);
			OPC_o :Out std_logic_vector(Awidth-1 downto 0);
			Ra_o,Rb_o,Rc_o : Out std_logic_vector(Awidth-1 downto 0));
end component;
 -------------------------------------
component RegisterA IS 
		generic(Dwidth: integer:=16);
		port( clk,rst : in std_logic;
			--From the Control
			Ain_i : in std_logic;
			--From BUS
			DataIn_i : in std_logic_vector(Dwidth-1 downto 0);
			
			DataOut_o : Out std_logic_vector(Dwidth-1 downto 0));
end component;
-------------------------------------------------
 component RegisterC IS 
		generic(Dwidth: integer:=16);
		port( clk,rst : in std_logic;
			--From the Control
			Cin_i : in std_logic;
			--From ALU
			DataIn_i : in std_logic_vector(Dwidth-1 downto 0);
			--Go to Tristate
			DataOut_o : Out std_logic_vector(Dwidth-1 downto 0));
end component;
-----------------------------------------
 component Control IS
	port(rst,ena,clk : in std_logic;
		 mov_i,done_i,and_i,or_i,xor_i,jnc_i,jc_i,jmp_i,sub_i,add_i,Nflag_i,Zflag_i,Cflag_i,ld_i,st_i : in std_logic;
		 done_o :out std_logic;
		 DTCM_wr_o,Cin_o,Cout_o,DTCM_addr_in_o,DTCM_out_o,Ain_o,RFin_o,RFout_o,IRin_o,PCin_o,Imm1_in_o,Imm2_in_o : out std_logic;
		 ALUFN_o : out std_logic_vector(3 downto 0);
		 RFaddr_rd_o : out std_logic_vector(1 downto 0);
		 RFaddr_wr_o : out std_logic_vector(1 downto 0);
		 PCsel_o : out std_logic_vector(1 downto 0));
end component;
 ---------------------------------------------
 component Dflop is 
	generic( Dwidth: integer:=16);
	port(clk,rst,ena : in std_logic;
		DataIn_i : in std_logic_vector(Dwidth-1 downto 0);
		DataOut_o : out std_logic_vector(5 downto 0));
end component;
 -------------------------------------------------------------
 component DataPath is
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
 
end component;
------------------------------------------------------------------
component BidirPin is
	generic( width: integer:=16 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
end component;
 --------------------------------------------------------------------
 component RF is
	generic( Dwidth: integer:=16;
		 Awidth: integer:=4);
	port(	clk,rst,WregEn: in std_logic;	
		WregData:	in std_logic_vector(Dwidth-1 downto 0);
		WregAddr,RregAddr:	
					in std_logic_vector(Awidth-1 downto 0);
		RregData: 	out std_logic_vector(Dwidth-1 downto 0)
	);
end component;
 -----------------------------------------------------------------------------
 component top is
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

end component;
--------------------------------------------------------------------------------
component ProgMem is
	generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
	port(	clk,memEn: in std_logic;	
		WmemData:	in std_logic_vector(Dwidth-1 downto 0);
		WmemAddr,RmemAddr:	
					in std_logic_vector(Awidth-1 downto 0);
		RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
	);
end component;
--------------------------------------------------------------------------------
component dataMem is
	generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
	port(	clk,memEn: in std_logic;	
		WmemData:	in std_logic_vector(Dwidth-1 downto 0);
		WmemAddr,RmemAddr:	
					in std_logic_vector(Awidth-1 downto 0);
		RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
	);
end component;
 -----------------------------------------------------------------------------
component tb_Datapath is
		generic(DataSize: INTEGER := 16;
			AddReg : INTEGER :=4;
			AddData: INTEGER :=6;
			dept : INTEGER :=64);
end component; 
----------------------------------------------------------------
component tb_top is
    generic(
        DataSize: INTEGER := 16;
			AddReg : INTEGER :=4;
			AddData: INTEGER :=6;
			dept : INTEGER :=64);		
end component;



 end aux_package;
