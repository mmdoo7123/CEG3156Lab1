library verilog;
use verilog.vl_types.all;
entity fp_shiftright_norm_vlg_check_tst is
    port(
        o_RMz           : in     vl_logic_vector(7 downto 0);
        sampler_rx      : in     vl_logic
    );
end fp_shiftright_norm_vlg_check_tst;
