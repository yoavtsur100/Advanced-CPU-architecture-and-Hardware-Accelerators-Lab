LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.aux_package.all;

ENTITY InterruptController IS
    PORT (
        clk_i         : IN STD_LOGIC;
        rst_i         : IN STD_LOGIC;
        addr_i        : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
        mem_write_i   : IN STD_LOGIC;
        mem_read_i    : IN STD_LOGIC;
        
        -- Pushbuttons (KEY1, KEY2, KEY3)
        KEY_pins_i    : IN STD_LOGIC_VECTOR(3 DOWNTO 1);
        
        -- Basic Timer Interrupt Flag input
        BTIFG_i       : IN STD_LOGIC;
        
        -- CPU Handshake
        INTR_o        : OUT STD_LOGIC;
        INTA_i        : IN STD_LOGIC;
        GIE_i         : IN STD_LOGIC; 
        
        -- Bi-directional DataBUS
        DataBUS       : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END InterruptController;

ARCHITECTURE rtl OF InterruptController IS
    -- Registers (eint is ie_q, irq is irq_pending_q)
    SIGNAL ie_q          : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL irq_pending_q : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL type_q        : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL inta_d1_q     : STD_LOGIC := '1'; -- Delayed sample of INTA_i for Cycle 2 auto-clear
    
    -- Edge detection registers for KEYs--needed 2 for edge detection
    SIGNAL key_d1_r : STD_LOGIC_VECTOR(3 DOWNTO 1) := (OTHERS => '1');
    SIGNAL key_d2_r : STD_LOGIC_VECTOR(3 DOWNTO 1) := (OTHERS => '1');
    
    -- Edge detection for Basic Timer--needed 2 for edge detection
    SIGNAL bt_d1_r  : STD_LOGIC := '0';
    SIGNAL bt_d2_r  : STD_LOGIC := '0';
    
    -- Interrupt Sources (IS)
    SIGNAL is_bt_w   : STD_LOGIC;
    SIGNAL is_key1_w : STD_LOGIC;
    SIGNAL is_key2_w : STD_LOGIC;
    SIGNAL is_key3_w : STD_LOGIC;
    
    -- Active / Pending signals 
    SIGNAL ifg_w         : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL current_type  : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL has_interrupt : STD_LOGIC;
    
    -- Bus 
    SIGNAL data_out_w    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL drive_bus_w   : STD_LOGIC;
    
    -- Address decoding
    SIGNAL cs_pb_w   : STD_LOGIC;
    SIGNAL cs_ie_w   : STD_LOGIC;
    SIGNAL cs_ifg_w  : STD_LOGIC;
    SIGNAL cs_type_w : STD_LOGIC;
BEGIN

    -- Address Decoder (Bits 13 downto 0)
    cs_pb_w   <= '1' WHEN addr_i = "10" & X"014" ELSE '0'; -- 0x2014
    cs_ie_w   <= '1' WHEN addr_i = "10" & X"02C" ELSE '0'; -- 0x202C
    cs_ifg_w  <= '1' WHEN addr_i = "10" & X"02D" ELSE '0'; -- 0x202D
    cs_type_w <= '1' WHEN addr_i = "10" & X"02E" ELSE '0'; -- 0x202E

    -- Edge detection for KEY pins and Basic Timer 
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then
                key_d1_r  <= KEY_pins_i;
                key_d2_r  <= KEY_pins_i;
                bt_d1_r   <= '0';
                bt_d2_r   <= '0';
                inta_d1_q <= '1';
            else
                key_d1_r  <= KEY_pins_i;
                key_d2_r  <= key_d1_r;
                bt_d1_r   <= BTIFG_i;
                bt_d2_r   <= bt_d1_r;
                inta_d1_q <= INTA_i;
            end if;
        end if;
    end process;

    -- Interrupt Sources mapping (falling edge detectors for KEYs, rising edge for BT)
    is_key1_w <= '1' WHEN key_d2_r(1) = '1' AND key_d1_r(1) = '0' ELSE '0';
    is_key2_w <= '1' WHEN key_d2_r(2) = '1' AND key_d1_r(2) = '0' ELSE '0';
    is_key3_w <= '1' WHEN key_d2_r(3) = '1' AND key_d1_r(3) = '0' ELSE '0';
    is_bt_w   <= '1' WHEN bt_d2_r = '0' and bt_d1_r = '1' ELSE '0';

    -- enabled interrupts gate
    ifg_w <= irq_pending_q AND ie_q;

    -- Priority Encoder
    process(ifg_w)
    begin
        if ifg_w(2) = '1' then     -- Basic Timer (Priority 4)
            current_type  <= X"10";
            has_interrupt <= '1';
        elsif ifg_w(3) = '1' then   -- KEY1 (Priority 5)
            current_type  <= X"14";
            has_interrupt <= '1';
        elsif ifg_w(4) = '1' then   -- KEY2 (Priority 6)
            current_type  <= X"18";
            has_interrupt <= '1';
        elsif ifg_w(5) = '1' then   -- KEY3 (Priority 7)
            current_type  <= X"1C";
            has_interrupt <= '1';
        else
            current_type  <= X"00";
            has_interrupt <= '0';
        end if;
    end process;

    -- Drive INTR to CPU 
    INTR_o <= has_interrupt AND GIE_i;

    -- Registers Write & IFG Hardware updates
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            ie_q          <= (OTHERS => '0');
            irq_pending_q <= (OTHERS => '0');
            type_q        <= (OTHERS => '0');
        elsif rising_edge(clk_i) then
            -- bits 7:6 and 1:0 are reserved as read-only 0
            if mem_write_i = '1' then
                if cs_ie_w = '1' then
                    ie_q(5 downto 2) <= DataBUS(5 downto 2);
                    ie_q(7 downto 6) <= "00";
                    ie_q(1 downto 0) <= "00";
                elsif cs_ifg_w = '1' then
                    -- Tolerant to both aligned/misaligned SW/SB writes to IFG (0x202D)
                    irq_pending_q(5 downto 2) <= DataBUS(5 downto 2) AND DataBUS(13 downto 10);
                    irq_pending_q(7 downto 6) <= "00";
                    irq_pending_q(1 downto 0) <= "00";
                end if;
            end if;

            
            -- Acknowledge: capture TYPE when INTA_i is low ('0')
            if INTA_i = '0' then
                type_q <= current_type;
            end if;

            -- Auto-clear synchronous Basic Timer interrupt on rising edge of INTA_i (transition to Cycle 2)
            if inta_d1_q = '0' and INTA_i = '1' then
                if type_q = X"10" then
                    irq_pending_q(2) <= '0';
                end if;
            end if;

            --setting pending interrupts
            if is_key1_w = '1' then
                irq_pending_q(3) <= '1';
            end if;
            if is_key2_w = '1' then
                irq_pending_q(4) <= '1';
            end if;
            if is_key3_w = '1' then
                irq_pending_q(5) <= '1';
            end if;
            if is_bt_w = '1' then
                irq_pending_q(2) <= '1';
            end if;
        end if;
    end process;

    -- Bus Read Selection (INTA is priority over MMIO )
    data_out_w <= X"000000" & current_type            								  WHEN INTA_i = '0'    ELSE --  active TYPE vector during INTA cycle
                  X"000000" & "00000" & KEY_pins_i(3) & KEY_pins_i(2) & KEY_pins_i(1) WHEN cs_pb_w = '1' ELSE
                  X"000000" & ie_q                   								  WHEN cs_ie_w = '1'   ELSE
                  -- Tolerant to misaligned LW reads from IFG (0x202D)
                  ifg_w & ifg_w & ifg_w & ifg_w       								  WHEN cs_ifg_w = '1'  ELSE
                  X"000000" & type_q                  								  WHEN cs_type_w = '1' ELSE
                  (OTHERS => '0');

	-- DataBUS control signal
    -- during a valid MMIO read or during CPU's INTA cycle
    drive_bus_w <= (mem_read_i AND (cs_pb_w OR cs_ie_w OR cs_ifg_w OR cs_type_w)) OR (NOT INTA_i);

    -- Bidirectional buffer instantiation using BidirPin component
    INTC_Bidir_Buffer : BidirPin
        GENERIC MAP ( width => 32 )
        PORT MAP (
            Dout  => data_out_w,
            en    => drive_bus_w,
            Din   => open,
            IOpin => DataBUS
        );

END rtl;
