library verilog;
use verilog.vl_types.all;
entity complementReg_vlg_check_tst is
    port(
        o_Q             : in     vl_logic_vector(7 downto 0);
        o_Qbar          : in     vl_logic_vector(7 downto 0);
        sampler_rx      : in     vl_logic
    );
end complementReg_vlg_check_tst;
