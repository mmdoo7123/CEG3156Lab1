LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY normalizationController IS
    PORT(
        -- Inputs from Big ALU
        i_BigALUSum   : IN  STD_LOGIC_VECTOR(8 downto 0); 
        i_BigALUCOut  : IN  STD_LOGIC;                    
        
        o_shiftRight  : OUT STD_LOGIC; 
        o_incExp      : OUT STD_LOGIC; 
        o_isOverflow  : OUT STD_LOGIC  
    );
END normalizationController;

ARCHITECTURE structural OF normalizationController IS
    SIGNAL w_isZero : STD_LOGIC;
BEGIN
    
    o_shiftRight <= i_BigALUCOut;
    o_incExp     <= i_BigALUCOut;



    o_isOverflow <= i_BigALUCOut; 

END structural;