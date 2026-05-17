LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
USE work.aux_package.all;

---------------------------------------------------------
-- checks the Control unit. 
---------------------------------------------------------
entity tb_Control is

end tb_Control;
---------------------------------------------------------
architecture tbctl of tb_Control is
	signal rst,ena,clk,mov,done,and_op,or_op,xor_op,jnc,jc,jmp,sub,add,Nflag,Zflag,Cflag,ld,st:  std_logic;
	signal done_FSM,DTCM_wr,Cin,Cout,DTCM_addr_in,DTCM_out,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in :  std_logic;
	signal ALUFN :std_logic_vector(3 downto 0);
	signal RFaddr_rd,RFaddr_wr,PCsel :  std_logic_vector(1 downto 0);
	
	begin
	ControlUnit: Control 	port map(rst=>rst, ena=>ena, clk=>clk,mov_i=>mov, done_i=>done, and_i=>and_op, or_i=>or_op, xor_i=>xor_op,
	
										jnc_i=>jnc, jc_i=>jc, jmp_i=>jmp, sub_i=>sub, add_i=>add, Nflag_i=>Nflag, Zflag_i=>Zflag, Cflag_i=>Cflag,
										
										ld_i=>ld, st_i=>st, done_o=>done_FSM, DTCM_wr_o=>DTCM_wr, Cin_o=>Cin,Cout_o=>Cout,DTCM_addr_in_o=>DTCM_addr_in,
										
										DTCM_out_o=>DTCM_out, Ain_o=>Ain, RFin_o=>RFin, RFout_o=>RFout, IRin_o=>IRin, PCin_o=>PCin, Imm1_in_o=>Imm1_in,
										
										Imm2_in_o=>Imm2_in, ALUFN_o=>ALUFN, RFaddr_rd_o=>RFaddr_rd, RFaddr_wr_o=>RFaddr_wr, PCsel_o=>PCsel);
										
	--------- start of stimulus section ------------------	
	--generate_rst : process	-- reset process
        rst <= '1','0' after 100 ns ;
		
		
        generate_clk : process	-- Clk process (duty cycle of 50% and period of 100 ns)
        begin
		  clk <= '1';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
		
		---check between 2500-2600 ns what happan if ena = 0.
		ena <= '1';
		
		
		--------------- Commands ---------------------
		add_cmd : process
        begin
		  add <='0', '1' after 100 ns, '0' after 500 ns;
		  wait;
        end process; 
		
		
		sub_cmd : process
        begin
		  sub <='0','1' after 500 ns, '0' after 900 ns;
		  wait;
        end process;
		
		
		and_cmd : process
        begin
		  and_op <='0','1' after 900 ns, '0' after 1300 ns;
		  wait;
        end process;
		
		
		or_cmd : process
        begin
		  or_op <='0','1' after 1300 ns, '0' after 1700 ns;
		  wait;
        end process;
		
		Xor_cmd : process
        begin
		  xor_op <='0','1' after 1700 ns, '0' after 2100 ns;
		  wait;
        end process;
		
		jmp_cmd : process
        begin
		  jmp <='0','1' after 2100 ns, '0' after 2300 ns;
		  wait;
        end process;
		
		jc_cmd : process
        begin
		  jc <='0','1' after 2300 ns, '0' after 2500 ns;
		  wait;
        end process;
		
		jnc_cmd : process
        begin
		  jnc <='0','1' after 2500 ns, '0' after 2700 ns;
		  wait;
        end process;
		
		mov_cmd : process
        begin
		  mov <='0','1' after 2710 ns, '0' after 2910 ns;
		  wait;
        end process;
		
		ld_cmd : process
        begin
		  ld <='0','1' after 2910 ns, '0' after 3410 ns;
		  wait;
        end process;
		
		st_cmd : process
        begin
		  st <='0','1' after 3410 ns, '0' after 3910 ns;
		  wait;
        end process;
		
		done_cmd : process
        begin
		  done <='0','1' after 3910 ns, '0' after 4500 ns;
		  wait;
        end process;
		
		end architecture tbctl;