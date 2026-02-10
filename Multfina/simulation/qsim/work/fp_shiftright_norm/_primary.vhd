library verilog;
use verilog.vl_types.all;
entity fp_shiftright_norm is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        i_load9         : in     vl_logic;
        i_SHR8          : in     vl_logic;
        i_Mz            : in     vl_logic_vector(17 downto 0);
        o_RMz           : out    vl_logic_vector(7 downto 0)
    );
end fp_shiftright_norm;
