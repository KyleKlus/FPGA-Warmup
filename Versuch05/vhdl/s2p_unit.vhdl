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
