LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY shiftReg9_struct IS
    PORT (
        i_clock    : IN  STD_LOGIC;
        i_resetBar : IN  STD_LOGIC;
        i_load     : IN  STD_LOGIC;
        i_shift    : IN  STD_LOGIC;
        i_data     : IN  STD_LOGIC_VECTOR(8 DOWNTO 0); -- 9-bit significand
        o_q        : OUT STD_LOGIC_VECTOR(8 DOWNTO 0); -- Aligned output
        o_done     : OUT STD_LOGIC                     
    );
END shiftReg9_struct;

ARCHITECTURE structural OF shiftReg9_struct IS
    COMPONENT enARdFF_2 IS
        PORT (i_resetBar, i_d, i_enable, i_clock : IN STD_LOGIC; o_q, o_qBar : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT genericMux2to1 IS
        GENERIC ( n : INTEGER := 9 );
        PORT (i_A, i_B : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0); i_Sel : IN STD_LOGIC; o_Out : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
    END COMPONENT;

    SIGNAL q_int       : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL d_int       : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL shifted_in  : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL en_int      : STD_LOGIC;
    SIGNAL is_shifting : STD_LOGIC;

BEGIN
    shifted_in <= '0' & q_int(8 DOWNTO 1);

    u_mux_data : genericMux2to1
        GENERIC MAP ( n => 9 )
        PORT MAP(
            i_A   => shifted_in, -- Shift path (Select = 0)
            i_B   => i_data,     -- Load path (Select = 1)
            i_Sel => i_load,     -- Control signal
            o_Out => d_int
        );

    en_int <= i_load OR i_shift; -- Enabled during load or shift cycles

    gen_ff: FOR i IN 0 TO 8 GENERATE
        u_ff : enARdFF_2
            PORT MAP(
                i_resetBar => i_resetBar,
                i_d        => d_int(i),
                i_enable   => en_int,
                i_clock    => i_clock,
                o_q        => q_int(i)
            );
    END GENERATE;

 
    o_done <= NOT(i_load OR i_shift);
    o_q    <= q_int;

END structural;