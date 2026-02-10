--------------------------------------------------------------------------------
-- 16-Bit Floating-Point Adder - DATAPATH (Quartus Optimized)
-- Format: [15] Sign, [14:8] Exponent (7-bit, bias=63), [7:0] Mantissa (8-bit)
-- Implements exponent alignment and fraction addition
-- Quartus-friendly with BUFFER ports and registered outputs
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY fpaddrDatapath IS
    PORT(
        -- Clock and Reset
        i_clock     : IN  STD_LOGIC;
        i_reset     : IN  STD_LOGIC;
        
        -- Inputs
        SignA       : IN  STD_LOGIC;
        MantissaA   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        ExponentA   : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
        SignB       : IN  STD_LOGIC;
        MantissaB   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        ExponentB   : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
        
        -- Control Signals from Control Path
        loadInputs    : IN  STD_LOGIC;  -- Load A and B into registers
        calcExpDiff   : IN  STD_LOGIC;  -- Calculate exponent difference
        negateEdiff   : IN  STD_LOGIC;  -- Take absolute value of Ediff
        setFLAG       : IN  STD_LOGIC;  -- Set FLAG (Y is larger)
        shiftSmaller  : IN  STD_LOGIC;  -- Shift the smaller mantissa
        clearSmaller  : IN  STD_LOGIC;  -- Clear smaller mantissa if diff too large
        addFractions  : IN  STD_LOGIC;  -- Add aligned fractions
        selectExp     : IN  STD_LOGIC;  -- Select correct exponent (0=X, 1=Y)
        normalize     : IN  STD_LOGIC;  -- Normalize if overflow
        
        -- Status Signals to Control Path (BUFFER for Quartus)
        ediffNegative : BUFFER STD_LOGIC;  -- Ediff < 0
        ediffLarge    : BUFFER STD_LOGIC;  -- Ediff >= 9
        needsNorm     : BUFFER STD_LOGIC;  -- Result needs normalization
        
        -- Outputs (BUFFER for internal readback)
        SignOut       : BUFFER STD_LOGIC;
        MantissaOut   : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0);
        ExponentOut   : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
        Overflow      : BUFFER STD_LOGIC
    );
END fpaddrDatapath;

