LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY xor_sign IS
PORT(
    i_signA    : IN  STD_LOGIC;
    i_signB    : IN  STD_LOGIC;
    i_enable   : IN  STD_LOGIC;
    o_signProd : OUT STD_LOGIC
);
END xor_sign;

ARCHITECTURE rtl OF xor_sign IS
BEGIN

    -- Enabled XOR
    o_signProd <= (i_signA XOR i_signB) AND i_enable;

END rtl;
