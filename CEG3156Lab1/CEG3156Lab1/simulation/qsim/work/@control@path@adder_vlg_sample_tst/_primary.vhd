library verilog;
use verilog.vl_types.all;
entity ControlPathAdder_vlg_sample_tst is
    port(
        i_AGTB          : in     vl_logic;
        i_clock         : in     vl_logic;
        i_diff_eq_0     : in     vl_logic;
        i_gt2           : in     vl_logic;
        i_gt9           : in     vl_logic;
        i_resetBar      : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end ControlPathAdder_vlg_sample_tst;
