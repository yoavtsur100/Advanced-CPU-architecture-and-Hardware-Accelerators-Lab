library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------
ENTITY FPGA_Top IS
	generic (
        n : integer := 16;
        k : integer := 4;
		m : integer :=8);
	PORT(
    CLK_50MHZ : IN std_logic;
    KEY      : IN std_logic_vector(3 downto 0);
    SW       : IN std_logic_vector(9 downto 0);

    LEDR     : OUT std_logic_vector(9 downto 0);
    HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : OUT std_logic_vector(6 downto 0);
    GPIO9     : OUT std_logic);
END FPGA_Top;
-----------------------------------------------------------
ARCHITECTURE FPGA OF FPGA_Top IS
	
	signal clk2MHz : std_logic;
	signal locked	: STD_LOGIC ;
	signal key_not : std_logic_vector(3 downto 0);
	signal pwm_w : std_logic;
	signal Nflag,Cflag,Zflag,Vflag : std_logic;
	signal key0_and_notSW9_w, key0_and_SW9_w, key1_and_notSW9_w , key1_and_SW9_w : std_logic;
	signal regX, regY : std_logic_vector(15 downto 0):=(others=>'0');
	signal regALU : std_logic_vector(7 downto 0):=(others=>'0');
	signal MuxX, MuxY : std_logic_vector(7 downto 0);
	signal ALUtoHEX54 : std_logic_vector(7 downto 0);
	--signal HEX0_w,HEX1_w,HEX2_w,HEX3_w,HEX4_w,HEX5_w :  std_logic_vector(6 downto 0);

	begin
	
	--push button is reset need active low.
	key_not <= not(KEY);
	
	--Port MAP:
	PllPart : PLL port map(areset => key_not(3),inclk0 =>CLK_50MHZ , c0=>clk2MHz, locked=>locked);
	
	DSPart : SystemTop generic map(n=>n , k=>k , m=>m) port map(Y_i=>regY , X_i=>regX , ALUFN=>regALU(4 downto 0) ,ENA=> SW(8) , RST=> key_not(3), CLK=> clk2MHz,ALUout => ALUtoHEX54 ,
															V=> Vflag, Z=>Zflag , C=> Cflag, Neg=>Nflag ,PWMout=>pwm_w);
															
															
	HEX0out: SevenSegDecoder  port map (data=>MuxX(3 downto 0) , seg=>HEX0);
	HEX1out: SevenSegDecoder  port map (data=> MuxX(7 downto 4), seg=>HEX1);
	HEX2out: SevenSegDecoder  port map (data=> MuxY(3 downto 0), seg=>HEX2);
	HEX3out: SevenSegDecoder  port map (data=> MuxY(7 downto 4) , seg=>HEX3);
	HEX4out: SevenSegDecoder  port map (data=> ALUtoHEX54(3 downto 0), seg=>HEX4);
	HEX5out: SevenSegDecoder  port map (data=> ALUtoHEX54(7 downto 4), seg=>HEX5);
	
	
	----Enable Wire:
	--key0_and_notSW9_w <= key_not(0) and (not(SW(9)));
	--key0_and_SW9_w    <= key_not(0) and SW(9);
	--key1_and_notSW9_w <= key_not(1) and (not(SW(9)));
	--key1_and_SW9_w    <= key_not(1) and SW(9);
	
	--asynchronys Latch:
		process(KEY,SW(9))
		begin
		--key push = 0. pull = 1
		--switch up = 1. down = 0
				if (key(0) = '0' and SW(9) = '0') then
					regY(7 downto 0) <= SW(7 downto 0 );
				end if;
				
				if (key(0) = '0' and SW(9) = '1') then
					regY(15 downto 8) <= SW(7 downto 0 );
				end if;
				
				if (key(1) = '0' and SW(9) = '0') then
					regX(7 downto 0) <= SW(7 downto 0 );
				end if;
				
				if (key(1) = '0' and SW(9) = '1') then
					regX(15 downto 8) <= SW(7 downto 0 );
				end if;
				if (key(2) = '0') then	
					regALU <= SW(7 downto 0);
				end if;
				
		END process;
			
	--MUX:
		with sw(9) select
			MuxY <= regY(7 downto 0) when '0',
					regY(15 downto 8) when '1',
					(others => '0') when others;
		
		with sw(9) select
			MuxX <= regX(7 downto 0) when '0',
					regX(15 downto 8) when '1',
					(others => '0') when others;
	--Assigments:
	GPIO9 <= pwm_w;
	LEDR(9) <=regALU(4);
	LEDR(8) <=regALU(3);
	LEDR(7) <=regALU(2);
	LEDR(6) <=regALU(1);
	LEDR(5) <=regALU(0);
	
	LEDR(3) <=Nflag;
	LEDR(2) <=Cflag;
	LEDR(1) <=Zflag;
	LEDR(0) <=Vflag;

end FPGA;