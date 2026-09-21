library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_adder is
port(
    clk: in std_ulogic;
    a: in signed(3 downto 0);
    b: in signed(3 downto 0);
    o: out signed(4 downto 0)
);
end sync_adder;
architecture sync of sync_adder is
    signal n, n_next : signed(4 downto 0);
begin

process(clk)
begin
    if rising_edge(clk) then
        n <= n_next;
    end if;

end process;

process (n)
begin
    n_next <= resize(a, 5) + resize(b, 5);
end process;

o <= n;

end sync;