ARCHITECTURE structural OF fpaddrDatapath IS
    
    -- Component Declarations
    COMPONENT genericAdder IS
        GENERIC (n : integer := 8);
        PORT(
            i_Ai, i_Bi  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            i_CarryIn   : IN  STD_LOGIC;
            o_Sum       : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            o_CarryOut  : OUT STD_LOGIC
        );
    END COMPONENT;
    
    COMPONENT genericMux2to1 IS
        GENERIC (n : integer := 8);
        PORT(
            i_A, i_B  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            i_Sel     : IN  STD_LOGIC;
            o_Out     : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT genericRegister IS
        GENERIC (n : integer := 8);
        PORT(
            i_clock     : IN  STD_LOGIC;
            i_resetBar  : IN  STD_LOGIC;
            i_load      : IN  STD_LOGIC;
            i_data      : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            o_q         : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
        );
    END COMPONENT;
    
    -- Internal Signals
    signal resetBar : STD_LOGIC;
    
    -- Input buffers (registered inputs for better timing)
    signal SignA_buf      : STD_LOGIC;
    signal MantissaA_buf  : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal ExponentA_buf  : STD_LOGIC_VECTOR(6 DOWNTO 0);
    signal SignB_buf      : STD_LOGIC;
    signal MantissaB_buf  : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal ExponentB_buf  : STD_LOGIC_VECTOR(6 DOWNTO 0);
    
    -- Registers for mantissas with implicit 1 (9 bits = 1.MMMMMMMM)
    signal regMantA      : STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal regMantB      : STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal regMantA_data : STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal regMantB_data : STD_LOGIC_VECTOR(8 DOWNTO 0);
    
    -- Registers for exponents
    signal regExpA       : STD_LOGIC_VECTOR(6 DOWNTO 0);
    signal regExpB       : STD_LOGIC_VECTOR(6 DOWNTO 0);
    
    -- Sign registers
    signal regSignA      : STD_LOGIC;
    signal regSignB      : STD_LOGIC;
    
    -- Exponent difference signals
    signal ediff         : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal ediff_data    : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal ediff_abs     : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal expA_extended : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal expB_extended : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal expB_negated  : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal ediff_negated : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal exp_carry_out : STD_LOGIC;
    
    -- Intermediate buffered signals
    signal ediff_abs_computed : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    -- FLAG register
    signal FLAG          : STD_LOGIC;
    
    -- Shift amount (limited to 0-8)
    signal shift_amount  : INTEGER RANGE 0 TO 8;
    signal shift_amount_reg : INTEGER RANGE 0 TO 8;
    
    -- Shifter outputs (registered)
    signal mantA_shifted : STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal mantB_shifted : STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal mantA_shifted_reg : STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal mantB_shifted_reg : STD_LOGIC_VECTOR(8 DOWNTO 0);
    
    -- Aligned mantissas
    signal mantA_aligned : STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal mantB_aligned : STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal mantA_aligned_reg : STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal mantB_aligned_reg : STD_LOGIC_VECTOR(8 DOWNTO 0);
    
    -- Addition result
    signal frac_sum      : STD_LOGIC_VECTOR(9 DOWNTO 0);
    signal frac_carry    : STD_LOGIC;
    
    -- Result registers
    signal regFracResult : STD_LOGIC_VECTOR(9 DOWNTO 0);
    signal regExpResult  : STD_LOGIC_VECTOR(6 DOWNTO 0);
    signal regSignResult : STD_LOGIC;
    
    -- Normalized values
    signal frac_normalized : STD_LOGIC_VECTOR(9 DOWNTO 0);
    signal exp_normalized  : STD_LOGIC_VECTOR(6 DOWNTO 0);
    signal exp_incremented : STD_LOGIC_VECTOR(6 DOWNTO 0);
    signal exp_inc_carry   : STD_LOGIC;
    
    -- Selected exponent
    signal exp_selected  : STD_LOGIC_VECTOR(6 DOWNTO 0);
    signal exp_selected_buf : STD_LOGIC_VECTOR(6 DOWNTO 0);
    
    -- Registered status signals (internal)
    signal ediffNegative_int : STD_LOGIC;
    signal ediffLarge_int    : STD_LOGIC;
    signal needsNorm_int     : STD_LOGIC;
    
BEGIN
    
    resetBar <= NOT i_reset;
    
    -- ========================================================================
    -- INPUT BUFFERS: Register all inputs for better timing closure
    -- ========================================================================
    INPUT_BUF_PROC: process(i_clock, i_reset)
    begin
        if i_reset = '1' then
            SignA_buf <= '0';
            MantissaA_buf <= (others => '0');
            ExponentA_buf <= (others => '0');
            SignB_buf <= '0';
            MantissaB_buf <= (others => '0');
            ExponentB_buf <= (others => '0');
        elsif rising_edge(i_clock) then
            SignA_buf <= SignA;
            MantissaA_buf <= MantissaA;
            ExponentA_buf <= ExponentA;
            SignB_buf <= SignB;
            MantissaB_buf <= MantissaB;
            ExponentB_buf <= ExponentB;
        end if;
    end process;
    
    -- ========================================================================
    -- INPUT STAGE: Load inputs and prepend implicit 1 to mantissas
    -- ========================================================================
    
    regMantA_data <= '1' & MantissaA_buf;
    regMantB_data <= '1' & MantissaB_buf;
    
    -- Mantissa A Register (9 bits)
    REG_MANT_A: genericRegister
        GENERIC MAP (n => 9)
        PORT MAP (
            i_clock    => i_clock,
            i_resetBar => resetBar,
            i_load     => loadInputs,
            i_data     => regMantA_data,
            o_q        => regMantA
        );
    
    -- Mantissa B Register (9 bits)
    REG_MANT_B: genericRegister
        GENERIC MAP (n => 9)
        PORT MAP (
            i_clock    => i_clock,
            i_resetBar => resetBar,
            i_load     => loadInputs,
            i_data     => regMantB_data,
            o_q        => regMantB
        );
    
    -- Exponent A Register (7 bits)
    REG_EXP_A: genericRegister
        GENERIC MAP (n => 7)
        PORT MAP (
            i_clock    => i_clock,
            i_resetBar => resetBar,
            i_load     => loadInputs,
            i_data     => ExponentA_buf,
            o_q        => regExpA
        );
    
    -- Exponent B Register (7 bits)
    REG_EXP_B: genericRegister
        GENERIC MAP (n => 7)
        PORT MAP (
            i_clock    => i_clock,
            i_resetBar => resetBar,
            i_load     => loadInputs,
            i_data     => ExponentB_buf,
            o_q        => regExpB
        );
    
    -- Sign registers
    SIGN_REG_PROC: process(i_clock, i_reset)
    begin
        if i_reset = '1' then
            regSignA <= '0';
            regSignB <= '0';
        elsif rising_edge(i_clock) then
            if loadInputs = '1' then
                regSignA <= SignA_buf;
                regSignB <= SignB_buf;
            end if;
        end if;
    end process;
    
    -- ========================================================================
    -- EXPONENT DIFFERENCE CALCULATION
    -- ========================================================================
    
    expA_extended <= '0' & regExpA;
    expB_extended <= '0' & regExpB;
    
    -- Generate NOT gates for 2's complement
    NEG_EXPB_GEN: for i in 0 to 7 generate
        expB_negated(i) <= NOT expB_extended(i);
    end generate;
    
    -- ExpA - ExpB adder
    ADDER_EXPDIFF: genericAdder
        GENERIC MAP (n => 8)
        PORT MAP (
            i_Ai       => expA_extended,
            i_Bi       => expB_negated,
            i_CarryIn  => '1',
            o_Sum      => ediff_data,
            o_CarryOut => exp_carry_out
        );
    
    -- Ediff Register
    REG_EDIFF: genericRegister
        GENERIC MAP (n => 8)
        PORT MAP (
            i_clock    => i_clock,
            i_resetBar => resetBar,
            i_load     => calcExpDiff,
            i_data     => ediff_data,
            o_q        => ediff
        );
    
    -- Status: Ediff negative (registered for timing)
    STATUS_REG_PROC: process(i_clock, i_reset)
    begin
        if i_reset = '1' then
            ediffNegative_int <= '0';
            ediffNegative <= '0';
        elsif rising_edge(i_clock) then
            ediffNegative_int <= ediff(7);
            ediffNegative <= ediffNegative_int;
        end if;
    end process;
    
    -- ========================================================================
    -- ABSOLUTE VALUE CALCULATION
    -- ========================================================================
    
    NEG_EDIFF_GEN: for i in 0 to 7 generate
        ediff_negated(i) <= NOT ediff(i);
    end generate;
    
    ADDER_ABS: genericAdder
        GENERIC MAP (n => 8)
        PORT MAP (
            i_Ai       => ediff_negated,
            i_Bi       => (others => '0'),
            i_CarryIn  => '1',
            o_Sum      => ediff_abs_computed,
            o_CarryOut => open
        );
    
    -- Register absolute value
    process(i_clock, i_reset)
    begin
        if i_reset = '1' then
            ediff_abs <= (others => '0');
            shift_amount <= 0;
            shift_amount_reg <= 0;
            ediffLarge_int <= '0';
            ediffLarge <= '0';
        elsif rising_edge(i_clock) then
            if negateEdiff = '1' then
                ediff_abs <= ediff_abs_computed;
                if unsigned(ediff_abs_computed) >= 9 then
                    shift_amount <= 8;
                    ediffLarge_int <= '1';
                else
                    shift_amount <= to_integer(unsigned(ediff_abs_computed(2 DOWNTO 0)));
                    ediffLarge_int <= '0';
                end if;
            elsif calcExpDiff = '1' then
                ediff_abs <= ediff;
                if unsigned(ediff) >= 9 then
                    shift_amount <= 8;
                    ediffLarge_int <= '1';
                else
                    shift_amount <= to_integer(unsigned(ediff(2 DOWNTO 0)));
                    ediffLarge_int <= '0';
                end if;
            end if;
            shift_amount_reg <= shift_amount;
            ediffLarge <= ediffLarge_int;
        end if;
    end process;
    
    -- ========================================================================
    -- FLAG REGISTER
    -- ========================================================================
    
    FLAG_PROC: process(i_clock, i_reset)
    begin
        if i_reset = '1' then
            FLAG <= '0';
        elsif rising_edge(i_clock) then
            if calcExpDiff = '1' then
                FLAG <= '0';
            elsif setFLAG = '1' then
                FLAG <= '1';
            end if;
        end if;
    end process;
    
    -- ========================================================================
    -- BARREL SHIFTERS (with registered outputs)
    -- ========================================================================
    
    SHIFT_PROC: process(i_clock, i_reset)
    begin
        if i_reset = '1' then
            mantA_shifted_reg <= (others => '0');
            mantB_shifted_reg <= (others => '0');
        elsif rising_edge(i_clock) then
            if shiftSmaller = '1' and negateEdiff = '1' then
                mantA_shifted_reg <= std_logic_vector(shift_right(unsigned(regMantA), shift_amount_reg));
                mantB_shifted_reg <= regMantB;
            elsif shiftSmaller = '1' and negateEdiff = '0' then
                mantA_shifted_reg <= regMantA;
                mantB_shifted_reg <= std_logic_vector(shift_right(unsigned(regMantB), shift_amount_reg));
            else
                mantA_shifted_reg <= regMantA;
                mantB_shifted_reg <= regMantB;
            end if;
        end if;
    end process;
    
    -- ========================================================================
    -- ALIGNMENT WITH CLEAR LOGIC (registered)
    -- ========================================================================
    
    ALIGN_PROC: process(i_clock, i_reset)
    begin
        if i_reset = '1' then
            mantA_aligned_reg <= (others => '0');
            mantB_aligned_reg <= (others => '0');
        elsif rising_edge(i_clock) then
            if clearSmaller = '1' and ediffLarge = '1' then
                if negateEdiff = '1' then
                    mantA_aligned_reg <= (others => '0');
                    mantB_aligned_reg <= mantB_shifted_reg;
                else
                    mantA_aligned_reg <= mantA_shifted_reg;
                    mantB_aligned_reg <= (others => '0');
                end if;
            else
                mantA_aligned_reg <= mantA_shifted_reg;
                mantB_aligned_reg <= mantB_shifted_reg;
            end if;
        end if;
    end process;
    
    -- ========================================================================
    -- FRACTION ADDITION
    -- ========================================================================
    
    ADDER_FRAC: genericAdder
        GENERIC MAP (n => 9)
        PORT MAP (
            i_Ai       => mantA_aligned_reg,
            i_Bi       => mantB_aligned_reg,
            i_CarryIn  => '0',
            o_Sum      => frac_sum(8 DOWNTO 0),
            o_CarryOut => frac_sum(9)
        );
    
    -- Fraction Result Register
    REG_FRAC_RESULT: genericRegister
        GENERIC MAP (n => 10)
        PORT MAP (
            i_clock    => i_clock,
            i_resetBar => resetBar,
            i_load     => addFractions,
            i_data     => frac_sum,
            o_q        => regFracResult
        );
    
    -- Status: needs normalization (registered)
    NORM_STATUS_PROC: process(i_clock, i_reset)
    begin
        if i_reset = '1' then
            needsNorm_int <= '0';
            needsNorm <= '0';
        elsif rising_edge(i_clock) then
            needsNorm_int <= regFracResult(9) OR regFracResult(8);
            needsNorm <= needsNorm_int;
        end if;
    end process;
    
    -- ========================================================================
    -- EXPONENT SELECTION
    -- ========================================================================
    
    MUX_EXP_SELECT: genericMux2to1
        GENERIC MAP (n => 7)
        PORT MAP (
            i_A   => regExpA,
            i_B   => regExpB,
            i_Sel => FLAG,
            o_Out => exp_selected
        );
    
    -- Buffer selected exponent
    EXP_SEL_BUF_PROC: process(i_clock, i_reset)
    begin
        if i_reset = '1' then
            exp_selected_buf <= (others => '0');
        elsif rising_edge(i_clock) then
            exp_selected_buf <= exp_selected;
        end if;
    end process;
    
    -- Exponent Result Register
    REG_EXP_RESULT: genericRegister
        GENERIC MAP (n => 7)
        PORT MAP (
            i_clock    => i_clock,
            i_resetBar => resetBar,
            i_load     => selectExp,
            i_data     => exp_selected_buf,
            o_q        => regExpResult
        );
    
    -- ========================================================================
    -- NORMALIZATION
    -- ========================================================================
    
    -- Normalize fraction
    frac_normalized <= std_logic_vector(shift_right(unsigned(regFracResult), 1)) when normalize = '1'
                       else regFracResult;
    
    -- Increment exponent
    ADDER_EXP_INC: genericAdder
        GENERIC MAP (n => 7)
        PORT MAP (
            i_Ai       => regExpResult,
            i_Bi       => (0 => '1', others => '0'),
            i_CarryIn  => '0',
            o_Sum      => exp_incremented,
            o_CarryOut => exp_inc_carry
        );
    
    exp_normalized <= exp_incremented when normalize = '1' else regExpResult;
    
    -- ========================================================================
    -- OUTPUT REGISTERS (for stable outputs and Quartus optimization)
    -- ========================================================================
    
    OUTPUT_REG_PROC: process(i_clock, i_reset)
    begin
        if i_reset = '1' then
            SignOut <= '0';
            MantissaOut <= (others => '0');
            ExponentOut <= (others => '0');
            Overflow <= '0';
            regSignResult <= '0';
        elsif rising_edge(i_clock) then
            -- Sign handling (simplified - use A's sign)
            regSignResult <= regSignA;
            SignOut <= regSignResult;
            
            -- Normalized outputs
            MantissaOut <= frac_normalized(7 DOWNTO 0);
            ExponentOut <= exp_normalized;
            Overflow <= exp_inc_carry;
        end if;
    end process;
    
END structural;