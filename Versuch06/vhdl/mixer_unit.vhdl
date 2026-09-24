-----------------------------------------------------------
--      Institute of Microelectronic Systems
--      Architectures and Systems
--      Leibniz Universitaet Hannover
-----------------------------------------------------------
--      lab :         Design Methods for FPGAs
--      file :        mixer_unit.vhdl
--      authors :
--      last update :
--      description :
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fpga_audiofx_pkg.all;

entity mixer_unit is
  port (
    clock     : in  std_ulogic;
    reset     : in  std_ulogic;
    -- serial audio-data inputs
    ain_sync  : in  std_ulogic_vector(1 downto 0);
    ain_data  : in  std_ulogic_vector(1 downto 0);
    -- serial audio-data output
    aout_sync : out std_ulogic;
    aout_data : out std_ulogic
    );
end entity mixer_unit;
architecture rtl of mixer_unit is
  signal channel_a_smp_valid: std_ulogic;
  signal channel_a_smp_ack: std_ulogic;
  signal channel_a_smp_data:  std_ulogic_vector(SAMPLE_WIDTH-1 downto 0);
  signal channel_b_smp_valid:  std_ulogic;
  signal channel_b_smp_ack:  std_ulogic;
  signal channel_b_smp_data:  std_ulogic_vector(SAMPLE_WIDTH-1 downto 0);
  signal in_data_valid: std_ulogic;
  signal mixer_out_valid:  std_ulogic;
  signal mixer_out_ack:  std_ulogic;
  signal mixer_res_data:  signed(SAMPLE_WIDTH-1 downto 0);
  signal mixer_smp_data:  std_ulogic_vector(SAMPLE_WIDTH-1 downto 0);

  component s2p_unit is
  port(
    clock     : in  std_ulogic;
    reset     : in  std_ulogic;
    -- serial audio-data signals
    ain_sync  : in  std_ulogic;
    ain_data  : in  std_ulogic;
    -- parallel audio-data signals
    smp_valid : out std_ulogic;
    smp_ack   : in  std_ulogic;
    smp_data  : out std_ulogic_vector(SAMPLE_WIDTH-1 downto 0)
  );
  end component s2p_unit;

  component p2s_unit is
  port(
    clock     : in  std_ulogic;
    reset     : in  std_ulogic;
    -- parallel audio-data signals
    smp_valid : in  std_ulogic;
    smp_ack   : out std_ulogic;
    smp_data  : in  std_ulogic_vector(SAMPLE_WIDTH-1 downto 0);
    -- serial audio-data signals
    aout_sync : out std_ulogic;
    aout_data : out std_ulogic
  );
  end component p2s_unit;
begin

in_data_valid <= channel_a_smp_valid and channel_b_smp_valid;
mixer_out_valid <= in_data_valid and mixer_out_ack;

mixer_add: process(in_data_valid, channel_a_smp_data, channel_b_smp_data)
begin
 if in_data_valid = '1' then
  mixer_res_data <= signed(channel_a_smp_data) + signed(channel_b_smp_data);
 else
  mixer_res_data <= (others => '0');
 end if;
end process mixer_add;


mixer_out: process(mixer_out_valid, mixer_res_data)
begin
  channel_a_smp_ack <= '0';
  channel_b_smp_ack <= '0';

  if mixer_out_valid = '1' then
      mixer_smp_data <= std_ulogic_vector(mixer_res_data);
      channel_a_smp_ack <= '1';
      channel_b_smp_ack <= '1';
  else
    mixer_smp_data <= (others => '0');
  end if;
end process mixer_out;

s2p_a_inst: s2p_unit
port map (
clock => clock,
  reset => reset,
  ain_sync => ain_sync(0),
  ain_data => ain_data(0),
  smp_valid => channel_a_smp_valid,
  smp_data => channel_a_smp_data,
  smp_ack => channel_a_smp_ack
);

s2p_b_inst: s2p_unit
port map (
  clock => clock,
  reset => reset,
  ain_sync => ain_sync(1),
  ain_data => ain_data(1),
  smp_valid => channel_b_smp_valid,
  smp_data => channel_b_smp_data,
  smp_ack => channel_b_smp_ack
);

p2s_out_inst: p2s_unit
port map (
  clock => clock,
  reset => reset,
  smp_ack => mixer_out_ack,
  smp_data => mixer_smp_data,
  smp_valid => mixer_out_valid,
  aout_data => aout_data,
  aout_sync => aout_sync
);

end architecture rtl;
