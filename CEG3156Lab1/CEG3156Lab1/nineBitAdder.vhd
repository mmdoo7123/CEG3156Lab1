LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nineBitAdder IS
    PORT(
        i_Ai, i_Bi      : IN    STD_LOGIC_VECTOR(8 downto 0);
        i_CarryIn       : IN    STD_LOGIC;
        o_Sum           : OUT   STD_LOGIC_VECTOR(8 downto 0);
        o_CarryOut      : OUT   STD_LOGIC
    );
END nineBitAdder;

ARCHITECTURE structural OF nineBitAdder IS
    SIGNAL int_Sum      : STD_LOGIC_VECTOR(8 downto 0);
    SIGNAL int_CarryOut : STD_LOGIC_VECTOR(8 downto 0);

    -- Using the atomic 1-bit adder component required by lab specs [cite: 122]
    COMPONENT oneBitAdder
    PORT(
        i_CarryIn         : IN    STD_LOGIC;
        i_Ai, i_Bi        : IN    STD_LOGIC;
        o_Sum, o_CarryOut : OUT   STD_LOGIC);
    END COMPONENT;

BEGIN

    -- Bit 0 (LSB): Takes the initial CarryIn
    add0: oneBitAdder
        PORT MAP (
            i_CarryIn  => i_CarryIn, 
            i_Ai       => i_Ai(0),
            i_Bi       => i_Bi(0),
            o_Sum      => int_Sum(0),
            o_CarryOut => int_CarryOut(0)
        );

    -- Bits 1 through 8: Structural loop to ripple the carry [cite: 120]
    gen_adder: FOR i IN 1 TO 8 GENERATE
        add_inst: oneBitAdder
            PORT MAP (
                i_CarryIn  => int_CarryOut(i-1), 
                i_Ai       => i_Ai(i),
                i_Bi       => i_Bi(i),
                o_Sum      => int_Sum(i),
                o_CarryOut => int_CarryOut(i)
            );
    END GENERATE;

    -- Output Drivers
    o_Sum      <= int_Sum;
    o_CarryOut <= int_CarryOut(8); -- Final carry-out for normalization check

END structural;