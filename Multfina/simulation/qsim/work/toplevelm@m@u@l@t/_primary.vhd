library verilog;
use verilog.vl_types.all;
entity toplevelmMULT is
    port(
        SignOut         : out    vl_logic;
        Gclock          : in     vl_logic;
        resetBar        : in     vl_logic;
        SignA           : in     vl_logic;
        SignB           : in     vl_logic;
        ExponentA       : in     vl_logic_vector(6 downto 0);
        ExponentB       : in     vl_logic_vector(6 downto 0);
        MantissaA       : in     vl_logic_vector(7 downto 0);
        MantissaB       : in     vl_logic_vector(7 downto 0);
        so              : out    vl_logic;
        s1              : out    vl_logic;
        s2              : out    vl_logic;
        s3              : out    vl_logic;
        s6              : out    vl_logic;
        s4              : out    vl_logic;
        overflow        : out    vl_logic;
        ExponentOut     : out    vl_logic_vector(6 downto 0);
        MantissaOut     : out    vl_logic_vector(7 downto 0)
    );
end toplevelmMULT;
