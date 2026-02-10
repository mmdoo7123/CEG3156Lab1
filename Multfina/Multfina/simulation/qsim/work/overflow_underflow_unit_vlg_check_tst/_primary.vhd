library verilog;
use verilog.vl_types.all;
entity overflow_underflow_unit_vlg_check_tst is
    port(
        o_overflow      : in     vl_logic;
        o_overflow_under: in     vl_logic;
        o_underflow     : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end overflow_underflow_unit_vlg_check_tst;
