library verilog;
use verilog.vl_types.all;
entity ShiftRightReg_vlg_sample_tst is
    port(
        i_clock         : in     vl_logic;
        i_load9         : in     vl_logic;
        i_Mz            : in     vl_logic_vector(17 downto 0);
        i_reset         : in     vl_logic;
        i_SHR8          : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end ShiftRightReg_vlg_sample_tst;
