library verilog;
use verilog.vl_types.all;
entity eightBitRightShift is
    port(
        i_resetBar      : in     vl_logic;
        i_load          : in     vl_logic;
        i_shiftR        : in     vl_logic;
        i_clock         : in     vl_logic;
        i_Value         : in     vl_logic_vector(17 downto 0);
        o_Value         : out    vl_logic_vector(17 downto 0)
    );
end eightBitRightShift;
