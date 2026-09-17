library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_counter_tb is
end sync_counter_tb;

architecture rtl of sync_counter_tb is
-- Declare
constant T : time := 100 ns;

component sync_counter
	port(
		clock, clock_enable, reset : in std_ulogic;
		q : out std_ulogic_vector(3 downto 0)
	);
end component;

signal clock_wire, clock_enable_wire, reset_wire : std_ulogic := '0';
signal reset_accomplished : std_ulogic := '0';
signal q_wire : std_ulogic_vector(3 downto 0);

begin
-- Behavior

SYN_CNT : sync_counter
port map(
	clock => clock_wire,
	clock_enable => clock_enable_wire,
	reset => reset_wire,
	q => q_wire
);




-- CLK Process
process
begin
	clock_wire <= '0';
	wait for T/2;
	clock_wire <= '1';
	wait for T/2;
end process;




-- RESET Process
process
begin
	if reset_accomplished = '0' then
		reset_wire <= '1';
		reset_accomplished <= '1';
	elsif reset_accomplished = '1' then
		reset_wire <= '0';
	end if;

	wait for T;
end process;



-- ENABLE Process
process
begin
	if clock_enable_wire = '1' then
		clock_enable_wire <= '0';
	elsif clock_enable_wire = '0' then
		clock_enable_wire <= '1';
	end if;
	wait for 5*T;
end process;




end rtl;
