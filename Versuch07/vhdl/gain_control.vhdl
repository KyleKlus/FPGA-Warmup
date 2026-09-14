-----------------------------------------------------------
--      Institute of Microelectronic Systems
--      Architectures and Systems
--      Leibniz Universitaet Hannover
-----------------------------------------------------------
--      lab :         Design Methods for FPGAs
--      file :        gain_control.vhdl
--      authors :    
--      last update :
--      description :
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fpga_audiofx_pkg.all;

entity gain_control is
  generic (
    SHIFT_FACTOR : natural := 6
    );
  port (
    clock          : in  std_ulogic;
    reset          : in  std_ulogic;
    -- audio signals
    ain_sync       : in  std_ulogic;
    ain_data       : in  std_ulogic;
    aout_sync      : out std_ulogic;
    aout_data      : out std_ulogic;
    -- register interface
    regif_cs       : in  std_ulogic;
    regif_wen      : in  std_ulogic;
    regif_addr     : in  std_ulogic_vector(REGIF_ADDR_WIDTH-1 downto 0);
    regif_data_in  : in  std_ulogic_vector(REGIF_DATA_WIDTH-1 downto 0);
    regif_data_out : out std_ulogic_vector(REGIF_DATA_WIDTH-1 downto 0)
    );
end entity gain_control;
