LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE work.cond_compilation_package.all;
USE work.aux_package.all;
USE work.const_package.ALL;
----------------------------------------
entity GPIO_peripherals is
    port (
        clk_i         : in    std_logic;
        rst_i         : in    std_logic;    
       
        addr_i        : in    std_logic_vector(13 downto 0); 
        mem_write_i   : in    std_logic;                     
        mem_read_i    : in    std_logic;                     
                
        DataBUS       : inout std_logic_vector(31 downto 0);          
        SW_pins_i     : in    std_logic_vector(7 downto 0);  -- (SW7-SW0)
        LEDR_pins_o   : out   std_logic_vector(7 downto 0); -- (LEDR7-LEDR0)
        HEX0_pins_o   : out   std_logic_vector(6 downto 0); -- 7 segments
        HEX1_pins_o   : out   std_logic_vector(6 downto 0);
        HEX2_pins_o   : out   std_logic_vector(6 downto 0);
        HEX3_pins_o   : out   std_logic_vector(6 downto 0);
        HEX4_pins_o   : out   std_logic_vector(6 downto 0);
        HEX5_pins_o   : out   std_logic_vector(6 downto 0)
    );
end GPIO_peripherals;
------------------------------------------------------------------------	
ARCHITECTURE rtl OF GPIO_peripherals IS


    --decoder chip-select signals
    SIGNAL cs_ledr_w : STD_LOGIC;
    SIGNAL cs_hex0_w : STD_LOGIC;
    SIGNAL cs_hex1_w : STD_LOGIC;
    SIGNAL cs_hex2_w : STD_LOGIC;
    SIGNAL cs_hex3_w : STD_LOGIC;
    SIGNAL cs_hex4_w : STD_LOGIC;
    SIGNAL cs_hex5_w : STD_LOGIC;
    SIGNAL cs_sw_w   : STD_LOGIC;

    -- Intermediate Chip Selects for HEX pairs (per Figure 5)
    SIGNAL cs_hex01_w : STD_LOGIC;
    SIGNAL cs_hex23_w : STD_LOGIC;
    SIGNAL cs_hex45_w : STD_LOGIC;

    -- GPIO output registers
    SIGNAL ledr_q : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL hex0_q : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL hex1_q : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL hex2_q : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL hex3_q : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL hex4_q : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL hex5_q : STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- Tri-state Data Bus signals
    SIGNAL data_bus_out_w : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL data_bus_OutputEnable_w  : STD_LOGIC;

    -- Seven segment decoded signals
    SIGNAL hex0_seg_w : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL hex1_seg_w : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL hex2_seg_w : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL hex3_seg_w : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL hex4_seg_w : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL hex5_seg_w : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN 
    -- Central Decoder 
    process(addr_i)
    begin
        -- Default assignments 
        cs_ledr_w  <= '0';
        cs_sw_w    <= '0';
        cs_hex01_w <= '0';
        cs_hex23_w <= '0';
        cs_hex45_w <= '0';

        -- Check if the address is within the GPIO range (0x2000 to 0x201F)
        -- Bits 13 downto 5 must be "100000000" (which corresponds to 0x2000 base)
        if addr_i(13 downto 5) = "100000000" then
            -- Verify bit 1 is '0' to prevent invalid aliases ( 0x2006, 0x200E...)
            if addr_i(1) = '0' then
                case addr_i(4 downto 2) is
                    when "000" => -- Address 0x2000 (LEDR)
                        if addr_i(0) = '0' then
                            cs_ledr_w <= '1';
                        end if;
                    when "001" => -- Address 0x2004 (HEX0) or 0x2005 (HEX1)
                        cs_hex01_w <= '1';
                    when "010" => -- Address 0x2008 (HEX2) or 0x2009 (HEX3)
                        cs_hex23_w <= '1';
                    when "011" => -- Address 0x200C (HEX4) or 0x200D (HEX5)
                        cs_hex45_w <= '1';
                    when "100" => -- Address 0x2010 (SW)
                        if addr_i(0) = '0' then
                            cs_sw_w <= '1';
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

    -- A0 gating for HEX pairs 
    cs_hex0_w <= cs_hex01_w AND NOT addr_i(0);
    cs_hex1_w <= cs_hex01_w AND     addr_i(0);

    cs_hex2_w <= cs_hex23_w AND NOT addr_i(0);
    cs_hex3_w <= cs_hex23_w AND     addr_i(0);

    cs_hex4_w <= cs_hex45_w AND NOT addr_i(0);
    cs_hex5_w <= cs_hex45_w AND     addr_i(0);

    -- GPIO output registers
    -- Only the register selected by the address decoder is updated.
    gpio_write_proc : PROCESS(clk_i, rst_i)
    BEGIN

        IF rst_i = '1' THEN

            ledr_q <= (OTHERS => '0');
            hex0_q <= (OTHERS => '0');
            hex1_q <= (OTHERS => '0');
            hex2_q <= (OTHERS => '0');
            hex3_q <= (OTHERS => '0');
            hex4_q <= (OTHERS => '0');
            hex5_q <= (OTHERS => '0');

        ELSIF rising_edge(clk_i) THEN

            IF mem_write_i = '1' THEN

                IF cs_ledr_w = '1' THEN
                    ledr_q <= DataBUS(7 DOWNTO 0);

                ELSIF cs_hex0_w = '1' THEN

                    hex0_q <= DataBUS(7 DOWNTO 0);

                ELSIF cs_hex1_w = '1' THEN

                    hex1_q <= DataBUS(7 DOWNTO 0);

                ELSIF cs_hex2_w = '1' THEN

                    hex2_q <= DataBUS(7 DOWNTO 0);

                ELSIF cs_hex3_w = '1' THEN

                    hex3_q <= DataBUS(7 DOWNTO 0);

                ELSIF cs_hex4_w = '1' THEN

                    hex4_q <= DataBUS(7 DOWNTO 0);

                ELSIF cs_hex5_w = '1' THEN

                    hex5_q <= DataBUS(7 DOWNTO 0);

                END IF;

            END IF;

        END IF;

    END PROCESS gpio_write_proc;

		
    --Only SW is readable
    data_bus_out_w <=  X"000000" & SW_pins_i     WHEN cs_sw_w = '1'   ELSE
                       (OTHERS => '0');

    -- Output enable for the tri-state buffer is active when CPU reads from SW address
    data_bus_OutputEnable_w <= mem_read_i AND cs_sw_w;

   
    -- Tri-state driver using BidirPin component (drives the shared DataBUS)  
    GPIO_Bidir_Buffer : BidirPin
        GENERIC MAP ( width => 32 )
        PORT MAP (
            Dout  => data_bus_out_w,
            en    => data_bus_OutputEnable_w,
            Din   => open,
            IOpin => DataBUS
        );

 
    -- Seven segment decoders instantiations 
	--only 3 down to 0 because can show only 1 digit.
    HEX0_Dec : SevenSegDecoder PORT MAP ( data => hex0_q(3 DOWNTO 0), seg => hex0_seg_w );
    HEX1_Dec : SevenSegDecoder PORT MAP ( data => hex1_q(3 DOWNTO 0), seg => hex1_seg_w );
    HEX2_Dec : SevenSegDecoder PORT MAP ( data => hex2_q(3 DOWNTO 0), seg => hex2_seg_w );
    HEX3_Dec : SevenSegDecoder PORT MAP ( data => hex3_q(3 DOWNTO 0), seg => hex3_seg_w );
    HEX4_Dec : SevenSegDecoder PORT MAP ( data => hex4_q(3 DOWNTO 0), seg => hex4_seg_w );
    HEX5_Dec : SevenSegDecoder PORT MAP ( data => hex5_q(3 DOWNTO 0), seg => hex5_seg_w );

    
    -- Connect output registers to the external pins 
    LEDR_pins_o <= ledr_q;
    HEX0_pins_o <= hex0_seg_w;
    HEX1_pins_o <= hex1_seg_w;
    HEX2_pins_o <= hex2_seg_w;
    HEX3_pins_o <= hex3_seg_w;
    HEX4_pins_o <= hex4_seg_w;
    HEX5_pins_o <= hex5_seg_w;

END rtl;