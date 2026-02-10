LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- ShiftRight / Normalization unit for 18-bit mantissa product (9x9)
ENTITY fp_shiftright_norm IS
    PORT(
        clk     : IN  STD_LOGIC;
        reset   : IN  STD_LOGIC;                        -- active-HIGH global reset

        i_load9 : IN  STD_LOGIC;                        -- load 18-bit product into reg
        i_SHR8  : IN  STD_LOGIC;                        -- 1 => normalization select (shifted bits)

        i_Mz    : IN  STD_LOGIC_VECTOR(17 DOWNTO 0);    -- 18-bit product from multiplier
        o_RMz   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)      -- final 8-bit mantissa (fraction field)
    );
END fp_shiftright_norm;

ARCHITECTURE structural OF fp_shiftright_norm IS

    -------------------------------------------------------------------------
    -- Required DFF (enabled, async reset) from course
    -------------------------------------------------------------------------
    COMPONENT enARdFF_2 IS
        PORT(
            i_resetBar : IN  STD_LOGIC;
            i_d        : IN  STD_LOGIC;
            i_enable   : IN  STD_LOGIC;
            i_clock    : IN  STD_LOGIC;
            o_q        : OUT STD_LOGIC;
            o_qBar     : OUT STD_LOGIC
        );
    END COMPONENT;

    -------------------------------------------------------------------------
    -- Your provided N-bit 2:1 mux (structural)
    -- i_Sel = 0 picks i_A, i_Sel = 1 picks i_B
    -------------------------------------------------------------------------
    COMPONENT genericMux2to1 IS
        GENERIC ( n : INTEGER := 8 );
        PORT(
            i_A   : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            i_B   : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            i_Sel : IN  STD_LOGIC;
            o_Out : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL resetBar : STD_LOGIC;

    -- 18-bit register built from enARdFF_2
    SIGNAL reg_mz   : STD_LOGIC_VECTOR(17 DOWNTO 0);
    SIGNAL reg_mz_b : STD_LOGIC_VECTOR(17 DOWNTO 0); -- qBar (unused, but wired)

    -- Two candidate 8-bit slices + mux output
    SIGNAL slice_norm : STD_LOGIC_VECTOR(7 DOWNTO 0); -- reg_mz(16 downto 9)
    SIGNAL slice_trunc: STD_LOGIC_VECTOR(7 DOWNTO 0); -- reg_mz(15 downto 8)
    SIGNAL mux_out    : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    -- Convert active-HIGH reset to active-LOW resetBar for enARdFF_2
    resetBar <= NOT reset;

    -------------------------------------------------------------------------
    -- 18-bit storage register (async reset, enabled load)
    -------------------------------------------------------------------------
    gen_reg : FOR k IN 0 TO 17 GENERATE
        u_ff : enARdFF_2
            PORT MAP(
                i_resetBar => resetBar,
                i_d        => i_Mz(k),
                i_enable   => i_load9,
                i_clock    => clk,
                o_q        => reg_mz(k),
                o_qBar     => reg_mz_b(k)
            );
    END GENERATE;

    -------------------------------------------------------------------------
    -- Define the two slices (pure wiring)
    -------------------------------------------------------------------------
    slice_norm  <= reg_mz(16 DOWNTO 9); -- normalization (right shift by 1)
    slice_trunc <= reg_mz(15 DOWNTO 8); -- already normalized (truncate)

    -------------------------------------------------------------------------
    -- Structural mux selection:
    -- i_SHR8 = 0 -> pick slice_trunc
    -- i_SHR8 = 1 -> pick slice_norm
    --
    -- Your mux: i_Sel=0 picks A, i_Sel=1 picks B
    -------------------------------------------------------------------------
    u_mux : genericMux2to1
        GENERIC MAP ( n => 8 )
        PORT MAP (
            i_A   => slice_trunc,
            i_B   => slice_norm,
            i_Sel => i_SHR8,
            o_Out => mux_out
        );

    -------------------------------------------------------------------------
    -- Output
    -------------------------------------------------------------------------
    o_RMz <= mux_out;

END structural;
