LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY singleShiftReg9 IS
  PORT (
    i_clock    : IN  STD_LOGIC;
    i_resetBar : IN  STD_LOGIC;
    i_load     : IN  STD_LOGIC;
    i_shift    : IN  STD_LOGIC;
    i_data     : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);  -- 9-bit significand
    o_q        : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);  -- Aligned output
    o_done     : OUT STD_LOGIC                      -- Done signal
  );
END singleShiftReg9;

ARCHITECTURE structural OF singleShiftReg9 IS

  -- Components
  COMPONENT enARdFF_2 IS
    PORT (
      i_resetBar, i_d, i_enable, i_clock : IN  STD_LOGIC;
      o_q, o_qBar                         : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT genericMux2to1 IS
    GENERIC ( n : INTEGER := 9 );
    PORT (
      i_A, i_B : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      i_Sel    : IN  STD_LOGIC;
      o_Out    : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
  END COMPONENT;

  -- Internal Signals
  SIGNAL q_int      : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL d_int      : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL shifted_in : STD_LOGIC_VECTOR(8 DOWNTO 0);

  SIGNAL en_int     : STD_LOGIC;
  SIGNAL sel_int    : STD_LOGIC;

  -- FSM state
  SIGNAL s_state, s_next : STD_LOGIC_VECTOR(1 DOWNTO 0);
  -- "00" IDLE, "01" LOAD, "10" SHIFT, "11" DONE

BEGIN

  shifted_in <= '0' & q_int(8 DOWNTO 1);

  u_mux_data : genericMux2to1
    GENERIC MAP ( n => 9 )
    PORT MAP (
      i_A   => shifted_in,  -- sel=0 -> shift path
      i_B   => i_data,      -- sel=1 -> load path
      i_Sel => sel_int,
      o_Out => d_int
    );

  PROCESS(i_clock, i_resetBar)
  BEGIN
    IF (i_resetBar = '0') THEN
      s_state <= "00"; -- IDLE
    ELSIF rising_edge(i_clock) THEN
      s_state <= s_next;
    END IF;
  END PROCESS;

  PROCESS(s_state, i_load, i_shift)
  BEGIN
    en_int  <= '0';
    sel_int <= '0';  
    o_done  <= '0';
    s_next  <= s_state;

    CASE s_state IS

      WHEN "00" =>  -- IDLE
        o_done <= '1';
        IF (i_load = '1') THEN
          s_next <= "01";  
        ELSIF (i_shift = '1') THEN
          s_next <= "10";  
        ELSE
          s_next <= "00";
        END IF;

      WHEN "01" =>  -- LOAD (one cycle)
        en_int  <= '1';
        sel_int <= '1';    
        s_next  <= "11";  

      WHEN "10" =>  -- SHIFT (one cycle)
        en_int  <= '1';
        sel_int <= '0';   
        s_next  <= "11";   

      WHEN "11" =>  -- DONE (no shifting and no loading)
        o_done <= '1';
        en_int <= '0';    
        IF (i_load = '1') THEN
        ELSE
          s_next <= "11";
        END IF;

      WHEN OTHERS =>
        s_next <= "00";

    END CASE;
  END PROCESS;

  gen_ff : FOR i IN 0 TO 8 GENERATE
    u_ff : enARdFF_2
      PORT MAP (
        i_resetBar => i_resetBar,
        i_d        => d_int(i),
        i_enable   => en_int,
        i_clock    => i_clock,
        o_q        => q_int(i),
        o_qBar     => OPEN
      );
  END GENERATE;

  o_q <= q_int;

END structural;
