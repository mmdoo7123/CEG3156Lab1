--------------------------------------------------------------------------------
-- 16-Bit Floating-Point Adder - CONTROL PATH (Quartus Optimized)
-- Implements ASM control logic using one-FF-per-state method
-- Optimized for Quartus with registered outputs and proper timing
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fpaddrControl IS
    PORT(
        -- Clock and Reset
        i_clock       : IN  STD_LOGIC;
        i_reset       : IN  STD_LOGIC;
        
        -- External control
        i_start       : IN  STD_LOGIC;
        
        -- Status signals from Datapath (buffered inputs)
        ediffNegative : IN  STD_LOGIC;
        ediffLarge    : IN  STD_LOGIC;
        needsNorm     : IN  STD_LOGIC;
        
        -- Control signals to Datapath (registered outputs)
        loadInputs    : BUFFER STD_LOGIC;
        calcExpDiff   : BUFFER STD_LOGIC;
        negateEdiff   : BUFFER STD_LOGIC;
        setFLAG       : BUFFER STD_LOGIC;
        shiftSmaller  : BUFFER STD_LOGIC;
        clearSmaller  : BUFFER STD_LOGIC;
        addFractions  : BUFFER STD_LOGIC;
        selectExp     : BUFFER STD_LOGIC;
        normalize     : BUFFER STD_LOGIC;
        
        -- Done signal
        o_done        : BUFFER STD_LOGIC
    );
END fpaddrControl;

ARCHITECTURE structural OF fpaddrControl IS
    
    -- Component Declaration for D Flip-Flop
    COMPONENT enARdFF_2 IS
        PORT(
            i_resetBar : IN  STD_LOGIC;
            i_d        : IN  STD_LOGIC;
            i_enable   : IN  STD_LOGIC;
            i_clock    : IN  STD_LOGIC;
            o_q, o_qBar: OUT STD_LOGIC
        );
    END COMPONENT;
    
    -- State signals (one-FF-per-state)
    signal state_s0  : STD_LOGIC;  -- IDLE
    signal state_s1  : STD_LOGIC;  -- LOAD inputs
    signal state_s2  : STD_LOGIC;  -- Calculate exponent difference
    signal state_s3  : STD_LOGIC;  -- Check sign of Ediff
    signal state_s4  : STD_LOGIC;  -- Align A (if ExpB > ExpA)
    signal state_s5  : STD_LOGIC;  -- Align B (if ExpA >= ExpB)
    signal state_s6  : STD_LOGIC;  -- Add fractions
    signal state_s7  : STD_LOGIC;  -- Select exponent
    signal state_s8  : STD_LOGIC;  -- Normalize if needed
    signal state_s9  : STD_LOGIC;  -- DONE
    
    -- D inputs for flip-flops
    signal d_s0, d_s1, d_s2, d_s3, d_s4, d_s5, d_s6, d_s7, d_s8, d_s9 : STD_LOGIC;
    
    -- Unused qBar outputs
    signal qbar_unused : STD_LOGIC_VECTOR(9 DOWNTO 0);
    
    -- Control signals
    signal resetBar : STD_LOGIC;
    signal enable_all : STD_LOGIC;
    
    -- Registered status inputs for timing (Quartus optimization)
    signal ediffNegative_reg : STD_LOGIC;
    signal ediffLarge_reg    : STD_LOGIC;
    signal needsNorm_reg     : STD_LOGIC;
    
    -- Internal control signal buffers
    signal loadInputs_int    : STD_LOGIC;
    signal calcExpDiff_int   : STD_LOGIC;
    signal negateEdiff_int   : STD_LOGIC;
    signal setFLAG_int       : STD_LOGIC;
    signal shiftSmaller_int  : STD_LOGIC;
    signal clearSmaller_int  : STD_LOGIC;
    signal addFractions_int  : STD_LOGIC;
    signal selectExp_int     : STD_LOGIC;
    signal normalize_int     : STD_LOGIC;
    signal o_done_int        : STD_LOGIC;
    
