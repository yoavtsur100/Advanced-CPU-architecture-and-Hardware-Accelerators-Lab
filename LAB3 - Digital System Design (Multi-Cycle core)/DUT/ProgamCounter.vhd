LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
USE work.aux_package.all;
-------------------------------------
entity ProgramCounter is
		generic( Awidth: integer:=6);
		port( clk,rst,PCin_i : in std_logic;
			  -- 2-bit MUX selector
			  PCsel_i : in std_logic_vector(1 downto 0);
			  --IR<7...0>
			  IRoffset_i :in std_logic_vector(7 downto 0);
			  --Go to progamMemory (readAddr)
			  PCout_o: out std_logic_vector(Awidth-1 downto 0));
end ProgramCounter;
-------------------------------------
architecture pc of ProgramCounter is
    signal current_pc_q    : std_logic_vector(Awidth-1 downto 0);
    signal next_pc_w       : std_logic_vector(Awidth-1 downto 0);
    signal pc_plus_one_w   : std_logic_vector(Awidth-1 downto 0);
    signal jump_addr_w     : std_logic_vector(Awidth-1 downto 0);
begin	

    --Regular process Pcin is like Enable.
	process(clk, rst)
		begin
			if rst = '1' then
				current_pc_q <= (others => '0'); 
			elsif (clk'event and clk='1') then
				if PCin_i = '1' then
					current_pc_q <= next_pc_w;
				end if;
			end if;
		end process;
	
	pc_plus_one_w <= current_pc_q + 1;
	
	jump_addr_w <= pc_plus_one_w + IRoffset_i(Awidth-1 downto 0) - 1;	
	
	--MUX by PCsel
	with PCsel_i select
        next_pc_w <= pc_plus_one_w      when "00", 
                   jump_addr_w        when "01", 
                   (others => '0')  when "10", 
                   current_pc_q       when others;

	--Go to progamMemory (readAddr)
    PCout_o <= current_pc_q;
	
end pc;		