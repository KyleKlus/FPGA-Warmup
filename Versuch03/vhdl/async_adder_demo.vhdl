library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity adder_demo is
    port (
        a: in std_ulogic_vector(3 downto 0);
        b: in std_ulogic_vector(3 downto 0);
        hex0_n: out std_ulogic_vector(6 downto 0);
        hex1_n: out std_ulogic_vector(6 downto 0);
        hex2_n: out std_ulogic_vector(6 downto 0)
    );
end entity adder_demo;

architecture rtl of adder_demo is
    signal a_wire, b_wire: signed(3 downto 0);
    signal o_wire: signed(4 downto 0);
    signal data_wire: std_ulogic_vector(4 downto 0);

    component segment_decoder
        port(
            data   : in  std_ulogic_vector(4 downto 0);
            hex0_n : out std_ulogic_vector(6 downto 0);
            hex1_n : out std_ulogic_vector(6 downto 0);
            hex2_n : out std_ulogic_vector(6 downto 0)
        );
    end component;

    component async_adder
        port(
            a   : in  signed(3 downto 0);
            b   : in  signed(3 downto 0);
            o   : out  signed(4 downto 0)
        );
    end component;

begin

async_adder_inst: async_adder
port map(
    a => a_wire,
    b => b_wire,
    o => o_wire
);

segment_decoder_inst: segment_decoder
 port map(
    data => data_wire,
    hex0_n => hex0_n,
    hex1_n => hex1_n,
    hex2_n => hex2_n
);

a_wire <= signed(a);
b_wire <= signed(b);
data_wire <= std_ulogic_vector(o_wire);

end architecture;