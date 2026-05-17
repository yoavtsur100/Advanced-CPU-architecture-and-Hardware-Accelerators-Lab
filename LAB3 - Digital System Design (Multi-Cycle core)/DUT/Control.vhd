LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
USE work.aux_package.all;
-------------------------------------
entity Control IS
	port(rst,ena,clk : in std_logic;
		 mov_i,done_i,and_i,or_i,xor_i,jnc_i,jc_i,jmp_i,sub_i,add_i,Nflag_i,Zflag_i,Cflag_i,ld_i,st_i : in std_logic;
		 done_o :out std_logic;
		 DTCM_wr_o,Cin_o,Cout_o,DTCM_addr_in_o,DTCM_out_o,Ain_o,RFin_o,RFout_o,IRin_o,PCin_o,Imm1_in_o,Imm2_in_o : out std_logic;
		 ALUFN_o : out std_logic_vector(3 downto 0);
		 RFaddr_rd_o : out std_logic_vector(1 downto 0);
		 RFaddr_wr_o : out std_logic_vector(1 downto 0);
		 PCsel_o : out std_logic_vector(1 downto 0));
end Control;
---------------------------------------------------------------------------------
architecture ctl of Control IS
	
	TYpe State is (s_Reset,S_Fetch,s_decode,s_ALU,s_c,s_WriteBack,s_Memory,s_done);
	signal prv_state,nxt_state : State;
	
	---
	begin
		process(clk, rst)
		begin
			if rst = '1' then
				prv_state<= s_Reset; 
			elsif (clk'event and clk='1') then
				if ena = '1' then				
					prv_state <= nxt_state;
				end if;
			end if;
		end process;
		---
		process(prv_state,mov_i,done_i,and_i,or_i,xor_i,jnc_i,jc_i,jmp_i,sub_i,add_i,Nflag_i,Zflag_i,Cflag_i,ld_i,st_i)	
		begin
		---Defaulat values prevent Letches
			DTCM_wr_o <= '0'; Cin_o <= '0'; Cout_o <= '0';done_o <= '0';
			DTCM_addr_in_o <= '0'; DTCM_out_o <= '0'; Ain_o <= '0'; RFin_o <= '0';
			RFout_o <= '0'; IRin_o <= '0'; PCin_o <= '0'; Imm1_in_o <= '0'; Imm2_in_o <= '0';
			ALUFN_o <= "0000"; 
			RFaddr_rd_o <= "00"; 
			RFaddr_wr_o <= "00";
			PCsel_o <= "00";
			nxt_state <= S_Fetch;
			
			---FSM:
			case prv_state is 
				when s_Reset =>
					nxt_state <= s_Fetch;
					
				------------------	
				
				when s_Fetch =>
					IRin_o <= '1';
					PCin_o <= '1';
					PCsel_o<= "00";
					nxt_state <= s_decode;	
					
				
				when s_decode =>
				
					if(done_i = '1') then
						nxt_state <= s_done;
						
					---RTYPE or st/ld:
					elsif(and_i = '1' or or_i ='1' or xor_i = '1'  or add_i = '1' or sub_i = '1' or ld_i ='1' or st_i = '1') then 
						Ain_o <= '1';
						RFout_o <= '1';
						---Want rb from IR.
						RFaddr_rd_o <= "01";
						--Move to register A 
						nxt_state <= s_ALU;
						
					--JTYPE	(if will be new J-TYPE ISA fucntion).
					elsif(jmp_i = '1' or jc_i = '1' or jnc_i ='1') then
						if(jmp_i ='1') then
						PCsel_o <= "01";
						PCin_o <= '1';
						elsif(jc_i ='1'and Cflag_i = '1' ) then
						PCsel_o <= "01";
						PCin_o <= '1';
						elsif(jnc_i ='1' and Cflag_i = '0') then
						PCsel_o <= "01";
						PCin_o <= '1';					
						end if;
						nxt_state <= s_Fetch;
						
					--mov:	
					elsif(mov_i ='1') then	
						Imm1_in_o <= '1';
						--write to Ra.
						RFaddr_wr_o <= "10";
						RFin_o <= '1';
						nxt_state <= s_Fetch;
					end if;
				

				when s_ALU =>
					Cin_o <= '1';
					if(ld_i = '1' or st_i ='1')then
						Imm2_in_o <= '1';
					else 
						RFout_o <= '1';
						---Want rc from IR.
						RFaddr_rd_o <= "10";
					end if;								
					---choose ALU operation:
					if (add_i = '1') then
						ALUFN_o <= "0000";
					elsif( sub_i = '1') then
						ALUFN_o <= "0001";
					elsif( and_i = '1') then
						ALUFN_o <= "0010";
					elsif( or_i = '1') then
						ALUFN_o <= "0011";	
					elsif( xor_i = '1') then
						ALUFN_o <= "0100";
					elsif(ld_i = '1') then
						ALUFN_o <= "1101";
					elsif(st_i = '1') then
						ALUFN_o <= "1110";						
					end if;
					nxt_state <= s_c; 
					
				when s_c=>
					Cout_o <= '1';
					if(st_i = '1') then
						DTCM_addr_in_o <= '1';
						nxt_state <= s_Memory;
						
					elsif(ld_i = '1') then 
						nxt_state <= s_WriteBack;
					
					else
						--write to Ra.	
						RFaddr_wr_o <= "10";
						RFin_o <= '1';
						nxt_state <= s_Fetch;
					end if;
				
				
					
				when s_WriteBack =>	
					DTCM_out_o <= '1';
					--write to Ra.
					RFaddr_wr_o <= "10";
					RFin_o <= '1';
					nxt_state <=s_Fetch;
			
				when s_Memory =>
					--Bring Ra.
					RFaddr_rd_o <= "00";
					RFout_o <= '1';
					--store in DM:
					DTCM_wr_o <= '1';
					--ALUFN_o <= "1110";
					nxt_state <= s_Fetch;
					
				---Until reset to FSM Stay there.
				when s_done =>
					done_o <= '1';
					nxt_state <= s_done;
				when others =>
					nxt_state <= s_Reset;
			end case;
			end process;




end ctl;
		 