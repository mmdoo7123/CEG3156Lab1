library verilog;
use verilog.vl_types.all;
entity toplevelmMULT_vlg_sample_tst is
    port(
        ExponentA       : in     vl_logic_vector(6 downto 0);
        ExponentB       : in     vl_logic_vector(6 downto 0);
        Gclock          : in     vl_logic;
        MantissaA       : in     vl_logic_vector(7 downto 0);
        MantissaB       : in     vl_logic_vector(7 downto 0);
        resetBar        : in     vl_logic;
        SignA           : in     vl_logic;
        SignB           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end toplevelmMULT_vlg_sample_tst;
