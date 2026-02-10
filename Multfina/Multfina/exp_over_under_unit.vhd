LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY exp_over_under_unit IS

    PORT(
        -- Nonzero flags for operands (recommended from unpack stage)
        i_a_nonzero  : IN  STD_LOGIC;
        i_b_nonzero  : IN  STD_LOGIC;

        -- Final exponent field (after bias/sub/normalize/round)
        i_exp_final  : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);

        -- Optional carry/overflow indicator from exponent arithmetic
        i_exp_carry  : IN  STD_LOGIC;

        -- Outputs
        o_underflow  : OUT STD_LOGIC;
        o_overflow   : OUT STD_LOGIC;
        o_over_under : OUT STD_LOGIC
    );
END exp_over_under_unit;

ARCHITECTURE rtl OF exp_over_under_unit IS
    CONSTANT EXP_ZERO : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
    CONSTANT EXP_ONES : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '1');

    SIGNAL s_operands_nonzero : STD_LOGIC;
    SIGNAL s_exp_is_zero      : STD_LOGIC;
    SIGNAL s_exp_is_ones      : STD_LOGIC;
BEGIN
    -- both operands are nonzero
    s_operands_nonzero <= i_a_nonzero AND i_b_nonzero;

    -- exponent == 0  => subnormal/zero range
    s_exp_is_zero <= '1' WHEN (i_exp_final = EXP_ZERO) ELSE '0';

    -- exponent == all ones => Inf/NaN range (or overflow saturating)
    s_exp_is_ones <= '1' WHEN (i_exp_final = EXP_ONES) ELSE '0';

    -- Underflow (simple): operands nonzero AND exponent becomes 0
    o_underflow <= s_operands_nonzero AND s_exp_is_zero;

    -- Overflow (simple): exponent becomes all ones OR arithmetic carry says it overflowed
    o_overflow <= s_exp_is_ones OR i_exp_carry;

    -- Combined flag (useful for your controller i_overflow_under input)
    o_over_under <= o_underflow OR o_overflow;

END rtl;
