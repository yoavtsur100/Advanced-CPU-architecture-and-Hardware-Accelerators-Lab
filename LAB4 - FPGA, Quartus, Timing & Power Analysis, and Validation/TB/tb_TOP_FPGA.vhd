library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
------------------------------------------------
entity tb_TOP_FPGA is
end tb_TOP_FPGA;
------------------------------------------------
architecture sim of tb_TOP_FPGA is

    constant clk_period : time := 20 ns; -- 50MHz

    signal CLK_50MHZ : std_logic := '0';
    signal KEY       : std_logic_vector(3 downto 0) := (others => '1');
    signal SW        : std_logic_vector(9 downto 0) := (others => '0');

    signal LEDR      : std_logic_vector(9 downto 0);
    signal HEX0      : std_logic_vector(6 downto 0);
    signal HEX1      : std_logic_vector(6 downto 0);
    signal HEX2      : std_logic_vector(6 downto 0);
    signal HEX3      : std_logic_vector(6 downto 0);
    signal HEX4      : std_logic_vector(6 downto 0);
    signal HEX5      : std_logic_vector(6 downto 0);
    signal GPIO9     : std_logic;

begin

    DUT: FPGA_Top port map (CLK_50MHZ => CLK_50MHZ,KEY => KEY,SW=> SW,LEDR=> LEDR,HEX0=> HEX0,HEX1=> HEX1,HEX2=> HEX2,
								HEX3=> HEX3,HEX4=> HEX4,HEX5 => HEX5,GPIO9=> GPIO9);

    -- 50MHz clock
    clk_process: process
    begin
        while true loop
            CLK_50MHZ <= '0';
            wait for clk_period / 2;
            CLK_50MHZ <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    stimulus: process
    begin
        -- Initial state
        KEY <= "1111";
        SW  <= (others => '0');
        wait for 200 ns;

        ----------------------------------------------------------------
        -- Load Y low byte = 10
        -- SW9 = 0 means low byte
        -- KEY0 loads Y
        ----------------------------------------------------------------
        SW(9) <= '0';
        SW(7 downto 0) <= x"0A";
        wait for 50 ns;

        KEY(0) <= '0';
        wait for 100 ns;
        KEY(0) <= '1';
        wait for 100 ns;

        ----------------------------------------------------------------
        -- Load X low byte = 5
        -- SW9 = 0 means low byte
        -- KEY1 loads X
        ----------------------------------------------------------------
        SW(9) <= '0';
        SW(7 downto 0) <= x"05";
        wait for 50 ns;

        KEY(1) <= '0';
        wait for 100 ns;
        KEY(1) <= '1';
        wait for 100 ns;

        ----------------------------------------------------------------
        -- Load ALUFN = 01000, meaning Y + X
        -- KEY2 loads ALUFN
        ----------------------------------------------------------------
        SW(7 downto 0) <= "00001000";
        wait for 50 ns;

        KEY(2) <= '0';
        wait for 100 ns;
        KEY(2) <= '1';
        wait for 1000 ns;

        ----------------------------------------------------------------
        -- Test Shift operation: ALUFN = 10000
        ----------------------------------------------------------------
        SW(7 downto 0) <= "00010000";
        wait for 50 ns;

        KEY(2) <= '0';
        wait for 100 ns;
        KEY(2) <= '1';
        wait for 1000 ns;

        ----------------------------------------------------------------
        -- Test Boolean operation: ALUFN = 11010, for example Y and X
        ----------------------------------------------------------------
        SW(7 downto 0) <= "00011010";
        wait for 50 ns;

        KEY(2) <= '0';
        wait for 100 ns;
        KEY(2) <= '1';
        wait for 1000 ns;

        ----------------------------------------------------------------
        -- Test PWM mode: ALUFN = 00000
        ----------------------------------------------------------------
		-- Enable PWM / Digital System
		SW(8) <= '1';
        SW(7 downto 0) <= "00000000";
        wait for 50 ns;

        KEY(2) <= '0';
        wait for 100 ns;
        KEY(2) <= '1';

        -- Wait longer to observe PWM
        wait for 50 us;

        wait;
    end process;

end architecture sim;