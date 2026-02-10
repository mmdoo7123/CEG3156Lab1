LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBitAdder IS
    PORT(
        i_Ai, i_Bi      : IN    STD_LOGIC_VECTOR(7 downto 0);
        i_CarryIn       : IN    STD_LOGIC; 
        o_CarryOut      : OUT   STD_LOGIC;
        o_Sum           : OUT   STD_LOGIC_VECTOR(7 downto 0));
END eightBitAdder;

ARCHITECTURE structural OF eightBitAdder IS
    SIGNAL int_Sum      : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL int_CarryOut : STD_LOGIC_VECTOR(7 downto 0);

    COMPONENT oneBitAdder
    PORT(
        i_CarryIn       : IN    STD_LOGIC;
        i_Ai, i_Bi      : IN    STD_LOGIC;
        o_Sum, o_CarryOut : OUT STD_LOGIC);
    END COMPONENT;

BEGIN

    -- Bit 0 (LSB)
    add0: oneBitAdder
        PORT MAP (
            i_CarryIn  => i_CarryIn, 
            i_Ai       => i_Ai(0),
            i_Bi       => i_Bi(0),
            o_Sum      => int_Sum(0),
            o_CarryOut => int_CarryOut(0)
        );

    gen_adder: FOR i IN 1 TO 7 GENERATE
        add_inst: oneBitAdder
            PORT MAP (
                i_CarryIn  => int_CarryOut(i-1), -- Ripple from previous bit
                i_Ai       => i_Ai(i),
                i_Bi       => i_Bi(i),
                o_Sum      => int_Sum(i),
                o_CarryOut => int_CarryOut(i)
            );
    END GENERATE;

    o_Sum <= int_Sum;
    o_CarryOut <= int_CarryOut(7);

END structural;