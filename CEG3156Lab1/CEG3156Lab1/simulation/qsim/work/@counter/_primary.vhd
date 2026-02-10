library verilog;
use verilog.vl_types.all;
entity Counter is
    port(
        i_clock         : in     vl_logic;
        i_resetBar      : in     vl_logic;
        i_load          : in     vl_logic;
        i_decrement     : in     vl_logic;
        i_countIn       : in     vl_logic_vector(6 downto 0);
        o_zero          : out    vl_logic;
        o_val           : out    vl_logic_vector(6 downto 0)
    );
end Counter;
