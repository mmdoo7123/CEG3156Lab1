library verilog;
use verilog.vl_types.all;
entity exp_counter7_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        i_data          : in     vl_logic_vector(6 downto 0);
        i_inc1          : in     vl_logic;
        i_load7         : in     vl_logic;
        reset           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end exp_counter7_vlg_sample_tst;
