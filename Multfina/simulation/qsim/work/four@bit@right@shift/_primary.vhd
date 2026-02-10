library verilog;
use verilog.vl_types.all;
entity fourBitRightShift is
    port(
        i_resetBar      : in     vl_logic;
        i_load          : in     vl_logic;
        i_shiftR        : in     vl_logic;
        i_clock         : in     vl_logic;
        i_Value         : in     vl_logic_vector(3 downto 0);
        o_Value         : out    vl_logic_vector(3 downto 0)
    );
end fourBitRightShift;
