LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY genericRegister IS
    GENERIC (
        n : integer := 8 -- Default width is 8 bits
    );
    PORT(
        i_clock    : IN  STD_LOGIC;
        i_resetBar : IN  STD_LOGIC;
        i_load     : IN  STD_LOGIC; -- Enable signal from Control Path
        i_data     : IN  STD_LOGIC_VECTOR(n-1 downto 0);
        o_q        : OUT STD_LOGIC_VECTOR(n-1 downto 0) -- Data currently in register
    );
END genericRegister;

ARCHITECTURE structural OF genericRegister IS
    -- Component for the enabled DFF provided in your class materials
    COMPONENT enARdFF_2
        PORT(
            i_resetBar : IN  STD_LOGIC;
            i_d        : IN  STD_LOGIC;
            i_enable   : IN  STD_LOGIC;
            i_clock    : IN  STD_LOGIC;
            o_q, o_qBar : OUT STD_LOGIC
        );
    END COMPONENT;
    -- Signal to handle the unused qBar outputs from the flip-flops
    SIGNAL w_unusedQbar : STD_LOGIC_VECTOR(n-1 downto 0);
BEGIN
    -- Structural generation of n flip-flops as defined by ASM methodology [cite: 177, 184]
    gen_reg: FOR i IN n-1 DOWNTO 0 GENERATE
        bit_inst: enARdFF_2
            PORT MAP (
                i_resetBar => i_resetBar,
                i_clock    => i_clock,
                i_enable   => i_load,
                i_d        => i_data(i),
                o_q        => o_q(i),
                o_qBar     => w_unusedQbar(i) -- Terminating the unused signal
            );
    END GENERATE;
END structural;