library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_counter_func is
port(
    clock : in std_ulogic;
    clock_enable: in std_ulogic;
    reset : in std_ulogic;
    q : out std_ulogic_vector(3 downto 0)
);
end sync_counter_func;

architecture rtl of sync_counter_func is
    constant ZERO : unsigned(3 downto 0) := to_unsigned(0,4);
    constant ONE : unsigned(3 downto 0) := to_unsigned(1,4);

    signal n: unsigned(3 downto 0) := ZERO;
    signal n_next : unsigned(3 downto 0);
begin
    process(clock, reset)
    begin
        if reset = '1' then
            n <= ZERO;
        elsif rising_edge(clock) and clock_enable = '1' then
            n <= n_next;
        end if;
    end process;

    process(n)
    begin
        if n = 15 then
            n_next <= ZERO;
        else
            n_next <= n + to_unsigned(1, 4);
        end if;
    end process;

    q <= std_ulogic_vector(n);
end rtl;