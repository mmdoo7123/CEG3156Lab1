library verilog;
use verilog.vl_types.all;
entity fp_shiftright_norm_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        i_load9         : in     vl_logic;
        i_Mz            : in     vl_logic_vector(17 downto 0);
        i_SHR8          : in     vl_logic;
        reset           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end fp_shiftright_norm_vlg_sample_tst;
