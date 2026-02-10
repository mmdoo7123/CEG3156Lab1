LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fp_multiplier_array IS
    PORT(
        i_Mx    : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);   -- 8-bit mantissas from registers
        i_My    : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_Mz    : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);  -- 18-bit product (9x9)
        o_bad8  : OUT STD_LOGIC                     -- Normalization flag (MSB of product)
    );
END fp_multiplier_array;

ARCHITECTURE structural OF fp_multiplier_array IS

    -- Provided adder component
    COMPONENT genericAdder IS
        GENERIC ( n : INTEGER := 8 );
        PORT(
            i_Ai      : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            i_Bi      : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            i_CarryIn : IN  STD_LOGIC;
            o_Sum     : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            o_CarryOut: OUT STD_LOGIC
        );
    END COMPONENT;

    -- Internal signals
    SIGNAL val_x, val_y : STD_LOGIC_VECTOR(8 DOWNTO 0);  -- 9-bit with implicit '1'

    -- 9x9 partial products
    TYPE pp_array IS ARRAY (0 TO 8) OF STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL pp : pp_array;

    -- Adder chain intermediate sums/carries
    TYPE sum_array IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(9 DOWNTO 0); -- 10-bit sums
    SIGNAL row_sum  : sum_array;
    SIGNAL row_cout : STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- Internal product bus (so we don't read OUT ports)
    SIGNAL mz_int : STD_LOGIC_VECTOR(17 DOWNTO 0);

BEGIN

    -------------------------------------------------------------------------
    -- 1) Add implicit leading bit
    -------------------------------------------------------------------------
    val_x <= '1' & i_Mx;
    val_y <= '1' & i_My;

    -------------------------------------------------------------------------
    -- 2) Generate partial products: pp(i)(j) = val_y(i) AND val_x(j)
    -------------------------------------------------------------------------
    gen_pp : FOR i IN 0 TO 8 GENERATE
        gen_bits : FOR j IN 0 TO 8 GENERATE
            pp(i)(j) <= val_x(j) AND val_y(i);
        END GENERATE;
    END GENERATE;

    -------------------------------------------------------------------------
    -- 3) Product bit 0 is directly pp(0)(0)
    -------------------------------------------------------------------------
    mz_int(0) <= pp(0)(0);

    -------------------------------------------------------------------------
    -- 4) First adder row:
    --     Add (PP0 shifted right by 1) + (PP1 aligned)
    --     Using 10-bit adder for alignment/carry room
    -------------------------------------------------------------------------
    row0 : genericAdder
        GENERIC MAP ( n => 10 )
        PORT MAP (
            -- A = 00 & pp0(8 downto 1)
            i_Ai       => '0' & '0' & pp(0)(8 DOWNTO 1),
            -- B = 0 & pp1(8 downto 0)
            i_Bi       => '0' & pp(1),
            i_CarryIn  => '0',
            o_Sum      => row_sum(0),
            o_CarryOut => row_cout(0)
        );

    -- Product bit 1 is LSB of this sum
    mz_int(1) <= row_sum(0)(0);

    -------------------------------------------------------------------------
    -- 5) Subsequent adder rows (1 to 7):
    --     Each stage adds:
    --       A = (carry from previous) & (previous sum shifted right by 1)
    --       B = 0 & pp(i+1)
    -------------------------------------------------------------------------
    gen_rows : FOR i IN 1 TO 7 GENERATE
        row_inst : genericAdder
            GENERIC MAP ( n => 10 )
            PORT MAP (
                i_Ai       => row_cout(i-1) & row_sum(i-1)(9 DOWNTO 1),
                i_Bi       => '0' & pp(i+1),
                i_CarryIn  => '0',
                o_Sum      => row_sum(i),
                o_CarryOut => row_cout(i)
            );

        -- Peel off next product bit each row
        mz_int(i+1) <= row_sum(i)(0);
    END GENERATE;

    -------------------------------------------------------------------------
    -- 6) Collect remaining high product bits from final sum row
    --
    -- IMPORTANT FIX:
    --   row_sum(7) is 10 bits: (9 downto 0)
    --   You MUST include row_sum(7)(9). That is the true product MSB (bit 17).
    --
    -- Bits:
    --   mz_int(8) already = row_sum(7)(0) from the generate loop (i=7).
    --   mz_int(16 downto 9) come from row_sum(7)(8 downto 1).
    --   mz_int(17) comes from row_sum(7)(9).
    -------------------------------------------------------------------------
    mz_int(16 DOWNTO 9) <= row_sum(7)(8 DOWNTO 1);
    mz_int(17)          <= row_sum(7)(9);

    -------------------------------------------------------------------------
    -- 7) Drive outputs
    --     bad8 should represent "needs normalization shift" => MSB of product
    -------------------------------------------------------------------------
    o_Mz   <= mz_int;
    o_bad8 <= mz_int(17);

END structural;
