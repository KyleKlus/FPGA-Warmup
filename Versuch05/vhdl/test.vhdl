library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fpga_audiofx_pkg.all;

entity test is
port (
    clock     : in  std_ulogic;
    reset     : in  std_ulogic;
    -- serial audio-data signals
    ain_sync  : in  std_ulogic;
    ain_data  : in  std_ulogic;
    -- serial audio-data signals
    aout_sync : out std_ulogic;
    aout_data : out std_ulogic
    );
end entity test;
architecture rtl of test is
     -- internal parallel audio-data signals
    signal smp_valid : std_ulogic;
    signal smp_ack   : std_ulogic;
    signal smp_data  : std_ulogic_vector(SAMPLE_WIDTH-1 downto 0);

    -- internal s2p and p2s components
    component s2p is
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
    end component s2p;

    component p2s is
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
    end component p2s;
begin

s2p_inst : s2p
port map(
    clock => clock,
    reset => reset,
    ain_sync => ain_sync,
    ain_data => ain_data,
    smp_valid => smp_valid,
    smp_ack => smp_ack,
    smp_data => smp_data
);

p2s_inst : p2s
port map(
    clock => clock,
    reset => reset,
    aout_sync => aout_sync,
    aout_data => aout_data,
    smp_valid => smp_valid,
    smp_ack => smp_ack,
    smp_data => smp_data
);

end architecture rtl;