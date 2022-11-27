library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity traba_2_vlsi_top is
    port(
        clock: in std_logic;
        reset_n: in std_logic;

        ir		: in std_logic;
		  
		buzzer_o : out std_logic;

        led_n: out std_logic_vector(3 downto 0)

    );

end traba_2_vlsi_top;

architecture traba_2_vlsi_top of traba_2_vlsi_top is

    signal reset: std_logic;

    signal led: std_logic_vector(3 downto 0);

    signal buzzer_en : std_logic;
    signal ver : std_logic_vector(3 downto 0);

    signal cnt : std_logic_vector(3 downto 0);
    signal div : std_logic_vector(20 downto 0);
	signal ir_sync : std_logic;
	signal intr : std_logic;
	signal command : std_logic_vector(7 downto 0);
    signal par : std_logic;
begin
	reset <= not reset_n;
	led_n <= not led;

	process(command)
	begin
		case command is
			when x"68" => cnt <= "0000";
			when x"30" => cnt <= "0001";
			when x"18" => cnt <= "0010";
			when x"7A" => cnt <= "0011";
			when x"10" => cnt <= "0100";
			when x"38" => cnt <= "0101";
			when x"5A" => cnt <= "0110";
			when x"42" => cnt <= "0111";
			when x"4A" => cnt <= "1000";
			when x"52" => cnt <= "1001";
			when others => cnt <= "1111";
		end case;
    end process;
	 
    process(clock, reset)
    begin
		if(reset = '1') then
			led <= "0000";
		elsif(rising_edge(clock)) then
			if(intr = '1') then
				if cnt = "1111" then 
						case command is
							when x"E0" => 
								led <= led - '1';
							when x"A8" => 
								led <= led + '1';
							when x"C2" => 
								buzzer_en <= not buzzer_en;
							when others => led <= "1111";
						end case;
					else
						led <= cnt;
				end if;
			end if;
		end if;
	end process;

    process(led)
    begin
        case led is 
        when "0000" => div <= "100110001001011010000";
        when "0001" => div <= "011110100001001000000";
        when "0010" => div <= "011011011101110100000";
        when "0011" => div <= "011000011010100000000";
        when "0100" => div <= "010101010111001100000";
        when "0101" => div <= "010010010011111000000";
        when "0110" => div <= "001111010000100100000";
        when "0111" => div <= "001100001101010000000";
        when "1000" => div <= "001001001001111100000";
        when "1001" => div <= "000110000110101000000";
        when "1010" => div <= "000011000011010100000";
        when "1011" => div <= "000001100001101010000";
        when "1100" => div <= "000000110000110101000";
        when "1101" => div <= "000000010011100010000";
        when "1110" => div <= "000000001001110001000";   
        when "1111" => div <= "000000000010011100010"; 
		when others => div <= (others => '0');
    end case;
	end process;

    buzzer : entity work.buzzer
    port map(
        clock => clock,
        reset => reset,
        en => buzzer_en,
        buzz => buzzer_o,
        in_div => div
    );

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
end architecture;