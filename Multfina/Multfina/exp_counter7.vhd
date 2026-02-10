LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- 7-bit Loadable Counter/Register for final biased exponent (REz)
ENTITY exp_counter7 IS
    PORT(
        clk     : IN  STD_LOGIC;
        resetBar   : IN  STD_LOGIC;

        i_load7 : IN  STD_LOGIC;                        -- load enable
        i_inc1  : IN  STD_LOGIC;                        -- increment enable

        i_data  : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);     -- value from exponent adder
		  o_done : OUT STD_LOGIC;
        o_REz   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)      -- final biased exponent
    );
END exp_counter7;

ARCHITECTURE structural OF exp_counter7 IS

    -- Your provided structural ripple-carry adder
    COMPONENT genericAdder IS
        GENERIC ( n : INTEGER := 8 );
        PORT(
            i_Ai       : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            i_Bi       : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            i_CarryIn  : IN  STD_LOGIC;
            o_Sum      : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            o_CarryOut : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL reg_q    : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL inc_sum  : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL inc_cout : STD_LOGIC;
	 SIGNAL doneOP   : STD_LOGIC;

BEGIN

    -------------------------------------------------------------------------
    -- Incrementer (structural): reg_q + 1
    -- Achieved by adding reg_q + 0...0 with CarryIn = '1'
    -------------------------------------------------------------------------
    u_inc : genericAdder
        GENERIC MAP ( n => 7 )
        PORT MAP (
            i_Ai       => reg_q,
            i_Bi       => (OTHERS => '0'),
            i_CarryIn  => '1',
            o_Sum      => inc_sum,
            o_CarryOut => doneOP
        );

    -------------------------------------------------------------------------
    -- Register storage (sync reset)
    -- Priority: reset > load > inc > hold
    -------------------------------------------------------------------------
    p_reg : PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF resetBar = '0' THEN
                reg_q <= (OTHERS => '0');
					 o_done <= '0';

            ELSIF i_load7 = '1' THEN
                reg_q <= i_data; 
					 o_done <= doneOP;

            ELSIF i_inc1 = '1' THEN
                reg_q <= inc_sum;
					 o_done <= doneOP;
            ELSE
					 o_done <= '0';
            END IF;
        END IF;
    END PROCESS;

    o_REz <= reg_q;

END structural;
