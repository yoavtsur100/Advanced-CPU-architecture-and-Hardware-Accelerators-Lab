LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
entity PWM IS
		port
		(
		Y_i,X_i: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		  MODE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		  EN : in std_logic;
		  rst :in std_logic;
		  clk : in std_logic;
		  PWMout : out std_logic );
end PWM;
-------------------------------------------
architecture pw of PWM is 
	signal counter_q : STD_LOGIC_VECTOR(15 downto 0):=(others =>'0');
	signal EQUY : std_logic;
	signal Toggle_state : std_logic :='0';
	signal Toggle_w : std_logic;
	signal pwm_reg: std_logic;
	signal prev_mode : std_logic_vector(2 downto 0) := "000";
	--signal mode_changed : std_logic;
	


	begin
	--16-bit Timer Process:
		process(clk,rst)
		
		begin
			if rst = '1' then --or mode_changed = '1' then	
				counter_q <= (others => '0');			
				PWMout <= '0';
				Toggle_state <= '0';
				prev_mode <= MODE;
			elsif (clk'event and clk='1') then	
				if EN = '1'  then
					if EQUY = '1'  then
						counter_q <= (others => '0');
					else
					counter_q <= counter_q + 1;					
					end if;
					
					--Buffer after Digital Circuit:
					if (counter_q = X_i) then
						Toggle_state <= not Toggle_state;
					end if;
					prev_mode <= MODE;
					PWMout <= pwm_reg;
					
					
			end if;
			end if;
		end process;
		
		---Repeat when finish Cycle:
		EQUY <= '1' when counter_q = (Y_i - 1) else '0';
		Toggle_w <= not Toggle_state when (counter_q = X_i) else Toggle_state;	
		
		--mode_changed <= '1' when MODE /= prev_mode else '0';
		
		--Digital Circuit
		process(mode,counter_q,X_i,Toggle_w)
		begin
			 case mode is
			 
			 ---Set/Reset:
			 when "000" =>
			 if counter_q < X_i then
				pwm_reg <= '0';
			else
			pwm_reg <= '1';
			end if;
			
			---Reset/set:
			when "001" =>
			 if counter_q < X_i then
				pwm_reg <= '1';
			else
			pwm_reg <= '0';
			end if;
			
			--Toggle:
			when "010" =>
				pwm_reg <= Toggle_w;
			
			when others =>
			pwm_reg <= '0';
			
			end case;
			
		end process;

end pw;