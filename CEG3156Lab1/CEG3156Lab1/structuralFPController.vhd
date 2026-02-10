LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY structuralFPController IS
    PORT(
        -- Global Signals
        i_clock      : IN  STD_LOGIC;
        i_resetBar   : IN  STD_LOGIC;
        
        -- Inputs from Small ALU (Alignment Stage)
        i_AGtB       : IN  STD_LOGIC;
        i_ALtB       : IN  STD_LOGIC;
        i_ExpDiff    : IN  STD_LOGIC_VECTOR(6 downto 0);
        
        -- Inputs from Big ALU (Normalization Stage)
        i_BigALUSum  : IN  STD_LOGIC_VECTOR(8 downto 0); -- Resulting significand
        i_BigALUCOut : IN  STD_LOGIC;                    -- Overflow bit from Big ALU
        
        -- Control Signals for Datapath Muxes
        o_SelShift   : OUT STD_LOGIC;
        o_SelDirect  : OUT STD_LOGIC;
        o_ShiftAmt   : OUT STD_LOGIC_VECTOR(6 downto 0);
        
        -- Control Signals for Shifter and Exponent Update
        o_load       : OUT STD_LOGIC;
        o_shiftRight : OUT STD_LOGIC;
        o_shiftLeft  : OUT STD_LOGIC;
        o_incExp     : OUT STD_LOGIC; -- To Increment/Decrement unit
        o_decExp     : OUT STD_LOGIC;
        o_done       : OUT STD_LOGIC
    );
END structuralFPController;

ARCHITECTURE structural OF structuralFPController IS
    -- Using your existing generic components for structural integrity
    COMPONENT genericAdder IS
        GENERIC (n : integer := 7);
        PORT (i_Ai, i_Bi : IN STD_LOGIC_VECTOR(n-1 downto 0); i_CarryIn : IN STD_LOGIC; o_Sum : OUT STD_LOGIC_VECTOR(n-1 downto 0));
    END COMPONENT;

    COMPONENT genericMux2to1 IS
        GENERIC (n : integer := 7);
        PORT (i_A, i_B : IN STD_LOGIC_VECTOR(n-1 downto 0); i_Sel : IN STD_LOGIC; o_Out : OUT STD_LOGIC_VECTOR(n-1 downto 0));
    END COMPONENT;

    SIGNAL w_invDiff, w_absDiff : STD_LOGIC_VECTOR(6 downto 0);
    SIGNAL w_vcc : STD_LOGIC := '1';

BEGIN
    -- 1. Alignment Logic (Small ALU Interface)
    o_SelShift  <= i_AGtB; 
    o_SelDirect <= NOT i_AGtB;

    w_invDiff <= NOT(i_ExpDiff);
    abs_calc: genericAdder GENERIC MAP (n => 7) PORT MAP(i_Ai => w_invDiff, i_Bi => "0000000", i_CarryIn => w_vcc, o_Sum => w_absDiff);
    
    shift_amt_mux: genericMux2to1 
        GENERIC MAP (n => 7) 
        PORT MAP(i_A => w_absDiff, i_B => i_ExpDiff, i_Sel => i_AGtB, o_Out => o_ShiftAmt);

    -- 2. Normalization Control Logic
    -- This logic monitors the Big ALU output to decide on post-addition adjustments
    PROCESS(i_clock, i_resetBar)
    BEGIN
        IF (i_resetBar = '0') THEN
            o_load       <= '0';
            o_shiftRight <= '0';
            o_incExp     <= '0';
            o_done       <= '0';
        ELSIF (rising_edge(i_clock)) THEN
            -- Default states
            o_shiftRight <= '0';
            o_incExp     <= '0';
            o_done       <= '1'; -- Defaulting to done for single-cycle check

            -- If Big ALU has a carry-out, we must shift right and increment exponent
            IF (i_BigALUCOut = '1') THEN
                o_shiftRight <= '1';
                o_incExp     <= '1';
            END IF;
            
            -- Additional logic for leading zero (Left shift/Decrement) could be added here
        END IF;
    END PROCESS;

END structural;