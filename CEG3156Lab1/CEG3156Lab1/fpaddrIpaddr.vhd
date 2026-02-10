--------------------------------------------------------------------------------
-- 16-Bit Floating-Point Adder - TOP LEVEL (Quartus Optimized)
-- Format: [15] Sign, [14:8] Exponent (7-bit), [7:0] Mantissa (8-bit)
-- Combines Datapath and Control Path
-- Quartus-friendly with registered I/O and proper buffering
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fpaddrIpaddr IS
    PORT(
        -- Operand A
        SignA       : IN  STD_LOGIC;
        MantissaA   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        ExponentA   : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
        
        -- Operand B
        SignB       : IN  STD_LOGIC;
        MantissaB   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        ExponentB   : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
        
        -- Control
        GClock      : IN  STD_LOGIC;
        GReset      : IN  STD_LOGIC;
        
        -- Result (BUFFER for Quartus)
        SignOut     : BUFFER STD_LOGIC;
        MantissaOut : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0);
        ExponentOut : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
        Overflow    : BUFFER STD_LOGIC
    );
END fpaddrIpaddr;

ARCHITECTURE structural OF fpaddrIpaddr IS
    
    -- Component Declarations
    COMPONENT fpaddrDatapath IS
        PORT(
            i_clock       : IN  STD_LOGIC;
            i_reset       : IN  STD_LOGIC;
            SignA         : IN  STD_LOGIC;
            MantissaA     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            ExponentA     : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
            SignB         : IN  STD_LOGIC;
            MantissaB     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            ExponentB     : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
            loadInputs    : IN  STD_LOGIC;
            calcExpDiff   : IN  STD_LOGIC;
            negateEdiff   : IN  STD_LOGIC;
            setFLAG       : IN  STD_LOGIC;
            shiftSmaller  : IN  STD_LOGIC;
            clearSmaller  : IN  STD_LOGIC;
            addFractions  : IN  STD_LOGIC;
            selectExp     : IN  STD_LOGIC;
            normalize     : IN  STD_LOGIC;
            ediffNegative : BUFFER STD_LOGIC;
            ediffLarge    : BUFFER STD_LOGIC;
            needsNorm     : BUFFER STD_LOGIC;
            SignOut       : BUFFER STD_LOGIC;
            MantissaOut   : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0);
            ExponentOut   : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
            Overflow      : BUFFER STD_LOGIC
        );
    END COMPONENT;
    
    COMPONENT fpaddrControl IS
        PORT(
            i_clock       : IN  STD_LOGIC;
            i_reset       : IN  STD_LOGIC;
            i_start       : IN  STD_LOGIC;
            ediffNegative : IN  STD_LOGIC;
            ediffLarge    : IN  STD_LOGIC;
            needsNorm     : IN  STD_LOGIC;
            loadInputs    : BUFFER STD_LOGIC;
            calcExpDiff   : BUFFER STD_LOGIC;
            negateEdiff   : BUFFER STD_LOGIC;
            setFLAG       : BUFFER STD_LOGIC;
            shiftSmaller  : BUFFER STD_LOGIC;
            clearSmaller  : BUFFER STD_LOGIC;
            addFractions  : BUFFER STD_LOGIC;
            selectExp     : BUFFER STD_LOGIC;
            normalize     : BUFFER STD_LOGIC;
            o_done        : BUFFER STD_LOGIC
        );
    END COMPONENT;
    
    -- Internal signals connecting Control and Datapath
    signal loadInputs    : STD_LOGIC;
    signal calcExpDiff   : STD_LOGIC;
    signal negateEdiff   : STD_LOGIC;
    signal setFLAG       : STD_LOGIC;
    signal shiftSmaller  : STD_LOGIC;
    signal clearSmaller  : STD_LOGIC;
    signal addFractions  : STD_LOGIC;
    signal selectExp     : STD_LOGIC;
    signal normalize     : STD_LOGIC;
    
    signal ediffNegative : STD_LOGIC;
    signal ediffLarge    : STD_LOGIC;
    signal needsNorm     : STD_LOGIC;
    
    signal done_internal : STD_LOGIC;
    signal start_internal: STD_LOGIC;
    
    -- Internal output buffers
    signal SignOut_int     : STD_LOGIC;
    signal MantissaOut_int : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal ExponentOut_int : STD_LOGIC_VECTOR(6 DOWNTO 0);
    signal Overflow_int    : STD_LOGIC;
    
    -- Registered inputs for timing (Quartus optimization)
    signal SignA_reg       : STD_LOGIC;
    signal MantissaA_reg   : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal ExponentA_reg   : STD_LOGIC_VECTOR(6 DOWNTO 0);
    signal SignB_reg       : STD_LOGIC;
    signal MantissaB_reg   : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal ExponentB_reg   : STD_LOGIC_VECTOR(6 DOWNTO 0);
    signal GReset_reg      : STD_LOGIC;
    signal GReset_sync     : STD_LOGIC;
    
