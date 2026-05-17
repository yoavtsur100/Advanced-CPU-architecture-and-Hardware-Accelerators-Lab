library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all; 
use IEEE.STD_LOGIC_TEXTIO.all;
USE work.aux_package.all;

entity tb_top is
    generic(
        DataSize: INTEGER := 16;
			AddReg : INTEGER :=4;
			AddData: INTEGER :=6;
			dept : INTEGER :=64
			
			);
		constant dataMemResult : string(1 to 67) :=
		"C:\Users\yoavt\ModelSim\Lab3\Task3\SW-QA\Ex6\output\DTCMcontent.txt";
		--DTCMcontent.txt 67 string
		constant dataMemLocation: 	string(1 to 61) :=
		"C:\Users\yoavt\ModelSim\Lab3\Task3\SW-QA\Ex6\bin\DTCMinit.txt";
	
		constant progMemLocation: 	string(1 to 61) :=
		"C:\Users\yoavt\ModelSim\Lab3\Task3\SW-QA\Ex6\bin\ITCMinit.txt";	
			
end tb_top;

architecture beh of tb_top is
--zero initializing
    signal clk, rst, ena : std_logic := '0';
    signal tp_TBactive_w : std_logic := '1';
    signal tp_DTCM_tb_addr_out_w, tp_DTCM_tb_addr_in_w : std_logic_vector(AddData-1 downto 0) := (others => '0');
    signal tp_DTCM_tb_in_w : std_logic_vector(DataSize-1 downto 0) := (others => '0');
    signal tp_DTCM_tb_out_w : std_logic_vector(DataSize-1 downto 0);
    signal tp_DTCM_tb_wr_w : std_logic := '0';
    signal tp_ITCM_tb_wr_w : std_logic := '0';
    signal tp_ITCM_tb_in_w : std_logic_vector(DataSize-1 downto 0) := (others => '0');
    signal tp_ITCM_tb_addr_in_w : std_logic_vector(AddData-1 downto 0) := (others => '0');
    signal done : std_logic;
	SIGNAL donePmemIn, doneDmemIn:	BOOLEAN;
	signal dataCount : INTEGER := 0;

begin
 
	UnitTop : top generic map(DataSize => DataSize, Addreg => AddReg , AddData=> AddData , dept => dept)   port map(clk => clk, rst => rst, ena => ena, 
																													tp_TBactive_w => tp_TBactive_w,
																													tp_DTCM_tb_addr_out_w => tp_DTCM_tb_addr_out_w,
																													tp_DTCM_tb_addr_in_w => tp_DTCM_tb_addr_in_w,
																													tp_DTCM_tb_in_w => tp_DTCM_tb_in_w,
																													tp_DTCM_tb_out_w => tp_DTCM_tb_out_w,
																													tp_DTCM_tb_wr_w => tp_DTCM_tb_wr_w,
																													tp_ITCM_tb_wr_w => tp_ITCM_tb_wr_w,
																													tp_ITCM_tb_in_w => tp_ITCM_tb_in_w,
																													tp_ITCM_tb_addr_in_w => tp_ITCM_tb_addr_in_w, done => done);

----------------------------------------------------------------------------------------------------------

    process
    begin
        clk <= '1'; wait for 50 ns;
        clk <= '0'; wait for 50 ns;
    end process;
	
	
	 ---------------------------------------------------------
    -- Process to load program Memory (ITCM) from file
    ---------------------------------------------------------	
    load_ITCM : process
        file itcm_file : text open read_mode is progMemLocation;
        variable L : line;
        variable hex_val : std_logic_vector(DataSize-1 downto 0);
        variable addr : integer := 0;
    begin
        donePmemIn <= false;
        tp_ITCM_tb_wr_w <= '0';
        wait until rst = '0'; -- 
        
        while not endfile(itcm_file) loop
            readline(itcm_file, L);
            hread(L, hex_val);
            
            tp_ITCM_tb_addr_in_w <= conv_std_logic_vector(addr, AddData);
            tp_ITCM_tb_in_w <= hex_val;
            tp_ITCM_tb_wr_w <= '1';
            
            wait until rising_edge(clk);
            addr := addr + 1;
        end loop;
        tp_ITCM_tb_wr_w <= '0';
        donePmemIn <= true; 
        wait;
    end process;

    ---------------------------------------------------------
    -- Process to load Data Memory (DTCM) from file
    ---------------------------------------------------------
    load_DTCM : process
        file dtcm_file : text open read_mode is dataMemLocation;
        variable L : line;
        variable hex_val : std_logic_vector(DataSize-1 downto 0);
        variable addr : integer := 0;
    begin
        doneDmemIn <= false;
        tp_DTCM_tb_wr_w <= '0';
        wait until rst = '0';
        
        while not endfile(dtcm_file) loop
            readline(dtcm_file, L);
            hread(L, hex_val);
            
            tp_DTCM_tb_addr_in_w <= conv_std_logic_vector(addr, AddData);
            tp_DTCM_tb_in_w <= hex_val;
            tp_DTCM_tb_wr_w <= '1';
            
            wait until rising_edge(clk);
            addr := addr + 1;
        end loop;
        
        tp_DTCM_tb_wr_w <= '0';
        doneDmemIn <= true;
		dataCount <= addr;
        wait;
    end process;

	---------------------------------------------------------
    -- Main TB Control Process
    ---------------------------------------------------------
    gen_TB : process
    begin
        rst <= '1';
        ena <= '0';
        tp_TBactive_w <= '1'; --
        wait for 110 ns;
        rst <= '0';
        
     
       while (not donePmemIn or not doneDmemIn) loop
        wait on donePmemIn, doneDmemIn;
		end loop;
        
        wait until falling_edge(clk);
        tp_TBactive_w <= '0'; 
        ena <= '1';
        
       
        wait until done = '1';
        ena <= '0';
        
      
        tp_TBactive_w <= '1'; 
        wait;
    end process;

    ---------------------------------------------------------
    -- Process to write DTCM Content to output file after done
    ---------------------------------------------------------
    write_DTCM_Results : process
    file out_file : text open write_mode is dataMemResult;
    variable L : line;
	begin
		--report "WRITE PROCESS STARTED";

		wait until done = '1';
		--report "DONE DETECTED";

		wait until tp_TBactive_w = '1';
		--report "TB ACTIVE DETECTED";

		for i in 0 to dataCount-1 loop
			--report "WRITING LINE";

			tp_DTCM_tb_addr_out_w <= conv_std_logic_vector(i, AddData);

			wait until rising_edge(clk);
			wait for 1 ns;

			L := null;
			hwrite(L, tp_DTCM_tb_out_w);
			writeline(out_file, L);
		end loop;

		--report "FINISHED WRITING";
		wait;
	end process;

	
end beh;