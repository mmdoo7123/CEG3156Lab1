----------------------------------------------------------------------------------
-- Overflow and Underflow Detection Unit (Simplified)
-- Designed for 16-bit Floating-Point Multiplier
-- 
-- This unit ONLY detects overflow and underflow conditions.
-- It does NOT perform any exponent adjustment or normalization.
-- All exponent adjustments should be done in the datapath before this unit.
--
-- Format: Sign(1) | Exponent(7) | Mantissa(8) = 16 bits
-- Exponent: Excess-63 representation
-- Valid exponent range: 1 to 126 (stored values)
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY overflow_underflow_unit IS
    PORT(
        -- Clock and Reset
        i_clock           : IN  STD_LOGIC;
        i_resetBar        : IN  STD_LOGIC;  -- Active low reset
        
        -- Input: Final exponent value (after all adjustments in datapath)
        i_exponent        : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);  -- 8-bit for detection
        
        -- Control
        i_enable          : IN  STD_LOGIC;  -- Enable checking
        
        -- Outputs
        o_overflow        : OUT STD_LOGIC;  -- Overflow detected
        o_underflow       : OUT STD_LOGIC;  -- Underflow detected
        o_overflow_under  : OUT STD_LOGIC   -- Combined flag (overflow OR underflow)
    );
END overflow_underflow_unit;

ARCHITECTURE structural OF overflow_underflow_unit IS
    
    -- Internal signals
    SIGNAL overflow_detected  : STD_LOGIC;
    SIGNAL underflow_detected : STD_LOGIC;
    SIGNAL combined_flag      : STD_LOGIC;
    
    -- Exponent boundary constants (for 7-bit exponent, excess-63)
    CONSTANT MAX_EXPONENT : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111110";  -- 126 decimal
    CONSTANT MIN_EXPONENT : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000001";  -- 1 decimal
    
BEGIN

    ----------------------------------------------------------------------------------
    -- OVERFLOW DETECTION
    -- Overflow occurs when the exponent exceeds the maximum value (126)
    ----------------------------------------------------------------------------------
    overflow_check: PROCESS(i_exponent)
    BEGIN
        IF i_exponent > MAX_EXPONENT THEN
            overflow_detected <= '1';
        ELSE
            overflow_detected <= '0';
        END IF;
    END PROCESS;

    ----------------------------------------------------------------------------------
    -- UNDERFLOW DETECTION  
    -- Underflow occurs when the exponent is below the minimum value (1)
    ----------------------------------------------------------------------------------
    underflow_check: PROCESS(i_exponent)
    BEGIN
        IF i_exponent < MIN_EXPONENT THEN
            underflow_detected <= '1';
        ELSE
            underflow_detected <= '0';
        END IF;
    END PROCESS;

    ----------------------------------------------------------------------------------
    -- COMBINED FLAG GENERATION
    -- Single exception flag for FSM
    ----------------------------------------------------------------------------------
    combined_flag <= overflow_detected OR underflow_detected;

    ----------------------------------------------------------------------------------
    -- OUTPUT REGISTER
    -- Synchronous output with active-low reset
    -- Outputs are only updated when enabled by the FSM
    ----------------------------------------------------------------------------------
    output_register: PROCESS(i_clock, i_resetBar)
    BEGIN
        IF i_resetBar = '0' THEN
            -- Active low reset
            o_overflow       <= '0';
            o_underflow      <= '0';
            o_overflow_under <= '0';
        ELSIF rising_edge(i_clock) THEN
            IF i_enable = '1' THEN
                -- Update outputs when enabled
                o_overflow       <= overflow_detected;
                o_underflow      <= underflow_detected;
                o_overflow_under <= combined_flag;
            END IF;
        END IF;
    END PROCESS;

END structural;