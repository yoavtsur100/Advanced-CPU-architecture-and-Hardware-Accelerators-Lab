LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE work.cond_compilation_package.all;
USE work.aux_package.all;
USE work.const_package.ALL;
---------------------------------------------------------------------------------------------
ENTITY BasicTimer IS
    PORT(
        clk_i         : IN    STD_LOGIC;
        rst_i         : IN    STD_LOGIC;
        addr_i        : IN    STD_LOGIC_VECTOR(13 DOWNTO 0);
        mem_write_i   : IN    STD_LOGIC;
        mem_read_i    : IN    STD_LOGIC;
        DataBUS       : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        CAPIN1_i      : IN    STD_LOGIC;
        CAPIN2_i      : IN    STD_LOGIC;
        BTIFG_o       : OUT   STD_LOGIC;
        PWMout_o      : OUT   STD_LOGIC
    );
END BasicTimer;

ARCHITECTURE rtl OF BasicTimer IS

    -- Register Signals
    SIGNAL btctl1_q    : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL btctl2_q    : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL btcnt_q     : unsigned(31 DOWNTO 0);
    SIGNAL btcmpr0_q   : unsigned(31 DOWNTO 0);
    SIGNAL btcmpr1_q   : unsigned(31 DOWNTO 0);
    SIGNAL btcapr_q    : unsigned(31 DOWNTO 0);
    SIGNAL btcl0_q     : unsigned(31 DOWNTO 0);
    SIGNAL btcl1_q     : unsigned(31 DOWNTO 0);

    -- Chip Select Signals
    SIGNAL cs_ctl1_w   : STD_LOGIC;
    SIGNAL cs_ctl2_w   : STD_LOGIC;
    SIGNAL cs_cmpr0_w  : STD_LOGIC;
    SIGNAL cs_cmpr1_w  : STD_LOGIC;
    SIGNAL cs_capr_w   : STD_LOGIC;

    -- Control Field Extraction
    SIGNAL bt_hold_w   : STD_LOGIC;
    SIGNAL bt_ssel_w   : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL bt_clr_w    : STD_LOGIC;
    SIGNAL bt_int_w    : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL bt_outen_w  : STD_LOGIC;
    SIGNAL bt_outmd_w  : STD_LOGIC;

    SIGNAL cap_isel_w  : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL cap_md_w    : STD_LOGIC_VECTOR(1 DOWNTO 0);

    -- Clock Prescaler Counter
    SIGNAL prescaler_cnt_r : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL timer_tick_w    : STD_LOGIC;

    -- Capture Input Signals
    SIGNAL cap_sig_w   : STD_LOGIC;
    SIGNAL cap_d1_r    : STD_LOGIC;
    SIGNAL cap_d2_r    : STD_LOGIC;
    SIGNAL cap_event_w : STD_LOGIC;

    -- Output Signals
    SIGNAL btifg_pulse_r : STD_LOGIC;
    SIGNAL timer_data_out_w : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL drive_bus_w      : STD_LOGIC;
    SIGNAL pwm_r            : STD_LOGIC;
    SIGNAL comp0_event_w    : STD_LOGIC;
    SIGNAL comp1_event_w    : STD_LOGIC;
    SIGNAL bt_event_w       : STD_LOGIC;

