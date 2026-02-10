library verilog;
use verilog.vl_types.all;
entity overflow_underflow_unit_vlg_sample_tst is
    port(
        i_clock         : in     vl_logic;
        i_enable        : in     vl_logic;
        i_exponent      : in     vl_logic_vector(7 downto 0);
        i_resetBar      : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end overflow_underflow_unit_vlg_sample_tst;
