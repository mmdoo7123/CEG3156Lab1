library verilog;
use verilog.vl_types.all;
entity eightBitRightShift_vlg_check_tst is
    port(
        o_Value         : in     vl_logic_vector(17 downto 0);
        sampler_rx      : in     vl_logic
    );
end eightBitRightShift_vlg_check_tst;
