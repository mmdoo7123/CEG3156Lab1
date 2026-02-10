LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY smallALU IS
    PORT(
        i_ExpA, i_ExpB : IN  STD_LOGIC_VECTOR(6 downto 0);
        o_ExpDiff      : OUT STD_LOGIC_VECTOR(6 downto 0); -- Raw difference
        o_AEqB         : OUT STD_LOGIC; -- Exponents are equal
        o_AGtB         : OUT STD_LOGIC; -- A is greater than B
        o_ALtB         : OUT STD_LOGIC  -- A is less than B
    );
END smallALU;

ARCHITECTURE structural OF smallALU IS
    SIGNAL w_notB : STD_LOGIC_VECTOR(6 downto 0);
    SIGNAL vcc    : STD_LOGIC := '1';
	 COMPONENT genericAdder
        GENERIC (
            n : integer := 8
        );
        PORT(
            i_Ai, i_Bi      : IN    STD_LOGIC_VECTOR(n-1 downto 0);
            i_CarryIn       : IN    STD_LOGIC;
            o_Sum           : OUT   STD_LOGIC_VECTOR(n-1 downto 0);
            o_CarryOut      : OUT   STD_LOGIC
        );
    END COMPONENT;
	 COMPONENT genericComparator
	 GENERIC (
        n : integer := 8 -- Default width is 8, can be overridden
    );
    PORT(
        i_Ai, i_Bi            : IN    STD_LOGIC_VECTOR(n-1 downto 0);
        o_GT, o_LT, o_EQ      : OUT   STD_LOGIC
    );
    END COMPONENT;

BEGIN

    comp_inst: genericComparator
        GENERIC MAP (n => 7)
        PORT MAP(i_Ai => i_ExpA, i_Bi => i_ExpB, o_GT => o_AGtB, o_LT => o_ALtB, o_EQ => o_AEqB);

    w_notB <= NOT(i_ExpB);
    sub_inst: genericAdder
        GENERIC MAP (n => 7)
        PORT MAP(i_Ai => i_ExpA, i_Bi => w_notB, i_CarryIn => vcc, o_Sum => o_ExpDiff);
END structural;