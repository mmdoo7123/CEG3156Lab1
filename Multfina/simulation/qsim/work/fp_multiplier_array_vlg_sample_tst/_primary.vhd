library verilog;
use verilog.vl_types.all;
entity fp_multiplier_array_vlg_sample_tst is
    port(
        i_Mx            : in     vl_logic_vector(7 downto 0);
        i_My            : in     vl_logic_vector(7 downto 0);
        sampler_tx      : out    vl_logic
    );
end fp_multiplier_array_vlg_sample_tst;
