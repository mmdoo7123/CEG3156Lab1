library verilog;
use verilog.vl_types.all;
entity ExpAdder_vlg_check_tst is
    port(
        o_CarryOut      : in     vl_logic;
        o_Sum           : in     vl_logic_vector(8 downto 0);
        sampler_rx      : in     vl_logic
    );
end ExpAdder_vlg_check_tst;
