
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBitALU IS
	PORT(
		i_Ai, i_Bi		: IN	STD_LOGIC_VECTOR(7 downto 0);
		o_CarryOut		: OUT	STD_LOGIC;
		o_Sum			: OUT	STD_LOGIC_VECTOR(7 downto 0));
END eightBitALU;

ARCHITECTURE rtl OF eightBitALU IS
	SIGNAL int_Sum, int_CarryOut : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL gnd : STD_LOGIC;
	SIGNAl intB : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
		-- Structural 2's complement subtraction: A + (NOT B) + 1
	intB <= NOT(i_Bi); -- Concurrent bitwise inversion

	add0: oneBitAdder
		 PORT MAP (
			  i_CarryIn => '1',      -- This '1' provides the "+1" for 2's complement
			  i_Ai      => i_Ai(0),
			  i_Bi      => intB(0),
			  o_Sum     => int_Sum(0),
			  o_CarryOut=> int_CarryOut(0)
		 );

	COMPONENT oneBitAdder
	PORT(
		i_CarryIn		: IN	STD_LOGIC;
		i_Ai, intB		: IN	STD_LOGIC;
		o_Sum, o_CarryOut	: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

	-- Concurrent Signal Assignment
	gnd <= '0';

add7: oneBitAdder
	PORT MAP (i_CarryIn => gnd, 
			  i_Ai => i_Ai(7),
			  i_Bi => intB(7),
			  o_Sum => int_Sum(7),
			  o_CarryOut => int_CarryOut(7));
			  
add6: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(7), 
			  i_Ai => i_Ai(6),
			  i_Bi => intB(6),
			  o_Sum => int_Sum(6),
			  o_CarryOut => int_CarryOut(6));
			  
add5: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(6), 
			  i_Ai => i_Ai(5),
			  i_Bi => intB(5),
			  o_Sum => int_Sum(5),
			  o_CarryOut => int_CarryOut(5));
add4: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(5), 
			  i_Ai => i_Ai(4),
			  i_Bi => intB(4),
			  o_Sum => int_Sum(4),
			  o_CarryOut => int_CarryOut(4));
			  
add3: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(4), 
			  i_Ai => i_Ai(3),
			  i_Bi => intB(3),
			  o_Sum => int_Sum(3),
			  o_CarryOut => int_CarryOut(3));
			  
add2: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(3), 
			  i_Ai => i_Ai(2),
			  i_Bi => intB(2),
			  o_Sum => int_Sum(2),
			  o_CarryOut => int_CarryOut(2));
			  
add1: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(2), 
			  i_Ai => i_Ai(1),
			  i_Bi => intB(1),
			  o_Sum => int_Sum(1),
			  o_CarryOut => int_CarryOut(1));
			  
add0: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(1), 
			  i_Ai => i_Ai(0),
			  i_Bi => intB(0),
			  o_Sum => int_Sum(0),
			  o_CarryOut => int_CarryOut(0));

	-- Output Driver
	o_Sum <= int_Sum;
	o_CarryOut <= int_CarryOut(0);

END rtl;
