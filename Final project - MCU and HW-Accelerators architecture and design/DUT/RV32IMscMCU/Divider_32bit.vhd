LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.aux_package.all;
-----------------------------------------------
ENTITY Divider_32bit IS
    GENERIC (
        N : INTEGER := 32
    );
    PORT (
        DIVCLK_i    : IN  STD_LOGIC;
        DIVRST_i    : IN  STD_LOGIC;
        DIVENA_i    : IN  STD_LOGIC;

        DIVIDEND_i  : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        DIVISOR_i   : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);

        DIVBUSY_o   : OUT STD_LOGIC;
        QUOTIENT_o  : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        RESIDUE_o   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
    );
END Divider_32bit;

----------------------------------------------------------------
ARCHITECTURE div OF Divider_32bit IS


    -- Upper N bits: partial residue
    -- Lower N bits: remaining dividend bits
	--	_q current state in reg  _d next state in reg.
	
    SIGNAL dividend_shift_q 		: STD_LOGIC_VECTOR(2*N-1 DOWNTO 0);
    SIGNAL dividend_shift_d 		: STD_LOGIC_VECTOR(2*N-1 DOWNTO 0);
    SIGNAL divisor_q 				: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    SIGNAL divisor_d 				: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    SIGNAL quotient_shift_q 		: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    SIGNAL quotient_shift_d 		: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    SIGNAL divbusy_q 				: STD_LOGIC;
    SIGNAL divbusy_d 				: STD_LOGIC;
    SIGNAL counter_q 				: INTEGER RANGE 0 TO N-1;
    SIGNAL counter_d 				: INTEGER RANGE 0 TO N-1;
    CONSTANT ZERO_N_C 				: STD_LOGIC_VECTOR(N-1 DOWNTO 0) :=(OTHERS => '0');

BEGIN

   

    comb_proc : PROCESS (DIVENA_i,DIVIDEND_i,DIVISOR_i,dividend_shift_q,divisor_q,quotient_shift_q,divbusy_q,counter_q )
        VARIABLE y_v : STD_LOGIC_VECTOR(N DOWNTO 0);
        VARIABLE quotient_bit_v : STD_LOGIC;
        VARIABLE sub_v : STD_LOGIC_VECTOR(N DOWNTO 0);
    BEGIN    
        -- Default assignments:
		dividend_shift_d <= dividend_shift_q;
        divisor_d        <= divisor_q;
        quotient_shift_d <= quotient_shift_q;
        divbusy_d        <= divbusy_q;
        counter_d        <= counter_q;     
        y_v := (OTHERS => '0');
        quotient_bit_v := '0';

        IF divbusy_q = '0' THEN       
            IF DIVENA_i = '1' THEN
				-- upper N bits = zero ,lower N bits = DIVIDEND_i               
                dividend_shift_d <= ZERO_N_C & DIVIDEND_i;
                divisor_d <= DIVISOR_i;

			
                quotient_shift_d <= (OTHERS => '0');
				--Start counting:
                counter_d <= 0;
                divbusy_d <= '1';
            END IF;
			
        ELSE
			--Is Busy:
            -- Shift the current residue left and insert the next dividend bit.
            -- dividend_shift_q(2*N-1 DOWNTO N) is the current partial residue.
            -- dividend_shift_q(N-1) is the next bit of the original dividend.
			
            y_v := dividend_shift_q(2*N-1 DOWNTO N) & dividend_shift_q(N-1);
			quotient_bit_v := '0';

            
            -- Subtractor:
            -- Y = shifted partial residue, X = divisor
            -- If Y-X is non-negative, store the subtraction result and insert 1 into the quotient register.

            sub_v := y_v - ('0' & divisor_q);
            IF sub_v(N) = '0' THEN
                y_v := sub_v;
                quotient_bit_v := '1';
            END IF;

            -- Update the upper half of the Dividend shift register.
            dividend_shift_d(2*N-1 DOWNTO N) <= y_v(N-1 DOWNTO 0);

            -- Shift the lower half of the Dividend register left.  Insert zero at bit 0
            dividend_shift_d(N-1 DOWNTO 0) <= dividend_shift_q(N-2 DOWNTO 0) & '0';
            
            -- Shift the Quotient register left.
            -- Insert: 1 if the subtraction was non-negative 0 else
            quotient_shift_d <= quotient_shift_q(N-2 DOWNTO 0) & quotient_bit_v;
           
            -- N iterations have been executed.
            IF counter_q = N-1 THEN
                divbusy_d <= '0';
            ELSE
                counter_d <= counter_q + 1;
            END IF;
        END IF;
    END PROCESS comb_proc;
	--Initial PROCESS and update register by clock
    seq_proc : PROCESS (DIVCLK_i, DIVRST_i)
    BEGIN
        IF DIVRST_i = '1' THEN
            dividend_shift_q <= (OTHERS => '0');
            divisor_q        <= (OTHERS => '0');
            quotient_shift_q <= (OTHERS => '0');

            divbusy_q <= '0';
            counter_q <= 0;

        ELSIF rising_edge(DIVCLK_i) THEN

            dividend_shift_q <= dividend_shift_d;
            divisor_q        <= divisor_d;
            quotient_shift_q <= quotient_shift_d;

            divbusy_q <= divbusy_d;
            counter_q <= counter_d;

        END IF;
    END PROCESS seq_proc;
	
	--output assigmnets
    DIVBUSY_o  <= divbusy_q;
    QUOTIENT_o <= quotient_shift_q;   
    RESIDUE_o  <= dividend_shift_q(2*N-1 DOWNTO N);

END div;