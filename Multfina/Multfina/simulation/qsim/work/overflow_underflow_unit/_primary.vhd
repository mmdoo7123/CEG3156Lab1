library verilog;
use verilog.vl_types.all;
entity overflow_underflow_unit is
    port(
        i_clock         : in     vl_logic;
        i_resetBar      : in     vl_logic;
        i_exponent      : in     vl_logic_vector(7 downto 0);
        i_enable        : in     vl_logic;
        o_overflow      : out    vl_logic;
        o_underflow     : out    vl_logic;
        o_overflow_under: out    vl_logic
    );
end overflow_underflow_unit;
