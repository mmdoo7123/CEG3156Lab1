LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY SignificandReg IS
    PORT(
        i_clock    : IN  STD_LOGIC;
        i_resetBar : IN  STD_LOGIC;
        i_load     : IN  STD_LOGIC;
        i_shift    : IN  STD_LOGIC; -- New Shift Input
        i_clear    : IN  STD_LOGIC; -- New Clear Input
        i_data     : IN  STD_LOGIC_VECTOR(7 downto 0);
        o_q        : OUT STD_LOGIC_VECTOR(8 downto 0)
    );
END SignificandReg;

ARCHITECTURE structural OF SignificandReg IS
    COMPONENT enARdFF_2
        PORT(
            i_resetBar : IN  STD_LOGIC;
            i_d        : IN  STD_LOGIC;
            i_enable   : IN  STD_LOGIC;
            i_clock    : IN  STD_LOGIC;
            o_q, o_qBar : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL w_d       : STD_LOGIC_VECTOR(8 downto 0);
    SIGNAL w_q       : STD_LOGIC_VECTOR(8 downto 0);
    SIGNAL w_enable  : STD_LOGIC;
    SIGNAL w_shifted : STD_LOGIC_VECTOR(8 downto 0);
    SIGNAL w_loaded  : STD_LOGIC_VECTOR(8 downto 0);

BEGIN
    -- 1. Define the 'Load' value (Concatenating '1' as per your original code)
    w_loaded <= '1' & i_data;

    -- 2. Define the 'Shift Right' value (Logical shift right: MSB becomes 0)
    w_shifted <= '0' & w_q(8 downto 1);

    -- 3. Control Logic (Priority: Clear > Load > Shift)
    -- This defines what the "next" state should be for each bit
    PROCESS(i_clear, i_load, i_shift, w_loaded, w_shifted, w_q)
    BEGIN
        IF (i_clear = '1') THEN
            w_d <= (OTHERS => '0');
        ELSIF (i_load = '1') THEN
            w_d <= w_loaded;
        ELSIF (i_shift = '1') THEN
            w_d <= w_shifted;
        ELSE
            w_d <= w_q; -- Hold
        END IF;
    END PROCESS;

    -- 4. Global Enable for the Register
    w_enable <= i_load OR i_shift OR i_clear;

    -- 5. Structural instantiation of Flip-Flops
    gen_reg: FOR i IN 8 DOWNTO 0 GENERATE
        bit_inst: enARdFF_2
        PORT MAP (
            i_resetBar => i_resetBar,
            i_clock    => i_clock,
            i_enable   => w_enable,
            i_d        => w_d(i),
            o_q        => w_q(i),
            o_qBar     => OPEN -- Using OPEN is cleaner than a dummy signal
        );
    END GENERATE;

    o_q <= w_q;

END structural;