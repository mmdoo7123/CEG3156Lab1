LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY exponentIncrementer IS
    PORT(
        i_inc       : IN  STD_LOGIC; -- Triggered by Big ALU carry-out
        i_expIn     : IN  STD_LOGIC_VECTOR(6 downto 0);
        o_expOut    : OUT STD_LOGIC_VECTOR(6 downto 0)
    );
END exponentIncrementer;

ARCHITECTURE structural OF exponentIncrementer IS
    COMPONENT genericAdder IS
        GENERIC (n : integer := 7);
        PORT (i_Ai, i_Bi : IN STD_LOGIC_VECTOR(n-1 downto 0); i_CarryIn : IN STD_LOGIC; o_Sum : OUT STD_LOGIC_VECTOR(n-1 downto 0));
    END COMPONENT;

    SIGNAL w_currentExp : STD_LOGIC_VECTOR(6 downto 0);
    SIGNAL w_adjResult : STD_LOGIC_VECTOR(6 downto 0);
    SIGNAL w_adjVal : STD_LOGIC_VECTOR(6 downto 0);

BEGIN
  
    w_adjVal <= "0000001" WHEN i_inc = '1' ELSE "1111111";
	  w_currentExp <=i_expIn ;
    adjuster: genericAdder
        GENERIC MAP (n => 7)
        PORT MAP(i_Ai => w_currentExp, i_Bi => w_adjVal, i_CarryIn => '0', o_Sum => w_adjResult);


    o_expOut <= w_adjResult;

END structural;