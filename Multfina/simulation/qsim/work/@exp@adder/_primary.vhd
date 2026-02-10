library verilog;
use verilog.vl_types.all;
entity ExpAdder is
    port(
        i_SigA          : in     vl_logic_vector(8 downto 0);
        i_SigB          : in     vl_logic_vector(8 downto 0);
        i_CarryIn       : in     vl_logic;
        o_Sum           : out    vl_logic_vector(8 downto 0);
        o_CarryOut      : out    vl_logic
    );
end ExpAdder;
