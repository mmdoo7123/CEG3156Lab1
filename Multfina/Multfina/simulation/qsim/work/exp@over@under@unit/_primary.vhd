library verilog;
use verilog.vl_types.all;
entity expOverUnderUnit is
    port(
        i_exp_final     : in     vl_logic_vector(6 downto 0);
        o_underflow     : out    vl_logic;
        o_overflow      : out    vl_logic;
        o_overunder     : out    vl_logic
    );
end expOverUnderUnit;
