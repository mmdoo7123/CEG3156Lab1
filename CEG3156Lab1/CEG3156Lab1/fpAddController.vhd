LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fpAddController IS
    PORT(
        i_clock, i_resetBar : IN  STD_LOGIC;
        i_start             : IN  STD_LOGIC;
        i_zeroC             : IN  STD_LOGIC; 
        o_loadInputs        : OUT STD_LOGIC;
        o_loadCounter       : OUT STD_LOGIC;
        o_shiftEn           : OUT STD_LOGIC; 
        o_decCounter        : OUT STD_LOGIC; 
        o_stopShift         : OUT STD_LOGIC; 
        o_loadBigALU        : OUT STD_LOGIC
    );
END fpAddController;

ARCHITECTURE structural OF fpAddController IS
    SIGNAL s0, s1, s2, s3 : STD_LOGIC;
    SIGNAL d0, d1, d2, d3 : STD_LOGIC;

    COMPONENT enARdFF_2
        PORT(
            i_resetBar : IN  STD_LOGIC;
            i_d        : IN  STD_LOGIC;
            i_enable   : IN  STD_LOGIC;
            i_clock    : IN  STD_LOGIC;
            o_q, o_qBar: OUT STD_LOGIC);
    END COMPONENT;

BEGIN
    d0 <= NOT i_start;
    d1 <= i_start AND s0;
    
    d2 <= (s1 AND NOT i_zeroC) OR (s2 AND NOT i_zeroC);
    
    d3 <= (s1 AND i_zeroC) OR (s2 AND i_zeroC);

    state0: enARdFF_2 PORT MAP(i_resetBar, d0, '1', i_clock, s0, OPEN);
    state1: enARdFF_2 PORT MAP(i_resetBar, d1, '1', i_clock, s1, OPEN);
    state2: enARdFF_2 PORT MAP(i_resetBar, d2, '1', i_clock, s2, OPEN);
    state3: enARdFF_2 PORT MAP(i_resetBar, d3, '1', i_clock, s3, OPEN);

    o_loadInputs  <= s1;
    o_loadCounter <= s1;
    
    o_shiftEn     <= s2; 
    o_decCounter  <= s2; 
    
    o_stopShift   <= s3 OR s0; 

    o_loadBigALU  <= s3;

END structural;