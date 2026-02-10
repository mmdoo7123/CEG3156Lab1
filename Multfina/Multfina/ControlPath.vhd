LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ControlPath IS
    PORT(
        i_clock           : IN  STD_LOGIC;
        i_resetBar        : IN  STD_LOGIC;
        i_normalization   : IN  STD_LOGIC; -- "Normalization needed" from S2
        i_overflow_under  : IN  STD_LOGIC; -- "Overflow or Underflow" from S2
        -- Output Control Signals (mapped to the states)
        o_S0, o_S1, o_S2  : OUT STD_LOGIC;
        o_S3, o_S4, o_S5  : OUT STD_LOGIC;
        o_S6              : OUT STD_LOGIC;
        o_bias              : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)

	 );
END ControlPath;

ARCHITECTURE structural OF ControlPath IS

    -- Component for standard Reset-to-0 Flip-Flops
    COMPONENT enARdFF_2 IS
        PORT(
            i_resetBar : IN  STD_LOGIC;
            i_d        : IN  STD_LOGIC;
            i_enable   : IN  STD_LOGIC;
            i_clock    : IN  STD_LOGIC;
            o_q, o_qBar: OUT STD_LOGIC
        );
    END COMPONENT;

    -- Component for the Start State (Reset-to-1)
    COMPONENT enASdFF_2 IS
        PORT(
            i_resetBar : IN  STD_LOGIC;
            i_d        : IN  STD_LOGIC;
            i_enable   : IN  STD_LOGIC;
            i_clock    : IN  STD_LOGIC;
            o_q, o_qBar: OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL s_S0, s_S1, s_S2, s_S3, s_S4, s_S5, s_S6 : STD_LOGIC;
    SIGNAL d_S0, d_S1, d_S2, d_S3, d_S4, d_S5, d_S6 : STD_LOGIC;
    SIGNAL vcc : STD_LOGIC := '1';
    SIGNAL gnd : STD_LOGIC := '0';

BEGIN
    -- S0 starts at '1' and receives '0' to turn off after the first pulse
    d_S0 <= gnd; 
    -- S1 follows S0
    d_S1 <= s_S0;
    -- S2 receives the hand-off from S1 or the loop-back from S3
    d_S2 <= s_S1;
    -- S3 (Normalize): Active only if S2 is active and flag is high
    d_S3 <= s_S2 AND i_normalization AND NOT(i_overflow_under);
    -- S4 (Exception): Terminates sequence if error exists
    d_S4 <= s_S2 AND i_overflow_under;
    -- S5 (Round): Only starts if in S2, normalization is DONE, and no exceptions
	 d_S5 <= (s_S2 AND NOT(i_normalization) AND NOT(i_overflow_under)) OR s_S3;
    -- S6 (Sign): Strictly follows S5 completion
    d_S6 <= s_S5;
    -- FF0 uses the SET component so it starts at '1'
    FF0: enASdFF_2 PORT MAP (i_resetBar, d_S0, vcc, i_clock, s_S0, OPEN);
    FF1: enARdFF_2 PORT MAP (i_resetBar, d_S1, vcc, i_clock, s_S1, OPEN);
    FF2: enARdFF_2 PORT MAP (i_resetBar, d_S2, vcc, i_clock, s_S2, OPEN);
    FF3: enARdFF_2 PORT MAP (i_resetBar, d_S3, vcc, i_clock, s_S3, OPEN);
    FF4: enARdFF_2 PORT MAP (i_resetBar, d_S4, vcc, i_clock, s_S4, OPEN);
    FF5: enARdFF_2 PORT MAP (i_resetBar, d_S5, vcc, i_clock, s_S5, OPEN);
    FF6: enARdFF_2 PORT MAP (i_resetBar, d_S6, vcc, i_clock, s_S6, OPEN);
    -- Drive Outputs
    o_S0 <= s_S0; o_S1 <= s_S1; o_S2 <= s_S2;
    o_S3 <= s_S3; o_S4 <= s_S4; o_S5 <= s_S5;
    o_S6 <= s_S6;
    o_bias <= "0111111";
END structural;