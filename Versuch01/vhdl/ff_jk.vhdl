library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library altera;
use altera.altera_primitives_components.all;

entity ff_jk is
  port(
    j    : in  std_ulogic;
    k    : in  std_ulogic;
    clk  : in  std_ulogic;
    ena  : in  std_ulogic;
    clrn : in  std_ulogic;
    prn  : in  std_ulogic;
    q    : out std_ulogic
    );
end ff_jk;

architecture rtl of ff_jk is
  signal d_in, q_feedback : std_ulogic;

  component dffe
    port(
      d, clk, ena, clrn, prn : in  std_ulogic;
      q                      : out std_ulogic);

  end component;
begin
  d_in <= (j and not q_feedback) or (not k and q_feedback);

  dffe_inst : dffe
    port map(
      d => d_in,
      clk => clk,
      ena => ena,
      clrn => clrn,
      prn => prn,
      q => q_feedback
    );

  q <= q_feedback;
end rtl;
