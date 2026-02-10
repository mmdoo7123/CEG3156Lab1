library verilog;
use verilog.vl_types.all;
entity ControlPath_vlg_check_tst is
    port(
        o_bias          : in     vl_logic_vector(6 downto 0);
        o_S0            : in     vl_logic;
        o_S1            : in     vl_logic;
        o_S2            : in     vl_logic;
        o_S3            : in     vl_logic;
        o_S4            : in     vl_logic;
        o_S5            : in     vl_logic;
        o_S6            : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end ControlPath_vlg_check_tst;
