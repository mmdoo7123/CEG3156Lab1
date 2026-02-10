library verilog;
use verilog.vl_types.all;
entity fpMultiplier_vlg_check_tst is
    port(
        Exponent        : in     vl_logic_vector(6 downto 0);
        Mantissa        : in     vl_logic_vector(7 downto 0);
        NormalizeNeeded : in     vl_logic;
        SignResult      : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end fpMultiplier_vlg_check_tst;
