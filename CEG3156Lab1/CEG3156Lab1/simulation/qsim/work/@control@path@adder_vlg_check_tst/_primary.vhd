library verilog;
use verilog.vl_types.all;
entity ControlPathAdder_vlg_check_tst is
    port(
        count           : in     vl_logic;
        loadcounter     : in     vl_logic;
        o_ClearA        : in     vl_logic;
        o_ClearB        : in     vl_logic;
        o_const_2       : in     vl_logic_vector(8 downto 0);
        o_const_9       : in     vl_logic_vector(6 downto 0);
        o_Inc           : in     vl_logic;
        o_LoadExp_Mant_Cin: in     vl_logic;
        o_Loadinc       : in     vl_logic;
        o_LoadShift     : in     vl_logic;
        o_S0            : in     vl_logic;
        o_S1            : in     vl_logic;
        o_S2            : in     vl_logic;
        o_S3            : in     vl_logic;
        o_S4            : in     vl_logic;
        o_S5            : in     vl_logic;
        o_S6            : in     vl_logic;
        o_S7            : in     vl_logic;
        o_Sel_Mux       : in     vl_logic;
        o_Shift         : in     vl_logic;
        o_ShiftA        : in     vl_logic;
        o_ShiftB        : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end ControlPathAdder_vlg_check_tst;
