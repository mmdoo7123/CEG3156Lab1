LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY normShifter8 IS
    PORT(
        i_clock, i_resetBar : IN  STD_LOGIC;
        i_load              : IN  STD_LOGIC;
        i_Data              : IN  STD_LOGIC_VECTOR(7 downto 0);
        i_ShiftLeft         : IN  STD_LOGIC; 
        i_ShiftRight        : IN  STD_LOGIC; 
        o_Q                 : OUT STD_LOGIC_VECTOR(7 downto 0)
    );
END normShifter8;

ARCHITECTURE structural OF normShifter8 IS
    SIGNAL w_rightS : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL w_muxFinal : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL w_q, w_qBar        : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL w_diffAB, w_diffBA : STD_LOGIC_VECTOR(7 downto 0);

    
    COMPONENT genericMux2to1
        GENERIC (n : integer := 8);
        PORT(i_A, i_B : IN STD_LOGIC_VECTOR(n-1 downto 0); i_Sel : IN STD_LOGIC; o_Out : OUT STD_LOGIC_VECTOR(n-1 downto 0));
    END COMPONENT;

    COMPONENT enARdFF_2
    PORT(
        i_resetBar : IN  STD_LOGIC;
        i_d        : IN  STD_LOGIC;
        i_enable   : IN  STD_LOGIC;
        i_clock    : IN  STD_LOGIC;
        o_q, o_qBar: OUT STD_LOGIC);
    END COMPONENT;

BEGIN
    w_rightS <= '0' & i_Data(7 downto 1);



 

END structural;