library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------

ENTITY SevenSegDecoder IS
 
  PORT (data		: in STD_LOGIC_VECTOR (3 DOWNTO 0);
		seg   		: out STD_LOGIC_VECTOR (6 downto 0));
END SevenSegDecoder;
--------------------------------------------------------------
ARCHITECTURE dfl OF SevenSegDecoder IS
BEGIN
	-- Perform Operation according FN bits of ALUFN 
	PROCESS(data)
    BEGIN
        CASE data IS
                              
            WHEN x"0"   => seg <= "1000000";
            WHEN x"1"   => seg <= "1111001"; 
            WHEN x"2"   => seg <= "0100100"; 
            WHEN x"3"   => seg <= "0110000"; 
            WHEN x"4"   => seg <= "0011001"; 
            WHEN x"5"   => seg <= "0010010"; 
            WHEN x"6"   => seg <= "0000010"; 
            WHEN x"7"   => seg <= "1111000"; 
            WHEN x"8"   => seg <= "0000000"; 
            WHEN x"9"   => seg <= "0010000"; 
            WHEN x"A"   => seg <= "0001000"; 
            WHEN x"B"   => seg <= "0000011";
            WHEN x"C"   => seg <= "1000110"; 
            WHEN x"D"   => seg <= "0100001"; 
            WHEN x"E"   => seg <= "0000110"; 
            WHEN x"F"   => seg <= "0001110"; 
            WHEN OTHERS => seg <= "1111111"; 
        END CASE;
    END PROCESS;
	
	
					
END dfl;