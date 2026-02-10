LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBitRightShift IS
	PORT(
		i_resetBar, i_load, i_shiftR	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(17 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));
END eightBitRightShift;

ARCHITECTURE rtl OF eightBitRightShift IS
	SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(17 downto 0);

	COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN
G1: FOR i IN 0 TO 16 GENERATE
        dFF_i: enARdFF_2
            PORT MAP (
                i_resetBar => i_resetBar,
                i_d        => (i_Value(i) and i_load) or (int_Value(i+1) and i_shiftR),
                i_enable   => i_load or i_shiftR,
                i_clock    => i_clock,
                o_q        => int_Value(i),
                o_qBar     => int_notValue(i)
            );
    END GENERATE;
MSB: enARdFF_2
        PORT MAP (
            i_resetBar => i_resetBar,
            i_d        => (i_Value(17) and i_load) or ('0' and i_shiftR),
            i_enable   => i_load or i_shiftR,
            i_clock    => i_clock,
            o_q        => int_Value(17),
            o_qBar     => int_notValue(17)
        );
			  
	-- Output Driver
		o_Value <= int_Value(17 DOWNTO 10);

END rtl;
