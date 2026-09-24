-----------------------------------------------------------
--      Institute of Microelectronic Systems
--      Architectures and Systems
--      Leibniz Universitaet Hannover
-----------------------------------------------------------
--      lab :         Design Methods for FPGAs
--      file :        s2p_unit.vhdl
--      authors :
--      last update :
--      description :
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fpga_audiofx_pkg.all;

entity s2p_unit is
  port (
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
end entity s2p_unit;
architecture rtl of s2p_unit is
  -- bit counter signals
  signal bit_cnt, bit_cnt_next : unsigned(to_log2(SAMPLE_WIDTH)-1 downto 0);
  signal cnt_reset: std_ulogic;
  signal nload: std_ulogic;

  -- fsm signals
  type state_t is (IDLE, GET_DATA, WAIT_ACK);
  signal state, state_next : state_t;
  signal din_en, dout_en: std_ulogic;

  -- shift register
  signal sample, sample_next : std_ulogic_vector(SAMPLE_WIDTH-1 downto 0);
begin

ff : process(clock, reset)
begin
  if reset = '1' then
    bit_cnt <= (others => '0');
    state <= IDLE;
    sample <= (others=>'0');
  elsif rising_edge(clock) then
    bit_cnt <= bit_cnt_next;
    state <= state_next;
    sample <= sample_next;
  end if;
end process ff;

bit_counter : process(bit_cnt, cnt_reset)
begin
  bit_cnt_next <= bit_cnt;
  nload <= '0';

  if cnt_reset = '1' then
    bit_cnt_next <= (others => '0');
    nload <= '0';
  elsif bit_cnt = SAMPLE_WIDTH-1 then
    bit_cnt_next <= bit_cnt;
    nload <= '1';
  elsif bit_cnt = SAMPLE_WIDTH-2 then
    nload <= '1';
    bit_cnt_next <= bit_cnt + 1;
  elsif bit_cnt <= SAMPLE_WIDTH-3 then
    nload <= '0';
    bit_cnt_next <= bit_cnt + 1;
  end if;
end process bit_counter;

fsm: process(state, ain_sync, nload, smp_ack)
begin
  -- hold register content
  state_next <= state;

  -- hold enable and valid low by default
  din_en <= '0';
  dout_en <= '0';
  smp_valid <= '0';
  cnt_reset <= '0';

  case state is
    when IDLE =>
      -- wait for ain_sync
      if ain_sync = '1' then
        cnt_reset <= '1';
        din_en <= '1';
        state_next <= GET_DATA;
      end if;
    when GET_DATA =>
      -- reading in serial bits
      din_en <= '1';

      if nload = '1' then
        -- counter is done -> all bits read
        state_next <= WAIT_ACK;
      end if;
    when WAIT_ACK =>
      -- all bits read -> make them available
      dout_en <= '1';
      smp_valid <= '1';

      if ain_sync = '1' then
        -- new sample coming in
        cnt_reset <= '1';
        din_en <= '1';
        state_next <= GET_DATA;
      elsif smp_ack = '1' then
        -- waiting for next sample
        state_next <= IDLE;
      end if;
  end case;
end process fsm;

pdata: process(sample, ain_data, din_en, dout_en)
begin
  -- hold register content
  sample_next <= sample;

  if dout_en = '1' then
    smp_data <= sample;
  else
    smp_data <= (others => '0');
  end if;

  if din_en = '1' then
    sample_next(sample_next'length-1 downto 1) <= sample(sample'length-2 downto 0);
    sample_next(0) <= ain_data;
  end if;
end process pdata;

end architecture rtl;