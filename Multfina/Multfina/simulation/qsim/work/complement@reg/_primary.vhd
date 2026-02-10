library verilog;
use verilog.vl_types.all;
entity complementReg is
    port(
        i_Clock         : in     vl_logic;
        i_resetBar      : in     vl_logic;
        i_Load          : in     vl_logic;
        i_D             : in     vl_logic_vector(7 downto 0);
        o_Q             : out    vl_logic_vector(7 downto 0);
        o_Qbar          : out    vl_logic_vector(7 downto 0)
    );
end complementReg;
