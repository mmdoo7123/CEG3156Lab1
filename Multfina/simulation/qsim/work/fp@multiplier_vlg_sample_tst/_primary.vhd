library verilog;
use verilog.vl_types.all;
entity fpMultiplier_vlg_sample_tst is
    port(
        Bias            : in     vl_logic_vector(6 downto 0);
        CarryIn1        : in     vl_logic;
        ExponentA       : in     vl_logic_vector(6 downto 0);
        ExponentB       : in     vl_logic_vector(6 downto 0);
        Gclock          : in     vl_logic;
        incExp          : in     vl_logic;
        LoadBiasA       : in     vl_logic;
        LoadBiasB       : in     vl_logic;
        loadComplementer: in     vl_logic;
        LoadCounter     : in     vl_logic;
        loadExponents   : in     vl_logic;
        LoadMantissas   : in     vl_logic;
        loadShift       : in     vl_logic;
        loadsign        : in     vl_logic;
        MantissaA       : in     vl_logic_vector(7 downto 0);
        MantissaB       : in     vl_logic_vector(7 downto 0);
        resetBar        : in     vl_logic;
        shift           : in     vl_logic;
        SignA           : in     vl_logic;
        SignB           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end fpMultiplier_vlg_sample_tst;
