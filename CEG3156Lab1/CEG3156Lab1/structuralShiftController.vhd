LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY structuralShiftController IS
    PORT(
        i_clock     : IN  STD_LOGIC;
        i_resetBar  : IN  STD_LOGIC;
        
        -- Inputs from Small ALU
        i_AGtB      : IN  STD_LOGIC;
        i_ALtB      : IN  STD_LOGIC;
        i_ExpDiff   : IN  STD_LOGIC_VECTOR(6 downto 0);
        
        -- Datapath Selects
        o_SelShift  : OUT STD_LOGIC;
        o_SelDirect : OUT STD_LOGIC;
        o_ShiftAmt  : OUT STD_LOGIC_VECTOR(6 downto 0);
        
        -- Control Signals for shiftReg9_struct
        o_load      : OUT STD_LOGIC;
        o_shift     : OUT STD_LOGIC;
        o_done      : OUT STD_LOGIC -- Signals next stage (Big ALU) to start
    );
END structuralShiftController;

ARCHITECTURE structural OF structuralShiftController IS
    COMPONENT genericAdder IS
        GENERIC (n : integer := 7);
        PORT (i_Ai, i_Bi : IN STD_LOGIC_VECTOR(n-1 downto 0); i_CarryIn : IN STD_LOGIC; o_Sum : OUT STD_LOGIC_VECTOR(n-1 downto 0));
    END COMPONENT;

    COMPONENT genericMux2to1 IS
        GENERIC (n : integer := 7);
        PORT (i_A, i_B : IN STD_LOGIC_VECTOR(n-1 downto 0); i_Sel : IN STD_LOGIC; o_Out : OUT STD_LOGIC_VECTOR(n-1 downto 0));
    END COMPONENT;

    SIGNAL w_invDiff, w_absDiff, w_shiftAmt : STD_LOGIC_VECTOR(6 downto 0);
    SIGNAL w_vcc : STD_LOGIC := '1';
    
    SIGNAL s_count_reg, s_count_next : UNSIGNED(6 downto 0);
	 SIGNAL s_state, s_next_state : STD_LOGIC_VECTOR(1 downto 0);
	-- "00" = IDLE/LOAD
	-- "01" = SHIFTING
	-- "10" = DONE

BEGIN
    o_SelShift  <= i_AGtB; 
    o_SelDirect <= NOT i_AGtB;

    w_invDiff <= NOT(i_ExpDiff);
    abs_calc: genericAdder GENERIC MAP (n => 7) PORT MAP(i_Ai => w_invDiff, i_Bi => "0000000", i_CarryIn => w_vcc, o_Sum => w_absDiff);
    
    shift_amt_mux: genericMux2to1 GENERIC MAP (n => 7) PORT MAP(i_A => w_absDiff, i_B => i_ExpDiff, i_Sel => i_AGtB, o_Out => w_shiftAmt);
    o_ShiftAmt <= w_shiftAmt;

    
    PROCESS(i_clock, i_resetBar)
    BEGIN
        IF (i_resetBar = '0') THEN
            s_count_reg <= (others => '0');
				s_state <= "00";
        ELSIF (rising_edge(i_clock)) THEN
            s_count_reg <= s_count_next;
            s_state <= s_next_state;
        END IF;
    END PROCESS;

    PROCESS(s_state, s_count_reg, w_shiftAmt)
    BEGIN
        o_load  <= '0';
        o_shift <= '0';
        o_done  <= '0';
        s_count_next <= s_count_reg;
        s_next_state <= s_state;

		CASE s_state IS

		  WHEN "00" =>  -- IDLE / LOAD
			 o_load <= '1';
			 s_count_next <= UNSIGNED(w_shiftAmt);

			 IF (UNSIGNED(w_shiftAmt) /= 0) THEN
				s_next_state <= "01";         
			 ELSE
				s_next_state <= "10";        
			 END IF;

		  WHEN "01" =>  -- SHIFTING
			 IF (s_count_reg > 0) THEN
				o_shift <= '1';
				s_count_next <= s_count_reg - 1;

				IF (s_count_reg = 1) THEN
				  s_next_state <= "10";       
				ELSE
				  s_next_state <= "01";       
				END IF;

			 ELSE
				s_next_state <= "10";        
			 END IF;

		  WHEN "10" =>  
			 o_done <= '1';
			 s_next_state <= "10";           

		  WHEN OTHERS =>
			 s_next_state <= "00";

		END CASE;

    END PROCESS;

END structural;