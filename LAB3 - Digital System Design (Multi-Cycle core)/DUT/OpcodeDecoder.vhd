library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
USE work.aux_package.all;
--------------------------------------------------------------------------
entity OpcodeDecoder is
	generic( Size : integer :=4);
	port(Opc_i : in  std_logic_vector(Size-1 downto 0);
	     add_o,sub_o,and_o,or_o,xor_o,jmp_o,jc_o,jnc_o,mov_o,ld_o,st_o,done_op_o :out std_logic);
		  ---IN real time Task need to add another bit output.
 end  OpcodeDecoder;

 --------------------------------------------------------------------------
 architecture decode of OpcodeDecoder is
 
 begin
 ---The [15:12] bits from the IR  is the OPCODE.
  ----------------R-Type----------------------
 add_o <= '1' when Opc_i ="0000" else '0';
 --nop <= '1' when Opc_i ="0000" else '0';
 sub_o <= '1' when Opc_i ="0001" else '0';
 and_o <= '1' when Opc_i ="0010" else '0';
 or_o <= '1' when Opc_i ="0011" else '0';
 xor_o <= '1' when Opc_i ="0100" else '0';
 -- XXX <=  '1' when Opc_i = "0101" else '0'; R-Type Unused
 -- XXX <=  '1' when Opc_i = "0110" else '0'; R-Type Unused
 ----------------J-Type----------------------
 jmp_o <= '1' when Opc_i ="0111" else '0';
 jc_o <= '1' when Opc_i ="1000" else '0';
 jnc_o <= '1' when Opc_i ="1001" else '0';
-- XXX <=  '1' when Opc_i = "1010" else '0'; J-Type Unused
-- XXX <=  '1' when Opc_i = "1011" else '0'; J-Type Unused
 ----------------I-Type----------------------
 mov_o <= '1' when Opc_i ="1100" else '0';
 ld_o <= '1' when Opc_i ="1101" else '0';
 st_o <= '1' when Opc_i ="1110" else '0';
  ----------------Special----------------------
 done_op_o <= '1' when Opc_i ="1111" else '0';
 
 end decode;