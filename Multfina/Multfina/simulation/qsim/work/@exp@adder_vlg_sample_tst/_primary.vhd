library verilog;
use verilog.vl_types.all;
entity ExpAdder_vlg_sample_tst is
    port(
        i_CarryIn       : in     vl_logic;
        i_SigA          : in     vl_logic_vector(8 downto 0);
        i_SigB          : in     vl_logic_vector(8 downto 0);
        sampler_tx      : out    vl_logic
    );
end ExpAdder_vlg_sample_tst;
