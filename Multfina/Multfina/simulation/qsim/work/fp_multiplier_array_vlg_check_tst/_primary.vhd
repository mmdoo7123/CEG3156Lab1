library verilog;
use verilog.vl_types.all;
entity fp_multiplier_array_vlg_check_tst is
    port(
        o_bad8          : in     vl_logic;
        o_Mz            : in     vl_logic_vector(17 downto 0);
        sampler_rx      : in     vl_logic
    );
end fp_multiplier_array_vlg_check_tst;
