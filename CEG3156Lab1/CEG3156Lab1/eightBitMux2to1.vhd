LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY oneBitMux2to1 IS
    PORT(
        i_A, i_B : IN  STD_LOGIC;
        i_Sel    : IN  STD_LOGIC;
        o_Out    : OUT STD_LOGIC);
END oneBitMux2to1;

ARCHITECTURE structural OF oneBitMux2to1 IS
BEGIN
    o_Out <= (i_A AND NOT(i_Sel)) OR (i_B AND i_Sel);
END structural;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBitMux2to1 IS
    PORT(
        i_A, i_B : IN  STD_LOGIC_VECTOR(7 downto 0);
        i_Sel    : IN  STD_LOGIC; -- Driven by Comparator GT or LT signal 
        o_Out    : OUT STD_LOGIC_VECTOR(7 downto 0)
    );
END eightBitMux2to1;

ARCHITECTURE structural OF eightBitMux2to1 IS
    COMPONENT oneBitMux2to1
    PORT(
        i_A, i_B : IN  STD_LOGIC;
        i_Sel    : IN  STD_LOGIC;
        o_Out    : OUT STD_LOGIC);
    END COMPONENT;

BEGIN
    -- Structural RTL: Generating 8 instances for the 8-bit bus [cite: 120]
    gen_mux: FOR i IN 7 DOWNTO 0 GENERATE
        mux_inst: oneBitMux2to1
            PORT MAP (
                i_A   => i_A(i),
                i_B   => i_B(i),
                i_Sel => i_Sel,
                o_Out => o_Out(i)
            );
    END GENERATE;
END structural;