LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY Adder IS
  GENERIC (length : INTEGER := 16);
  PORT ( a_i, b_i: IN STD_LOGIC_VECTOR (length-1 DOWNTO 0);
          cin_i: IN STD_LOGIC;
            s_o: OUT STD_LOGIC_VECTOR (length-1 DOWNTO 0);
         cout_o: OUT STD_LOGIC);
END Adder;
--------------------------------------------------------
ARCHITECTURE rtl OF Adder IS
BEGIN
  PROCESS (a_i, b_i, cin_i)
    VARIABLE carry_v : STD_LOGIC_VECTOR (length DOWNTO 0);
  BEGIN
    carry_v(0) := cin_i;
    FOR i IN 0 TO length-1 LOOP
       s_o(i) <= a_i(i) XOR b_i(i) XOR carry_v(i);
       carry_v(i+1) := (a_i(i) AND b_i(i)) OR (a_i(i) AND
       carry_v(i)) OR (b_i(i) AND carry_v(i));
    END LOOP;
    cout_o <= carry_v(length);
  END PROCESS;
END rtl;

