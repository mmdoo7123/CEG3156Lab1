library verilog;
use verilog.vl_types.all;
entity fourBitRightShift_vlg_sample_tst is
    port(
        i_clock         : in     vl_logic;
        i_load          : in     vl_logic;
        i_resetBar      : in     vl_logic;
        i_shiftR        : in     vl_logic;
        i_Value         : in     vl_logic_vector(3 downto 0);
        sampler_tx      : out    vl_logic
    );
end fourBitRightShift_vlg_sample_tst;
