library verilog;
use verilog.vl_types.all;
entity ControlPath is
    port(
        i_clock         : in     vl_logic;
        i_resetBar      : in     vl_logic;
        i_normalization : in     vl_logic;
        i_overflow_under: in     vl_logic;
        o_S0            : out    vl_logic;
        o_S1            : out    vl_logic;
        o_S2            : out    vl_logic;
        o_S3            : out    vl_logic;
        o_S4            : out    vl_logic;
        o_S5            : out    vl_logic;
        o_S6            : out    vl_logic;
        o_bias          : out    vl_logic_vector(6 downto 0)
    );
end ControlPath;
