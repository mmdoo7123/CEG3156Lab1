library verilog;
use verilog.vl_types.all;
entity fourBitRightShift_vlg_check_tst is
    port(
        o_Value         : in     vl_logic_vector(3 downto 0);
        sampler_rx      : in     vl_logic
    );
end fourBitRightShift_vlg_check_tst;
