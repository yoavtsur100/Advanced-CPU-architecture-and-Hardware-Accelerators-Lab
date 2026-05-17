library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

---------------------------------------------------------
-- checks the Datapath unit. 
---------------------------------------------------------
entity tb_Datapath is
    generic(DataSize: INTEGER := 16;
        AddReg : INTEGER :=4;
        AddData: INTEGER :=6;
        dept : INTEGER :=64);
end tb_Datapath;
---------------------------------------------------------
architecture tbdp of tb_Datapath is
    
    -- Inputs (Initialized to 0)
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    
    signal DTCM_wr_i, Cin_i, Cout_i, DTCM_addr_in_i, DTCM_out_i : std_logic := '0';
    signal Ain_i, RFin_i, RFout_i, IRin_i, PCin_i, Imm1_in_i, Imm2_in_i : std_logic := '0';
    signal ALUFN_i : std_logic_vector(3 downto 0) := (others => '0');
    signal RFaddr_rd_i, RFaddr_wr_i, PCsel_i : std_logic_vector(1 downto 0) := (others => '0');
    
    signal TBactive : std_logic := '0';
    signal DTCM_tb_addr_out, DTCM_tb_addr_in, ITCM_tb_addr_in : std_logic_vector(5 downto 0) := (others => '0');
    signal DTCM_tb_in, ITCM_tb_in : std_logic_vector(15 downto 0) := (others => '0');
    signal DTCM_tb_wr, ITCM_tb_wr : std_logic := '0';

    -- Outputs
    signal mov_o, done_in_o, and_o, or_o, xor_o, jnc_o, jc_o, jmp_o, sub_o, add_o : std_logic;
    signal Nflag_o, Zflag_o, Cflag_o, ld_o, st_o : std_logic;
    signal DTCM_tb_out : std_logic_vector(15 downto 0);
    
    begin
    
    -- Instantiation directly relying on aux_package
    UnitDataPath: Datapath   
        generic map(DataSize=>DataSize, AddReg=>AddReg, AddData=>AddData, dept=>dept) 
        PORT map(
            clk=>clk, rst=>rst, DTCM_wr_i=>DTCM_wr_i, Cin_i=>Cin_i, Cout_i=>Cout_i, DTCM_addr_in_i=>DTCM_addr_in_i,
            DTCM_out_i=>DTCM_out_i, Ain_i=>Ain_i, RFin_i=>RFin_i, RFout_i=>RFout_i,IRin_i=>IRin_i, PCin_i=>PCin_i,
            Imm1_in_i=>Imm1_in_i, Imm2_in_i=>Imm2_in_i, ALUFN_i=>ALUFN_i, RFaddr_rd_i=>RFaddr_rd_i, RFaddr_wr_i=>RFaddr_wr_i,
            PCsel_i=>PCsel_i, mov_o=>mov_o, done_in_o=>done_in_o, and_o=>and_o, or_o=>or_o, xor_o=>xor_o, jnc_o=>jnc_o, jc_o=>jc_o,
            jmp_o=>jmp_o, sub_o=>sub_o, add_o=>add_o, Nflag_o=>Nflag_o, Zflag_o=>Zflag_o, Cflag_o=>Cflag_o, ld_o=>ld_o, st_o=>st_o,
            TBactive=>TBactive , DTCM_tb_addr_out=>DTCM_tb_addr_out ,DTCM_tb_addr_in=> DTCM_tb_addr_in, DTCM_tb_in=> DTCM_tb_in,
            DTCM_tb_wr=>DTCM_tb_wr , DTCM_tb_out=>DTCM_tb_out , ITCM_tb_wr=>ITCM_tb_wr ,ITCM_tb_in=> ITCM_tb_in,ITCM_tb_addr_in=>ITCM_tb_addr_in
        );
                                    
    --------- start of stimulus section ------------------  
    rst <= '1','0' after 100 ns ;
        
    generate_clk : process    -- Clk process (duty cycle of 50% and period of 100 ns)
    begin
        clk <= '1';
        wait for 50 ns;
        clk <= not clk;
        wait for 50 ns;
    end process;

    --------------- Commands ---------------------
    movadd_cmd : process
    begin   
        wait until rst = '0';
        wait until falling_edge(clk); 
        ITCM_tb_wr <= '1';
        ITCM_tb_addr_in <= "000000"; ITCM_tb_in <= x"C104"; wait until falling_edge(clk);
        ITCM_tb_addr_in <= "000001"; ITCM_tb_in <= x"C208"; wait until falling_edge(clk);
        ITCM_tb_addr_in <= "000010"; ITCM_tb_in <= x"0321"; wait until falling_edge(clk);
        ITCM_tb_addr_in <= "000011"; ITCM_tb_in <= x"9004"; wait until falling_edge(clk);
        ITCM_tb_wr <= '0';
        -----------------------
		
        -------- Fetch------------:
        IRin_i <= '1'; 
        PCsel_i <= "00"; 
        PCin_i <= '1'; 
        wait until rising_edge(clk);
		wait for 10 ns;		
        IRin_i <= '0';
        PCin_i <= '0';
		-----------------------------
        --------------mov-----------------
        -- write to RF:
		wait until rising_edge(clk);
		wait for 10 ns;
        Imm1_in_i <= '1';       
        RFaddr_wr_i <= "10";    
        RFin_i <= '1'; 
		
		wait until rising_edge(clk);
		wait for 10 ns;
        RFin_i <= '0';
        Imm1_in_i <= '0'; 
		-----------------------------------------
		
		
		wait until rising_edge(clk);
        
        -------- Fetch------------:
        IRin_i <= '1'; 
        PCsel_i <= "00"; 
        PCin_i <= '1'; 
        wait until rising_edge(clk);
		wait for 10 ns;
        IRin_i <= '0';
        PCin_i <= '0';
		----------------------------
        --------------mov-----------------
        -- write to RF:
		wait until rising_edge(clk);
		wait for 10 ns;
        Imm1_in_i <= '1';       
        RFaddr_wr_i <= "10";    
        RFin_i <= '1'; 
		
		wait until rising_edge(clk);
		wait for 10 ns;
        RFin_i <= '0';
        Imm1_in_i <= '0';
		-----------------------------------------
  
		wait until rising_edge(clk);
		
        -------- Fetch------------:
        IRin_i <= '1'; 
        PCsel_i <= "00"; 
        PCin_i <= '1'; 
        wait until rising_edge(clk);
		wait for 10 ns;		
        IRin_i <= '0';
        PCin_i <= '0';
		----------------------------
		
		---------------add----------
		RFaddr_rd_i <= "01";
		wait for 10 ns;
		RFout_i <= '1';
		wait for 10 ns;
		Ain_i <= '1';		
		wait until rising_edge(clk); 
		RFout_i <= '0';
		Ain_i <= '0';
		RFaddr_rd_i <= "10";
		wait for 10 ns;
		RFout_i <= '1';
		wait for 10 ns;
		Cin_i <= '1';
        wait until rising_edge(clk);
		RFout_i <= '0';
		Cin_i <= '0';
		wait for 10 ns;
		Cout_i <= '1';
        wait for 10 ns;
		RFaddr_wr_i <= "10"; 
		RFin_i <= '1'; 
		 wait until rising_edge(clk);
		 wait for 10 ns;
		 Cout_i <= '0';
		 RFin_i <= '0'; 
		 ---------------------------------
		 -------JNC 4--------------------
		 wait until rising_edge(clk);
		 IRin_i <= '1'; 
        PCsel_i <= "00"; 
        PCin_i <= '1'; 
        wait until rising_edge(clk); 
        IRin_i <= '0';
		PCsel_i <= "01";
		wait until rising_edge(clk);
		wait for 10 ns;		
		 PCin_i <= '0';
		-----------------------------
		 --


        wait;
    end process;
	

end tbdp;