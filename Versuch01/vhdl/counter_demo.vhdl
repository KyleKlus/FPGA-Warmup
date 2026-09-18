library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_demo is
port(
	clock : in std_ulogic;
	key0_n : in std_ulogic;
	hex0_n : out std_ulogic_vector(6 downto 0);
	hex1_n : out std_ulogic_vector(6 downto 0)
);
end counter_demo;

architecture rtl of counter_demo is
-- Signals, Constants, Components
	signal not_key0_n, reduced_clk_wire: std_ulogic;
	signal q_out_wire: std_ulogic_vector(3 downto 0);

	component enable_gen
		port(
			resetValue_in : in std_ulogic_vector(25 downto 0);
			clk : in std_ulogic;
			nReset : in std_ulogic;
			clkEnable_out : out std_ulogic
		);
	end component;

	component sync_counter
		port (
			clock : in std_ulogic;
			clock_enable : in std_ulogic;
			reset: in std_ulogic;
			q: out std_ulogic_vector(3 downto 0)
		);
	end component;

	component segment_decoder
		port(
			data   : in  std_ulogic_vector(3 downto 0);
            hex0_n : out std_ulogic_vector(6 downto 0);
            hex1_n : out std_ulogic_vector(6 downto 0)
		);
	end component;

begin
-- Logic & Processes
not_key0_n <= not key0_n;

enable_gen_inst : enable_gen
port map(
	clk => clock,
	resetValue_in => std_ulogic_vector(to_unsigned(50000000, 26)),
	nReset => key0_n,
	clkEnable_out => reduced_clk_wire
);

sync_counter_inst: sync_counter
port map(
	clock => clock,
	clock_enable => reduced_clk_wire,
	reset => not_key0_n,
	q => q_out_wire
);

segment_decoder_inst: segment_decoder
port map(
	data => q_out_wire,
	hex0_n => hex0_n,
	hex1_n => hex1_n
);


end rtl;