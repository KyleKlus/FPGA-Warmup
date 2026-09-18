library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_demo is
port(
	clock : in std_ulogic;
	key0_n : in std_ulogic;
	switch0: in std_ulogic_vector(3 downto 0);
	hex0_n : out std_ulogic_vector(6 downto 0);
	hex1_n : out std_ulogic_vector(6 downto 0)
);
end counter_demo;

architecture rtl of counter_demo is
-- Signals, Constants, Components
	constant base_frequency : std_ulogic_vector(25 downto 0) := "0000" & (21 downto 0 => '1');
	signal not_key0_n, reduced_clk_wire: std_ulogic;
	signal frequency_in : std_ulogic_vector(25 downto 0);
	signal q_out_wire: std_ulogic_vector(3 downto 0);

	component enableGen
		port(
			resetValue_in : in std_ulogic_vector(25 downto 0);
			clk : in std_ulogic;
			nReset : in std_ulogic;
			clkEnable_out : out std_ulogic
		);
	end component;

	component sync_counter_func
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

enableGen_inst : enableGen
port map(
	clk => clock,
	resetValue_in => frequency_in,
	nReset => key0_n,
	clkEnable_out => reduced_clk_wire
);

sync_counter_func_inst: sync_counter_func
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

process(switch0)
begin
	frequency_in <= switch0 & base_frequency( 21 downto 0);

end process;

end rtl;