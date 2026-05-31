library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------
entity tb_system_top is
    constant n : integer := 16; 
    constant k : integer := 4;  
    constant m : integer := 8;  
    constant ROWmax : integer := 37;
    constant clk_period : time := 100 ns; 
end tb_system_top;

architecture tptb of tb_system_top is
    -- Signals
    signal Y_i, X_i   : STD_LOGIC_VECTOR (n-1 DOWNTO 0) := (others => '0');
    signal ALUFN      : STD_LOGIC_VECTOR (4 DOWNTO 0) := (others => '0');
    signal ENA        : std_logic := '0';
    signal RST        : std_logic := '0';
    signal CLK        : std_logic := '0';
    
    signal ALUout     : STD_LOGIC_VECTOR(7 downto 0);
    signal V, Z, C, Neg : STD_LOGIC;
    signal PWMout     : STD_LOGIC;

    -- Instruction Cache (מערך פקודות)
    type mem is array (0 to ROWmax) of std_logic_vector(4 downto 0);
    signal Icache : mem := (
        "01000","00010","01001","01010","01011","01100", -- ALU AddSub
        "10000","10001",                 -- ALU Shifter
        "11001","00001","11010","11101", "11000","11110","11100","11011",               
        "00000",         
        others => "00000");

begin
    -- Unit Under Test (UUT)
    L0 : SystemTop  generic map (n, k, m)  port map ( Y_i => Y_i, X_i => X_i, ALUFN => ALUFN,  ENA => ENA, RST => RST, CLK => CLK,
														ALUout => ALUout, V => V, Z => Z, C => C, Neg => Neg, PWMout => PWMout);



    -- 1. Clock Generation Process
    clk_gen : process
    begin
        while now < 10000 ns loop -- הגבלת זמן הסימולציה
            CLK <= '1';
            wait for clk_period/2;
            CLK <= '0';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

    -- 2. Main Stimulus Process
    tb_main : process
    begin
        -- Reset Sequence
        RST <= '1';
        ENA <= '0';
        wait for 100 ns;
        RST <= '0';
        wait for 100 ns;
        ENA <= '1';

        -- טעינת ערכי X ו-Y
        X_i <= x"0005"; -- X = 5
        Y_i <= x"000A"; -- Y = 10 
        
       
        for i in 0 to ROWmax loop
            ALUFN <= Icache(i);
            
            
            if Icache(i)(4 downto 3) = "00" then
                wait for 2000 ns; 
            else
                wait for 200 ns;
            end if;
        end loop;

        ENA <= '0';
        wait;
    end process;

    -- 3. Dynamic X, Y Change 
    --tb_dynamic_inputs : process
    --begin
    --    wait for 500 ns;
    --    for i in 0 to 20 loop
    --        wait for 500 ns;
    --        X_i <= X_i + 2; 
    --    end loop;
    --    wait;
    --end process;

end architecture tptb;