library verilog;
use verilog.vl_types.all;
entity fpMultiplier is
    port(
        NormalizeNeeded : out    vl_logic;
        shift           : in     vl_logic;
        loadShift       : in     vl_logic;
        Gclock          : in     vl_logic;
        resetBar        : in     vl_logic;
        LoadMantissas   : in     vl_logic;
        MantissaB       : in     vl_logic_vector(7 downto 0);
        MantissaA       : in     vl_logic_vector(7 downto 0);
        SignResult      : out    vl_logic;
        SignA           : in     vl_logic;
        SignB           : in     vl_logic;
        loadsign        : in     vl_logic;
        Exponent        : out    vl_logic_vector(6 downto 0);
        LoadCounter     : in     vl_logic;
        incExp          : in     vl_logic;
        CarryIn1        : in     vl_logic;
        loadComplementer: in     vl_logic;
        LoadBiasB       : in     vl_logic;
        Bias            : in     vl_logic_vector(6 downto 0);
        LoadBiasA       : in     vl_logic;
        loadExponents   : in     vl_logic;
        ExponentA       : in     vl_logic_vector(6 downto 0);
        ExponentB       : in     vl_logic_vector(6 downto 0);
        Mantissa        : out    vl_logic_vector(7 downto 0)
    );
end fpMultiplier;
