library verilog;
use verilog.vl_types.all;
entity ControlPathAdder is
    port(
        i_clock         : in     vl_logic;
        i_resetBar      : in     vl_logic;
        i_gt9           : in     vl_logic;
        i_gt2           : in     vl_logic;
        i_diff_eq_0     : in     vl_logic;
        i_AGTB          : in     vl_logic;
        o_LoadExp_Mant_Cin: out    vl_logic;
        o_ClearA        : out    vl_logic;
        o_ClearB        : out    vl_logic;
        loadcounter     : out    vl_logic;
        count           : out    vl_logic;
        o_ShiftA        : out    vl_logic;
        o_ShiftB        : out    vl_logic;
        o_Sel_Mux       : out    vl_logic;
        o_Loadinc       : out    vl_logic;
        o_LoadShift     : out    vl_logic;
        o_Inc           : out    vl_logic;
        o_Shift         : out    vl_logic;
        o_const_2       : out    vl_logic_vector(8 downto 0);
        o_const_9       : out    vl_logic_vector(6 downto 0);
        o_S0            : out    vl_logic;
        o_S1            : out    vl_logic;
        o_S2            : out    vl_logic;
        o_S3            : out    vl_logic;
        o_S4            : out    vl_logic;
        o_S5            : out    vl_logic;
        o_S6            : out    vl_logic;
        o_S7            : out    vl_logic
    );
end ControlPathAdder;
