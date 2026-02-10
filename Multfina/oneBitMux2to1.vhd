LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- 1-bit 2-to-1 multiplexer
-- i_Sel = 0 -> select i_A
-- i_Sel = 1 -> select i_B
ENTITY oneBitMux2to1 IS
    PORT(
        i_A   : IN  STD_LOGIC;
        i_B   : IN  STD_LOGIC;
        i_Sel : IN  STD_LOGIC;
        o_Out : OUT STD_LOGIC
    );
END oneBitMux2to1;

ARCHITECTURE structural OF oneBitMux2to1 IS
BEGIN

    -- Pure combinational mux logic (structural RTL style)
    o_Out <= (i_A AND NOT i_Sel) OR
             (i_B AND i_Sel);

END structural;
