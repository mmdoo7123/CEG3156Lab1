library verilog;
use verilog.vl_types.all;
entity fp_multiplier_array is
    port(
        i_Mx            : in     vl_logic_vector(7 downto 0);
        i_My            : in     vl_logic_vector(7 downto 0);
        o_Mz            : out    vl_logic_vector(17 downto 0);
        o_bad8          : out    vl_logic
    );
end fp_multiplier_array;
