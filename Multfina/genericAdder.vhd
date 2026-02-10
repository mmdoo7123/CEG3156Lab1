LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY genericAdder IS
    GENERIC (
        n : integer := 8 -- Default width is 8, can be overridden for 7 or 24 bits
    );
    PORT(
        i_Ai, i_Bi      : IN    STD_LOGIC_VECTOR(n-1 downto 0);
        i_CarryIn       : IN    STD_LOGIC;
        o_Sum           : OUT   STD_LOGIC_VECTOR(n-1 downto 0);
        o_CarryOut      : OUT   STD_LOGIC
    );
END genericAdder;

ARCHITECTURE structural OF genericAdder IS
    SIGNAL int_Sum      : STD_LOGIC_VECTOR(n-1 downto 0);
    SIGNAL int_CarryOut : STD_LOGIC_VECTOR(n-1 downto 0);

    -- Component declaration for your provided 1-bit adder
    COMPONENT oneBitAdder
    PORT(
        i_CarryIn         : IN    STD_LOGIC;
        i_Ai, i_Bi        : IN    STD_LOGIC;
        o_Sum, o_CarryOut : OUT   STD_LOGIC);
    END COMPONENT;

BEGIN

    -- Bit 0 (LSB): Takes the initial external CarryIn
    add0: oneBitAdder
        PORT MAP (
            i_CarryIn  => i_CarryIn, 
            i_Ai       => i_Ai(0),
            i_Bi       => i_Bi(0),
            o_Sum      => int_Sum(0),
            o_CarryOut => int_CarryOut(0)
        );

    -- Bits 1 through n-1: Structural loop to ripple the carry
    gen_adder: FOR i IN 1 TO n-1 GENERATE
        add_inst: oneBitAdder
            PORT MAP (
                i_CarryIn  => int_CarryOut(i-1), -- Ripple from previous bit
                i_Ai       => i_Ai(i),
                i_Bi       => i_Bi(i),
                o_Sum      => int_Sum(i),
                o_CarryOut => int_CarryOut(i)
            );
    END GENERATE;

    -- Output Drivers
    o_Sum      <= int_Sum;
    o_CarryOut <= int_CarryOut(n-1); -- Final carry-out for overflow/exception logic

END structural;