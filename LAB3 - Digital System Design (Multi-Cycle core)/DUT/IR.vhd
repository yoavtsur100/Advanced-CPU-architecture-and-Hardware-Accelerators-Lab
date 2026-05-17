library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
USE work.aux_package.all;
-------------------------------
entity IR is 
	generic( Awidth: integer:=4;
			Dwidth: integer:=16);
	port( clk,rst : in std_logic;
			--From the Control
			IRin_i : in std_logic;
			--From ProgramMemory
			DataIn_i : in std_logic_vector(Dwidth-1 downto 0);
			OPC_o :Out std_logic_vector(Awidth-1 downto 0);
			Ra_o,Rb_o,Rc_o : Out std_logic_vector(Awidth-1 downto 0));
end IR;
-------------------------------
architecture InstructionRegister of IR is
	signal IR_w : std_logic_vector(Dwidth-1 downto 0);
begin
	--Regular process IRin is like Enable.
	process(clk, rst)
		begin
			if rst = '1' then
				 IR_w <= (others => '0'); 
			elsif (clk'event and clk='1') then
				if IRin_i = '1' then
					IR_w <= DataIn_i;
				end if;
			end if;
		end process;
	--Split the Vector DataIn:
	OPC_o <= IR_w(Dwidth-1 downto 12);
	Ra_o <= IR_w(11 downto 8);
	Rb_o <= IR_w(7 downto 4);
	Rc_o <= IR_w(3 downto 0);
end InstructionRegister;