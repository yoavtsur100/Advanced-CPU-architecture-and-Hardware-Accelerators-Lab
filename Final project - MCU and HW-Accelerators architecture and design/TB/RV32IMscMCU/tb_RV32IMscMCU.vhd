library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.cond_compilation_package.all;
use work.aux_package.all;

entity tb_RV32IMscMCU is
	generic( 
		WORD_GRANULARITY 	: boolean 	:= G_WORD_GRANULARITY;
		MODELSIM 			: integer 	:= G_MODELSIM;
		DATA_BUS_WIDTH 		: integer 	:= 32;
		ITCM_ADDR_WIDTH 	: integer 	:= G_ADDRWIDTH;
		DTCM_ADDR_WIDTH 	: integer 	:= G_ADDRWIDTH;
		PC_WIDTH 			: integer 	:= G_PC_WIDTH;
		MA_WIDTH 			: integer 	:= G_MA_WIDTH;
		DATA_WORDS_NUM 		: integer 	:= G_DATA_WORDSNUM;
		CLK_CNT_WIDTH 		: integer 	:= 16
	);
end tb_RV32IMscMCU ;

architecture struct of tb_RV32IMscMCU is
	--Inputs
	signal rst_i		: std_logic;
	signal clk_i		: std_logic;
	
	-- Board Ports mapping
	signal KEY          : std_logic_vector(3 downto 0) := (others => '1');
	signal SW           : std_logic_vector(9 downto 0) := (others => '0');
	signal LEDR         : std_logic_vector(9 downto 0);
	signal HEX0         : std_logic_vector(6 downto 0);
	signal HEX1         : std_logic_vector(6 downto 0);
	signal HEX2         : std_logic_vector(6 downto 0);
	signal HEX3         : std_logic_vector(6 downto 0);
	signal HEX4         : std_logic_vector(6 downto 0);
	signal HEX5         : std_logic_vector(6 downto 0);
	signal GPIO         : std_logic_vector(39 downto 0) := (others => 'Z');
	
	--Outputs (used for Verification and FPGA Validation(Signal-TAP))
	signal pc_o			: std_logic_vector(PC_WIDTH-1 DOWNTO 0);
	signal instruction_o: std_logic_vector(DATA_BUS_WIDTH-1 DOWNTO 0);
	
	signal RegWrite_ctrl_o: std_logic;
	signal MemWrite_ctrl_o: std_logic;
	signal Branch_ctrl_o  : std_logic;
	
	signal read_data1_o : std_logic_vector(DATA_BUS_WIDTH-1 DOWNTO 0);
	signal read_data2_o : std_logic_vector(DATA_BUS_WIDTH-1 DOWNTO 0);
	signal write_data_o	: std_logic_vector(DATA_BUS_WIDTH-1 DOWNTO 0);
	
	signal alu_res_o 	: std_logic_vector(DATA_BUS_WIDTH-1 DOWNTO 0);															
	signal brTaken_o	: std_logic; 
	
	signal dtcm_addr_o	: std_logic_vector(DTCM_ADDR_WIDTH-1 DOWNTO 0);
	signal dtcm_data_wr_o: std_logic_vector(DATA_BUS_WIDTH-1 DOWNTO 0);
	signal dtcm_data_rd_o: std_logic_vector(DATA_BUS_WIDTH-1 DOWNTO 0);
	
	signal mclk_cnt_o	: std_logic_vector(CLK_CNT_WIDTH-1 DOWNTO 0);
   
begin

	-- Map active-high testbench reset to active-low KEY0 input
	KEY(0) <= not rst_i;

	TOP : entity work.FPGA_Top_SingleCycle
	generic map(
		WORD_GRANULARITY 	=> WORD_GRANULARITY,
		DATA_BUS_WIDTH		=> DATA_BUS_WIDTH,
		ITCM_ADDR_WIDTH		=> ITCM_ADDR_WIDTH,
		DTCM_ADDR_WIDTH		=> DTCM_ADDR_WIDTH,
		PC_WIDTH			=> PC_WIDTH,
		MA_WIDTH			=> MA_WIDTH,
		DATA_WORDS_NUM		=> DATA_WORDS_NUM,
		CLK_CNT_WIDTH		=> CLK_CNT_WIDTH
	)
	port map (
		--Inputs
		CLOCK_50        	=> clk_i,
		KEY             	=> KEY,
		SW              	=> SW,
		--Outputs
		LEDR            	=> LEDR,
		HEX0            	=> HEX0,
		HEX1            	=> HEX1,
		HEX2            	=> HEX2,
		HEX3            	=> HEX3,
		HEX4            	=> HEX4,
		HEX5            	=> HEX5,
		GPIO            	=> GPIO,
		
		-- Verification outputs
		pc_o				=> pc_o,
		instruction_o		=> instruction_o,
		
		RegWrite_ctrl_o		=> RegWrite_ctrl_o,
		MemWrite_ctrl_o		=> MemWrite_ctrl_o,
		Branch_ctrl_o		=> Branch_ctrl_o,
		
		read_data1_o 		=> read_data1_o,
		read_data2_o 		=> read_data2_o,
		write_data_o		=> write_data_o,
		
		alu_res_o 			=> alu_res_o,
		brTaken_o			=> brTaken_o,
		
		dtcm_addr_o			=> dtcm_addr_o,
		dtcm_data_wr_o		=> dtcm_data_wr_o,
		dtcm_data_rd_o		=> dtcm_data_rd_o,
		
		mclk_cnt_o			=> mclk_cnt_o
	);	
--------------------------------------------------------------------	
	gen_clk : -- MCLK cycle = 100nsec = 0.1usec
	process
	begin
		clk_i <= '1';
		wait for 50 ns;
		clk_i <= not clk_i;
		wait for 50 ns;
	end process;
  
	gen_rst : 
	process
	begin
		rst_i <='1','0' after 150 ns;
		wait;
	end process;
	
	gen_sw :
	process
	begin
		SW <= "0000000000"; -- Keep SW0 low to use fast simulation delay
		wait;
	end process;

	gen_keys :
	process
	begin
		KEY(3 downto 1) <= "111"; -- Idle (active-low)
		wait for 25 us;           -- Wait for system initialization
		
		-- Press KEY2 multiple times to see PWM Duty Cycle changes (5KHz period is 200us)
		for i in 1 to 4 loop
			KEY(2) <= '0';            -- Press KEY2
			wait for 2 us;
			KEY(2) <= '1';            -- Release KEY2
			wait for 2 ms;            -- Wait 2ms (10 PWM periods) to observe the duty cycle
		end loop;
		
		-- Press KEY3 multiple times to trigger array divisions and capture runtime
		for i in 1 to 4 loop
			KEY(3) <= '0';            -- Press KEY3
			wait for 2 us;
			KEY(3) <= '1';            -- Release KEY3
			wait for 200 us;          -- Wait for division and return to idle
		end loop;
		
		wait;
	end process;
--------------------------------------------------------------------		
end struct;
