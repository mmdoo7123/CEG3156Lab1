LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY roundingHardware IS
    PORT(
        i_normalizedSig : IN  STD_LOGIC_VECTOR(8 downto 0); -- 9-bit significand from normalization
        i_normalizedExp : IN  STD_LOGIC_VECTOR(7 downto 0); -- Exponent from normalization
        i_roundControl  : IN  STD_LOGIC;                    -- Control signal to trigger rounding
        o_finalMantissa : OUT STD_LOGIC_VECTOR(7 downto 0); -- Final 8-bit stored mantissa
        o_finalExponent : OUT STD_LOGIC_VECTOR(7 downto 0); -- Final adjusted exponent
        o_overflow      : OUT STD_LOGIC                     -- Final overflow exception flag
    );
END roundingHardware;

ARCHITECTURE structural OF roundingHardware IS
    SIGNAL w_roundOp        : STD_LOGIC_VECTOR(8 downto 0);
    SIGNAL w_roundedSig     : STD_LOGIC_VECTOR(8 downto 0);
    SIGNAL w_sigCarry       : STD_LOGIC;
    SIGNAL w_expIncrement   : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL w_finalExp       : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL gnd              : STD_LOGIC := '0';

    -- 9-bit adder for significand rounding
    COMPONENT nineBitAdder
    PORT(i_Ai, i_Bi : IN STD_LOGIC_VECTOR(8 downto 0); i_CarryIn : IN STD_LOGIC; o_Sum : OUT STD_LOGIC_VECTOR(8 downto 0); o_CarryOut : OUT STD_LOGIC);
    END COMPONENT;

    -- 8-bit adder for final exponent increment
    COMPONENT eightBitAdder
    PORT(i_Ai, i_Bi : IN STD_LOGIC_VECTOR(7 downto 0); i_CarryIn : IN STD_LOGIC; o_Sum : OUT STD_LOGIC_VECTOR(7 downto 0); o_CarryOut : OUT STD_LOGIC);
    END COMPONENT;

BEGIN
    -- 1. Round the Significand
    -- Add '1' to the LSB if rounding is enabled
    w_roundOp <= "00000000" & i_roundControl;

    round_sig: nineBitAdder
        PORT MAP (
            i_Ai       => i_normalizedSig,
            i_Bi       => w_roundOp,
            i_CarryIn  => gnd,
            o_Sum      => w_roundedSig,
            o_CarryOut => w_sigCarry 
        );

    -
    w_expIncrement <= "0000000" & w_sigCarry;

    final_exp_adj: eightBitAdder
        PORT MAP (
            i_Ai       => i_normalizedExp,
            i_Bi       => w_expIncrement,
            i_CarryIn  => gnd,
            o_Sum      => w_finalExp,
            o_CarryOut => o_overflow 
        );

    
    o_finalMantissa <= w_roundedSig(7 downto 0);
    o_finalExponent <= w_finalExp;

END structural;