library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity async_adder is
port(
    a: in signed(3 downto 0);
    b: in signed(3 downto 0);
    o: out signed(4 downto 0)
);
end async_adder;
architecture async of async_adder is

begin

o <= resize(a, 5) + resize(b, 5);

end async;
