library verilog;
use verilog.vl_types.all;
entity expOverUnderUnit_vlg_sample_tst is
    port(
        i_exp_final     : in     vl_logic_vector(6 downto 0);
        sampler_tx      : out    vl_logic
    );
end expOverUnderUnit_vlg_sample_tst;
