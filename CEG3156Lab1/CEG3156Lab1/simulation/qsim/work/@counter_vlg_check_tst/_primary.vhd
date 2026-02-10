library verilog;
use verilog.vl_types.all;
entity Counter_vlg_check_tst is
    port(
        o_val           : in     vl_logic_vector(6 downto 0);
        o_zero          : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end Counter_vlg_check_tst;
