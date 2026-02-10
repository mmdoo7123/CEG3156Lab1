library verilog;
use verilog.vl_types.all;
entity ShiftRightReg is
    port(
        i_clock         : in     vl_logic;
        i_reset         : in     vl_logic;
        i_load9         : in     vl_logic;
        i_SHR8          : in     vl_logic;
        i_Mz            : in     vl_logic_vector(17 downto 0);
        o_RMz           : out    vl_logic_vector(7 downto 0)
    );
end ShiftRightReg;
