library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_counter is
port (
    clock : in std_ulogic;
    clock_enable : in std_ulogic;
    reset: in std_ulogic;

    q: out std_ulogic_vector(3 downto 0)
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
    signal clk_enable_wire, not_reset_wire, and_in_t3, and_in_t2: std_ulogic;
    signal q_wire: std_ulogic_vector(3 downto 0);

begin
-- Describe the synchronous counter
-- Instantiate components
JK_FF_0: ff_jk
port map(
    j => CLAMP_UP,
    k => CLAMP_UP,
    clk => clock,
    ena => clk_enable_wire,
    clrn => not_reset_wire,
    prn => CLAMP_UP,
    q => q_wire(0)
);

JK_FF_1: ff_jk
port map(
    j => q_wire(0),
    k => q_wire(0),
    clk => clock,
    ena => clk_enable_wire,
    clrn => not_reset_wire,
    prn => CLAMP_UP,
    q => q_wire(1)
);

JK_FF_2: ff_jk
port map(
    j => and_in_t2,
    k => and_in_t2,
    clk => clock,
    ena => clk_enable_wire,
    clrn => not_reset_wire,
    prn => CLAMP_UP,
    q => q_wire(2)
);

JK_FF_3: ff_jk
port map(
    j => and_in_t3,
    k => and_in_t3,
    clk => clock,
    ena => clk_enable_wire,
    clrn => not_reset_wire,
    prn => CLAMP_UP,
    q => q_wire(3)
);

process(q_wire)
begin
    and_in_t2 <= q_wire(0) AND q_wire(1);
    and_in_t3 <= q_wire(0) AND q_wire(1) AND q_wire(2);
end process;

clk_enable_wire <= clock_enable;
not_reset_wire <= not reset;
q <= q_wire;
-- Processes go in here

end rtl;
