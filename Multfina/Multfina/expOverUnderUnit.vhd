LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY expOverUnderUnit IS
PORT(
    i_exp_final  : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);

    o_underflow  : OUT STD_LOGIC;
    o_overflow   : OUT STD_LOGIC;
    o_overunder  : OUT STD_LOGIC
);
END expOverUnderUnit;

ARCHITECTURE structural OF expOverUnderUnit IS

    CONSTANT EXP_ZERO : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    CONSTANT EXP_ONES : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111111";

    COMPONENT genericComparator
    GENERIC ( n : INTEGER := 7 );
    PORT(
        i_Ai, i_Bi : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        o_GT, o_LT, o_EQ : OUT STD_LOGIC
    );
    END COMPONENT;

    SIGNAL ov_GT, ov_LT, ov_EQ : STD_LOGIC;
    SIGNAL uf_GT, uf_LT, uf_EQ : STD_LOGIC;

    SIGNAL s_overflow, s_underflow, s_overunder : STD_LOGIC;

BEGIN

    -- Overflow if exponent == all ones
    COMP_OVERFLOW : genericComparator
    GENERIC MAP ( n => 7 )
    PORT MAP(
        i_Ai => i_exp_final,
        i_Bi => EXP_ONES,
        o_GT => ov_GT,
        o_LT => ov_LT,
        o_EQ => ov_EQ
    );

    s_overflow <= ov_EQ;

    -- Underflow if exponent == 0
    COMP_UNDERFLOW : genericComparator
    GENERIC MAP ( n => 7 )
    PORT MAP(
        i_Ai => i_exp_final,
        i_Bi => EXP_ZERO,
        o_GT => uf_GT,
        o_LT => uf_LT,
        o_EQ => uf_EQ
    );

    s_underflow <= uf_EQ;

    -- Combined
    s_overunder <= s_overflow OR s_underflow;

    o_overflow  <= s_overflow;
    o_underflow <= s_underflow;
    o_overunder <= s_overunder;

END structural;