BEGIN
    
    resetBar <= NOT i_reset;
    enable_all <= '1';  -- Always enabled
    
    -- ========================================================================
    -- INPUT SYNCHRONIZATION (Quartus timing optimization)
    -- ========================================================================
    SYNC_INPUTS: process(i_clock, i_reset)
    begin
        if i_reset = '1' then
            ediffNegative_reg <= '0';
            ediffLarge_reg <= '0';
            needsNorm_reg <= '0';
        elsif rising_edge(i_clock) then
            ediffNegative_reg <= ediffNegative;
            ediffLarge_reg <= ediffLarge;
            needsNorm_reg <= needsNorm;
        end if;
    end process;
    
    -- ========================================================================
    -- STATE FLIP-FLOPS (One-FF-Per-State Method)
    -- ========================================================================
    
    FF_S0: enARdFF_2 PORT MAP (
        i_resetBar => resetBar,
        i_d        => d_s0,
        i_enable   => enable_all,
        i_clock    => i_clock,
        o_q        => state_s0,
        o_qBar     => qbar_unused(0)
    );
    
    FF_S1: enARdFF_2 PORT MAP (
        i_resetBar => resetBar,
        i_d        => d_s1,
        i_enable   => enable_all,
        i_clock    => i_clock,
        o_q        => state_s1,
        o_qBar     => qbar_unused(1)
    );
    
    FF_S2: enARdFF_2 PORT MAP (
        i_resetBar => resetBar,
        i_d        => d_s2,
        i_enable   => enable_all,
        i_clock    => i_clock,
        o_q        => state_s2,
        o_qBar     => qbar_unused(2)
    );
    
    FF_S3: enARdFF_2 PORT MAP (
        i_resetBar => resetBar,
        i_d        => d_s3,
        i_enable   => enable_all,
        i_clock    => i_clock,
        o_q        => state_s3,
        o_qBar     => qbar_unused(3)
    );
    
    FF_S4: enARdFF_2 PORT MAP (
        i_resetBar => resetBar,
        i_d        => d_s4,
        i_enable   => enable_all,
        i_clock    => i_clock,
        o_q        => state_s4,
        o_qBar     => qbar_unused(4)
    );
    
    FF_S5: enARdFF_2 PORT MAP (
        i_resetBar => resetBar,
        i_d        => d_s5,
        i_enable   => enable_all,
        i_clock    => i_clock,
        o_q        => state_s5,
        o_qBar     => qbar_unused(5)
    );
    
    FF_S6: enARdFF_2 PORT MAP (
        i_resetBar => resetBar,
        i_d        => d_s6,
        i_enable   => enable_all,
        i_clock    => i_clock,
        o_q        => state_s6,
        o_qBar     => qbar_unused(6)
    );
    
    FF_S7: enARdFF_2 PORT MAP (
        i_resetBar => resetBar,
        i_d        => d_s7,
        i_enable   => enable_all,
        i_clock    => i_clock,
        o_q        => state_s7,
        o_qBar     => qbar_unused(7)
    );
    
    FF_S8: enARdFF_2 PORT MAP (
        i_resetBar => resetBar,
        i_d        => d_s8,
        i_enable   => enable_all,
        i_clock    => i_clock,
        o_q        => state_s8,
        o_qBar     => qbar_unused(8)
    );
    
    FF_S9: enARdFF_2 PORT MAP (
        i_resetBar => resetBar,
        i_d        => d_s9,
        i_enable   => enable_all,
        i_clock    => i_clock,
        o_q        => state_s9,
        o_qBar     => qbar_unused(9)
    );
    
    -- ========================================================================
    -- STATE TRANSITION LOGIC (combinational)
    -- ========================================================================
    
    d_s0 <= (state_s0 AND NOT i_start) OR state_s9;
    d_s1 <= (state_s0 AND i_start);
    d_s2 <= state_s1;
    d_s3 <= state_s2;
    d_s4 <= (state_s3 AND ediffNegative_reg);
    d_s5 <= (state_s3 AND NOT ediffNegative_reg);
    d_s6 <= state_s4 OR state_s5;
    d_s7 <= state_s6;
    d_s8 <= state_s7;
    d_s9 <= state_s8;
    
    -- ========================================================================
    -- CONTROL SIGNAL GENERATION (combinational logic)
    -- ========================================================================
    
    loadInputs_int    <= state_s1;
    calcExpDiff_int   <= state_s2;
    negateEdiff_int   <= state_s4;
    setFLAG_int       <= state_s4;
    shiftSmaller_int  <= state_s4 OR state_s5;
    clearSmaller_int  <= (state_s4 OR state_s5) AND ediffLarge_reg;
    addFractions_int  <= state_s6;
    selectExp_int     <= state_s7;
    normalize_int     <= state_s8 AND needsNorm_reg;
    o_done_int        <= state_s9;
    
    -- ========================================================================
    -- OUTPUT REGISTERS (Quartus optimization - registered outputs)
    -- ========================================================================
    
    OUTPUT_REGS: process(i_clock, i_reset)
    begin
        if i_reset = '1' then
            loadInputs   <= '0';
            calcExpDiff  <= '0';
            negateEdiff  <= '0';
            setFLAG      <= '0';
            shiftSmaller <= '0';
            clearSmaller <= '0';
            addFractions <= '0';
            selectExp    <= '0';
            normalize    <= '0';
            o_done       <= '0';
        elsif rising_edge(i_clock) then
            loadInputs   <= loadInputs_int;
            calcExpDiff  <= calcExpDiff_int;
            negateEdiff  <= negateEdiff_int;
            setFLAG      <= setFLAG_int;
            shiftSmaller <= shiftSmaller_int;
            clearSmaller <= clearSmaller_int;
            addFractions <= addFractions_int;
            selectExp    <= selectExp_int;
            normalize    <= normalize_int;
            o_done       <= o_done_int;
        end if;
    end process;
    
END structural;