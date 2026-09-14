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

architecture rtl of sync_counter is
-- Declare things
    -- Constants
    constant CLAMP_UP: std_ulogic := '1';
    -- Components
    component ff_jk
    port(
        j    : in  std_ulogic;
        k    : in  std_ulogic;
        clk  : in  std_ulogic;
        ena  : in  std_ulogic;
        clrn : in  std_ulogic;
        prn  : in  std_ulogic;
        q    : out std_ulogic
    );
    end component;

    -- Signals
    signal clk_wire, clk_enable_wire, reset_wire: std_ulogic;
    signal q_wire: std_ulogic_vector(3 downto 0);

begin
-- Describe the synchronous counter
-- Instantiate components
JK_FF_0: ff_jk
port map(
    j => CLAMP_UP;
    k => CLAMP_UP;
    clrn => not reset_wire;
    prn => CLAMP_UP;
    clk => rising_edge(clk_wire);
    ena => clk_enable_wire;
    q => q_wire(0);
);

JK_FF_1: ff_jk
port map(
    j => q_wire(0);
    k => q_wire(0);
    clrn => not reset_wire;
    prn => CLAMP_UP;
    clk => rising_edge(clk_wire);
    ena => clk_enable_wire;
    q => q_wire(1);
);

JK_FF_2: ff_jk
port map(
    j => q_wire(0) AND q_wire(1);
    k => q_wire(0) AND q_wire(1);
    clrn => not reset_wire;
    prn => CLAMP_UP;
    clk => rising_edge(clk_wire);
    ena => clk_enable_wire;
    q => q_wire(2);
);

JK_FF_3: ff_jk
port map(
    j => q_wire(0) AND q_wire(1) AND q_wire(2);
    k => q_wire(0) AND q_wire(1) AND q_wire(2);
    clrn => not reset_wire;
    prn => CLAMP_UP;
    clk => rising_edge(clk_wire);
    ena => clk_enable_wire;
    q => q_wire(3);
);


clk_wire <= clock;
clk_enable_wire <= clock_enable;
reset_wire <= reset;
q <= q_wire;
-- Processes go in here

end rtl;
