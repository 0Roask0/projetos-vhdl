library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity controle is
	port(
		clock 	: in std_logic;
		reset_n	: in std_logic;

		ir		: in std_logic;
		buzz_en : in std_logic;

		led_n	: out std_logic_vector(3 downto 0)
	);
end entity;

architecture controle of controle is
	signal reset : std_logic;
	signal ir_sync : std_logic;
	signal intr : std_logic;
	signal led : std_logic_vector(3 downto 0);
	signal dig : std_logic_vector(3 downto 0);
	signal command : std_logic_vector(7 downto 0);
	signal acionou : std_logic;
begin
	reset <= not reset_n;
	led_n <= not led;

	synchro_ir : entity work.synchro
	port map(
		clock => clock,
		async_i	=> ir,
		sync_o => ir_sync
	);

	ir_driver : entity work.ir
	port map(
		clock => clock,
		reset	=> reset,
		ir	=> ir_sync,
		intr => intr,
		command => command
	);

	process(clock, reset)
	begin
		if(reset = '1') then
			led <= (others => '0');
		elsif(rising_edge(clock)) then
			if(intr = '1') then
				led <= dig;
			end if;
		end if;
	end process;

	process(command)
	begin
		case command is
			when x"68" => dig <= "0001";
			when x"30" => dig <= "0010";
			when x"18" => dig <= "0011";
			when x"7A" => dig <= "0100";
			when x"10" => dig <= "0101";
			when x"38" => dig <= "0110";
			when x"5A" => dig <= "0111";
			when x"42" => dig <= "1000";
			when x"4A" => dig <= "1001";
			when x"52" => dig <= "1010";
			when x"C2" => dig <= "1111";
			when others => dig <= (others => '1');
		end case;
	

		if dig = "1111" then
			case command is
				when x"68" => dig <= "0001";
				when x"30" => dig <= "0010";
				when x"18" => dig <= "0011";
				when x"7A" => dig <= "0100";
				when x"10" => dig <= "0101";
				when x"38" => dig <= "0110";
				when x"5A" => dig <= "0111";
				when x"42" => dig <= "1000";
				when x"4A" => dig <= "1001";
				when x"52" => dig <= "1010";
				when x"C2" => dig <= "1111";
				when others => dig <= (others => '0');
			end case;
		end if;

		if command = X"C2" then
			buzz_en <= '1';
			acionou <= '1';
		elsif command = X"C2" and acionou = '1' then
			buzz_en <= '1';
		end if;

		if commmand = X"E0" then
			dig <= dig - '1';
		elsif command = X"A8" then
			dig <= dig + '1';
		end if;

	end process;

end architecture;