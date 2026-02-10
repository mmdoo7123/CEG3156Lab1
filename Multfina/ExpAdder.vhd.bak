LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ExpAdder IS
    PORT(
        i_SigA, i_SigB : IN  STD_LOGIC_VECTOR(8 downto 0); -- 9-bit significands (1.fraction)
        o_Sum          : OUT STD_LOGIC_VECTOR(8 downto 0);
        o_CarryExp     : OUT STD_LOGIC                     -- Overflow bit for normalization step
    );
END ExpAdder;

ARCHITECTURE structural OF ExpAdder IS
    SIGNAL gnd : STD_LOGIC := '0';

    COMPONENT genericAdder
        GENERIC (
            n : integer := 8
        );
        PORT(
            i_Ai, i_Bi      : IN    STD_LOGIC_VECTOR(n-1 downto 0);
            i_CarryIn       : IN    STD_LOGIC;
            o_Sum           : OUT   STD_LOGIC_VECTOR(n-1 downto 0);
            o_CarryExp      : OUT   STD_LOGIC
        );
    END COMPONENT;

BEGIN

    
    sig_adder: genericAdder
        GENERIC MAP (
            n => 9
        )
        PORT MAP (
            i_Ai       => i_SigA,
            i_Bi       => i_SigB,
            i_CarryIn  => gnd,
            o_Sum      => o_Sum,
            o_CarryOut => o_CarryExp
        );

END structural;