BEGIN

    -- Address Decoding
    cs_ctl1_w  <= '1' WHEN (addr_i = "10" & X"01C") ELSE '0';                           -- 0x201C (BTCTL1)
    cs_ctl2_w  <= '1' WHEN (addr_i = "10" & X"01D") ELSE '0';                           -- 0x201D (BTCTL2)
    cs_cmpr0_w <= '1' WHEN (addr_i = "10" & X"020") ELSE '0';                           -- 0x2020
    cs_cmpr1_w <= '1' WHEN (addr_i = "10" & X"024") ELSE '0';                           -- 0x2024
    cs_capr_w  <= '1' WHEN (addr_i = "10" & X"028") ELSE '0';                           -- 0x2028

    -- Control Signal Extraction
	--BTCTL1
    bt_outmd_w <= btctl1_q(7);
    bt_outen_w <= btctl1_q(6);
    bt_hold_w  <= btctl1_q(5);
    bt_ssel_w  <= btctl1_q(4 DOWNTO 3);
    bt_clr_w   <= btctl1_q(2);
    bt_int_w   <= btctl1_q(1 DOWNTO 0);
	
	--BTCTL2
    cap_md_w   <= btctl2_q(3 DOWNTO 2);
    cap_isel_w <= btctl2_q(1 DOWNTO 0);

    -- Bus Interface Writes
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            btctl1_q  <= (OTHERS => '0');
            btctl2_q  <= (OTHERS => '0');
            btcmpr0_q <= (OTHERS => '0');
            btcmpr1_q <= (OTHERS => '0');
        elsif rising_edge(clk_i) then
            if mem_write_i = '1' then
                if cs_ctl1_w = '1' then
                    btctl1_q <= DataBUS(7 DOWNTO 0);
                end if;
                if cs_ctl2_w = '1' then
                    btctl2_q <= DataBUS(7 DOWNTO 0) OR DataBUS(15 DOWNTO 8);
                end if;
                if cs_cmpr0_w = '1' then
				--values for event timer Compare comes from program
                    btcmpr0_q <= unsigned(DataBUS); 
                elsif cs_cmpr1_w = '1' then
                    btcmpr1_q <= unsigned(DataBUS);
                end if;
            else
                -- Self-clearing behavior for BTCLR
                if bt_clr_w = '1' then
                    btctl1_q(2) <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Prescaler Division Logic
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            prescaler_cnt_r <= (OTHERS => '0');
        elsif rising_edge(clk_i) then
            if bt_hold_w = '0' then
                prescaler_cnt_r <= prescaler_cnt_r + 1;
            end if;
        end if;
    end process;

    -- Clock select mapping: 00: div 1 (SMCLK directly), 01: div 2, 10: div 4, 11: div 8
    WITH bt_ssel_w SELECT
        timer_tick_w <= '1'                                                                     WHEN "00",
                        prescaler_cnt_r(0)                                                      WHEN "01",
                        (prescaler_cnt_r(1) AND prescaler_cnt_r(0))                             WHEN "10",
                        (prescaler_cnt_r(2) AND prescaler_cnt_r(1) AND prescaler_cnt_r(0))      WHEN "11",
                        '0'                                                                     WHEN OTHERS;

    -- Capture Edge Detection & Sampling (MUX)
    WITH cap_isel_w SELECT
        cap_sig_w <= CAPIN1_i WHEN "00",
                     CAPIN2_i WHEN "01",
                     '1'      WHEN "10",
                     '0'      WHEN OTHERS;

    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            cap_d1_r <= '0';
            cap_d2_r <= '0';
        elsif rising_edge(clk_i) then
            cap_d1_r <= cap_sig_w;
            cap_d2_r <= cap_d1_r;
        end if;
    end process;

    cap_event_w <= '1' WHEN (cap_md_w = "01" AND cap_d2_r = '0' AND cap_d1_r = '1') ELSE -- Rising edge
                   '1' WHEN (cap_md_w = "10" AND cap_d2_r = '1' AND cap_d1_r = '0') ELSE -- Falling edge
                   '0';

    --Combinational Interrupt Event Generation
    comp0_event_w <= '1' WHEN (btcl0_q > 0 AND btcnt_q = btcl0_q - 1) ELSE '0';
    comp1_event_w <= '1' WHEN (btcl1_q > 0 AND btcnt_q = btcl1_q - 1) ELSE '0';

    -- BTINT:  Interrupt Source Selection Multiplexer
    WITH bt_int_w SELECT
        bt_event_w <= comp0_event_w WHEN "00",
                      comp1_event_w WHEN "01",
                      cap_event_w   WHEN "10",
                      cap_event_w   WHEN "11",
                      '0'           WHEN OTHERS;

    -- Timer Counter & Capture registers sequential logic
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            btcnt_q  <= (OTHERS => '0');
            btcapr_q <= (OTHERS => '0');
        elsif rising_edge(clk_i) then
            if cap_event_w = '1' then
                btcapr_q <= btcnt_q;
            end if;

            if bt_clr_w = '1' then
                btcnt_q <= (OTHERS => '0');
            elsif bt_hold_w = '0' and timer_tick_w = '1' then
                if (cap_md_w = "00" or cap_md_w = "11") and btcl0_q > 0 then
				--if cap=1/2 there is capture and no need PWM and no need to reset CNT
					--Counter Logic only btcl0 reset the counter
                    if btcnt_q >= btcl0_q - 1 then
                        btcnt_q <= (OTHERS => '0');
                    else
                        btcnt_q <= btcnt_q + 1;
                    end if;
                else
                    btcnt_q <= btcnt_q + 1;
                end if;
            end if;
        end if;
    end process;

    -- Interrupt Pulse sequential logic
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            btifg_pulse_r <= '0';
        elsif rising_edge(clk_i) then
            btifg_pulse_r <= '0'; -- default state to prevent Latch
            
            -- Capture event can happen at any time (asynchronous to timer tick)
            if cap_event_w = '1' and (bt_int_w = "10" or bt_int_w = "11") then
                btifg_pulse_r <= '1';
				
            -- Compare events are sampled on timer ticks
            elsif bt_hold_w = '0' and timer_tick_w = '1' then
                btifg_pulse_r <= bt_event_w;
            end if;
        end if;
    end process;


    --  registers BTCL0 and BTCL1 loading logic
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            btcl0_q <= (OTHERS => '0');
            btcl1_q <= (OTHERS => '0');
        elsif rising_edge(clk_i) then
            if bt_clr_w = '1' or btcnt_q = 0 then
                btcl0_q <= btcmpr0_q;
                btcl1_q <= btcmpr1_q;
            end if;
        end if;
    end process;

    BTIFG_o <= btifg_pulse_r;

    -- PWM Output Generation
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            pwm_r <= '0';
        elsif rising_edge(clk_i) then
		--bt_outen_w = 1 is ENA
            if bt_outen_w = '1' then
                if bt_outmd_w = '0' then
                    -- Output Mode 0: Set/Reset (0 Output for counter value from 0 to BTCL1-1, 1 from BTCL1 to BTCL0-1)
                    if btcnt_q < btcl1_q then
                        pwm_r <= '0';
                    else
                        pwm_r <= '1';
                    end if;
                else
                    -- Output Mode 1: Reset/Set (1 Output for counter value from 0 to BTCL1-1, 0 from BTCL1 to BTCL0-1)
                    if btcnt_q < btcl1_q then
                        pwm_r <= '1';
                    else
                        pwm_r <= '0';
                    end if;
                end if;
            -- If bt_outen_w = '0', we do not update pwm so we Hold previous value
            end if;
        end if;
    end process;

    PWMout_o <= pwm_r;

    -- Bus 
    timer_data_out_w <= std_logic_vector(btcmpr0_q) WHEN cs_cmpr0_w = '1' ELSE
                        std_logic_vector(btcmpr1_q) WHEN cs_cmpr1_w = '1' ELSE
                        std_logic_vector(btcapr_q)  WHEN cs_capr_w  = '1' ELSE
                        X"0000" & btctl2_q & btctl1_q WHEN (cs_ctl1_w = '1' OR cs_ctl2_w = '1') ELSE
                        (OTHERS => '0');
	--Output Enable:
    drive_bus_w <= '1' WHEN (mem_read_i = '1' AND (cs_cmpr0_w = '1' OR cs_cmpr1_w = '1' OR cs_capr_w = '1' OR cs_ctl1_w = '1' OR cs_ctl2_w = '1')) ELSE '0';
	
	--Tri-State:
    Timer_Bidir_Buffer : BidirPin
        GENERIC MAP ( width => 32 )
        PORT MAP (
            Dout  => timer_data_out_w,
            en    => drive_bus_w,
            Din   => open,
            IOpin => DataBUS
        );

END rtl;
