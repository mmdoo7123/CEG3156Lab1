library verilog;
use verilog.vl_types.all;
entity expOverUnderUnit_vlg_check_tst is
    port(
        o_overflow      : in     vl_logic;
        o_overunder     : in     vl_logic;
        o_underflow     : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end expOverUnderUnit_vlg_check_tst;
