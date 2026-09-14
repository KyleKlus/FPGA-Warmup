-----------------------------------------------------------
--      Institute of Microelectronic Systems
--      Architectures and Systems
--      Leibniz Universitaet Hannover
-----------------------------------------------------------
--      lab :         Design Methods for FPGAs
--      file :        fabric.vhdl
--      authors :     
--      last update : 
--      description : 
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fpga_audiofx_pkg.all;

entity fabric is
  generic (
    INPUTS  : natural;
    OUTPUTS : natural
    );
  port (
    clock          : in  std_ulogic;
    reset          : in  std_ulogic;
    ain_sync       : in  std_ulogic_vector(INPUTS-1 downto 0);
    ain_data       : in  std_ulogic_vector(INPUTS-1 downto 0);
    aout_data      : out std_ulogic_vector(OUTPUTS-1 downto 0);
    aout_sync      : out std_ulogic_vector(OUTPUTS-1 downto 0);
    regif_cs       : in  std_ulogic;
    regif_wen      : in  std_ulogic;
    regif_addr     : in  std_ulogic_vector(REGIF_ADDR_WIDTH-1 downto 0);
    regif_data_in  : in  std_ulogic_vector(REGIF_DATA_WIDTH-1 downto 0);
    regif_data_out : out std_ulogic_vector(REGIF_DATA_WIDTH-1 downto 0)
    );
end entity fabric;



