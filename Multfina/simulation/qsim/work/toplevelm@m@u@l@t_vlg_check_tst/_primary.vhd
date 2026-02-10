library verilog;
use verilog.vl_types.all;
entity toplevelmMULT_vlg_check_tst is
    port(
        ExponentOut     : in     vl_logic_vector(6 downto 0);
        MantissaOut     : in     vl_logic_vector(7 downto 0);
        overflow        : in     vl_logic;
        s1              : in     vl_logic;
        s2              : in     vl_logic;
        s3              : in     vl_logic;
        s4              : in     vl_logic;
        s6              : in     vl_logic;
        SignOut         : in     vl_logic;
        so              : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end toplevelmMULT_vlg_check_tst;
