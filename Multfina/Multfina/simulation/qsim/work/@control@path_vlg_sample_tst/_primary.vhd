library verilog;
use verilog.vl_types.all;
entity ControlPath_vlg_sample_tst is
    port(
        i_clock         : in     vl_logic;
        i_normalization : in     vl_logic;
        i_overflow_under: in     vl_logic;
        i_resetBar      : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end ControlPath_vlg_sample_tst;
