library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_counter is
port (
    clock : in std_ulogic;
    clock_enable : in std_ulogic;
    reset: in std_ulogic;

    q: out std_ulogic_vector(3 downto 0);
);
end sync_counter;