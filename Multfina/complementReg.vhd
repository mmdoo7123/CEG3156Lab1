LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY complementReg IS
    GENERIC (
        n : integer := 8
    );
    PORT(
        i_Clock : IN  STD_LOGIC;
        i_resetBar : IN  STD_LOGIC;
        i_Load  : IN  STD_LOGIC;
        i_D     : IN  STD_LOGIC_VECTOR(n-1 downto 0);

        o_Q     : OUT STD_LOGIC_VECTOR(n-1 downto 0);
        o_Qbar  : OUT STD_LOGIC_VECTOR(n-1 downto 0)
    );
END complementReg;

ARCHITECTURE structural OF complementReg IS

    COMPONENT enARdFF_2
        PORT(
            i_resetBar : IN  STD_LOGIC;
            i_d        : IN  STD_LOGIC;
            i_enable   : IN  STD_LOGIC;
            i_clock    : IN  STD_LOGIC;
            o_q        : OUT STD_LOGIC;
            o_qBar     : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL q_int    : STD_LOGIC_VECTOR(n-1 downto 0);
    SIGNAL qbar_int : STD_LOGIC_VECTOR(n-1 downto 0);

BEGIN

    gen_reg: FOR i IN 0 TO n-1 GENERATE
        ff_i: enARdFF_2
            PORT MAP(
                i_resetBar => i_resetBar,
                i_d        => i_D(i),
                i_enable   => i_Load,
                i_clock    => i_Clock,
                o_q        => q_int(i),
                o_qBar     => qbar_int(i)
            );
    END GENERATE;

    -- Normal output
    o_Q <= q_int;

    -- Complement output (1's complement of stored value)
    o_Qbar <= NOT q_int;

END structural;
