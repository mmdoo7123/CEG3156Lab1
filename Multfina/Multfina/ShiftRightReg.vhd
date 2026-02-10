library ieee;
use ieee.std_logic_1164.all;

entity ShiftRightReg is
    port (
        i_clock   : in  std_logic;
        i_reset   : in  std_logic;
        i_load9   : in  std_logic; -- Load signal from control path
        i_SHR8    : in  std_logic; -- Shift Right enable
        i_Mz      : in  std_logic_vector(17 downto 0); -- From Multiplier
        o_RMz     : out std_logic_vector(7 downto 0)   -- Final 8-bit Mantissa
    );
end ShiftRightReg;

architecture structural of ShiftRightReg is
    signal r_data : std_logic_vector(17 downto 0);
begin
    process(i_clock, i_reset)
    begin
        if i_reset = '1' then
            r_data <= (others => '0');
        elsif rising_edge(i_clock) then
            if i_load9 = '1' then
                r_data <= i_Mz;
            end if;
        end if;
    end process;

    -- Combinatorial Multiplexer for Shifting/Truncation
    -- If SHR8 is 1, take the higher bits (shifted right). Otherwise, take standard bits.
    o_RMz <= r_data(16 downto 9) when i_SHR8 = '1' else 
             r_data(15 downto 8);

end structural;