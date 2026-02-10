library verilog;
use verilog.vl_types.all;
entity complementReg_vlg_sample_tst is
    port(
        i_Clock         : in     vl_logic;
        i_D             : in     vl_logic_vector(7 downto 0);
        i_Load          : in     vl_logic;
        i_resetBar      : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end complementReg_vlg_sample_tst;