BEGIN
    
    -- ========================================================================
    -- INPUT SYNCHRONIZATION AND BUFFERING (Quartus timing optimization)
    -- ========================================================================
    
    -- Synchronize reset (avoid metastability)
    RESET_SYNC: process(GClock)
    begin
        if rising_edge(GClock) then
            GReset_sync <= GReset;
            GReset_reg <= GReset_sync;
        end if;
    end process;
    
    -- Register all inputs for better timing closure
    INPUT_REGS: process(GClock, GReset_reg)
    begin
        if GReset_reg = '1' then
            SignA_reg <= '0';
            MantissaA_reg <= (others => '0');
            ExponentA_reg <= (others => '0');
            SignB_reg <= '0';
            MantissaB_reg <= (others => '0');
            ExponentB_reg <= (others => '0');
        elsif rising_edge(GClock) then
            SignA_reg <= SignA;
            MantissaA_reg <= MantissaA;
            ExponentA_reg <= ExponentA;
            SignB_reg <= SignB;
            MantissaB_reg <= MantissaB;
            ExponentB_reg <= ExponentB;
        end if;
    end process;
    
    -- Auto-start on reset release
    start_internal <= NOT GReset_reg;
    
    -- ========================================================================
    -- DATAPATH INSTANTIATION
    -- ========================================================================
    
    DATAPATH: fpaddrDatapath
        PORT MAP (
            i_clock       => GClock,
            i_reset       => GReset_reg,
            SignA         => SignA_reg,
            MantissaA     => MantissaA_reg,
            ExponentA     => ExponentA_reg,
            SignB         => SignB_reg,
            MantissaB     => MantissaB_reg,
            ExponentB     => ExponentB_reg,
            loadInputs    => loadInputs,
            calcExpDiff   => calcExpDiff,
            negateEdiff   => negateEdiff,
            setFLAG       => setFLAG,
            shiftSmaller  => shiftSmaller,
            clearSmaller  => clearSmaller,
            addFractions  => addFractions,
            selectExp     => selectExp,
            normalize     => normalize,
            ediffNegative => ediffNegative,
            ediffLarge    => ediffLarge,
            needsNorm     => needsNorm,
            SignOut       => SignOut_int,
            MantissaOut   => MantissaOut_int,
            ExponentOut   => ExponentOut_int,
            Overflow      => Overflow_int
        );
    
    -- ========================================================================
    -- CONTROL PATH INSTANTIATION
    -- ========================================================================
    
    CONTROL: fpaddrControl
        PORT MAP (
            i_clock       => GClock,
            i_reset       => GReset_reg,
            i_start       => start_internal,
            ediffNegative => ediffNegative,
            ediffLarge    => ediffLarge,
            needsNorm     => needsNorm,
            loadInputs    => loadInputs,
            calcExpDiff   => calcExpDiff,
            negateEdiff   => negateEdiff,
            setFLAG       => setFLAG,
            shiftSmaller  => shiftSmaller,
            clearSmaller  => clearSmaller,
            addFractions  => addFractions,
            selectExp     => selectExp,
            normalize     => normalize,
            o_done        => done_internal
        );
    
    -- ========================================================================
    -- OUTPUT BUFFERING (for stable outputs - Quartus optimization)
    -- ========================================================================
    
    OUTPUT_REGS: process(GClock, GReset_reg)
    begin
        if GReset_reg = '1' then
            SignOut <= '0';
            MantissaOut <= (others => '0');
            ExponentOut <= (others => '0');
            Overflow <= '0';
        elsif rising_edge(GClock) then
            -- Only update outputs when done
            if done_internal = '1' then
                SignOut <= SignOut_int;
                MantissaOut <= MantissaOut_int;
                ExponentOut <= ExponentOut_int;
                Overflow <= Overflow_int;
            end if;
        end if;
    end process;
    
END structural;