library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder_tb is
end adder_tb;
architecture rtl of adder_tb is
    constant A_INDEX: integer range 0 to 1 := 0;
    constant B_INDEX: integer range 0 to 1 := 1;
    constant T : time := 100 ps;

    type TEST_PAIR is array (0 to 1) of signed(3 downto 0);
    type TEST_SEQUENCE is array (0 to 7) of TEST_PAIR;
    constant test_data : TEST_SEQUENCE := (
        (to_signed(1, 4), to_signed(1, 4)),
        (to_signed(2, 4), to_signed(3, 4)),
        (to_signed(7, 4), to_signed(7, 4)),
        (to_signed(-1, 4), to_signed(-1, 4)),
        (to_signed(5, 4), to_signed(-7, 4)),
        (to_signed(-8, 4), to_signed(-8, 4)),
        (to_signed(8, 4), to_signed(8, 4)),
        (to_signed(-7, 4), to_signed(-7, 4))
    );

    signal a_wire, b_wire: signed(3 downto 0);
    signal o_wire: signed(4 downto 0);
    component async_adder
        port(
            a: in signed(3 downto 0);
            b: in signed(3 downto 0);
            o: out signed(4 downto 0)
        );
    end component;
begin

async_adder_inst: async_adder
port map(
    a => a_wire,
    b => b_wire,
    o => o_wire
);

process
begin

for I in test_data' range loop
    a_wire <= test_data(I)(A_INDEX);
    b_wire <= test_data(I)(B_INDEX);
    wait for T;
end loop;

end process;


end rtl;