library verilog;
use verilog.vl_types.all;
entity ShiftRightReg_vlg_check_tst is
    port(
        o_RMz           : in     vl_logic_vector(7 downto 0);
        sampler_rx      : in     vl_logic
    );
end ShiftRightReg_vlg_check_tst;
