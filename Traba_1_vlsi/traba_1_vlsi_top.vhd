library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity traba_1_vlsi_top is
    port(
        clock: in std_logic;
        reset_n: in std_logic;

        btn_n: in std_logic;
        led_n: out std_logic_vector(3 downto 0)

    );

end traba_1_vlsi_top;

architecture traba_1_vlsi_top of traba_1_vlsi_top is

    signal btn_n_sync: std_logic;
    signal reset: std_logic;
    signal btn_sync: std_logic;
    signal btn2_sync: std_logic;
    signal btn3_sync: std_logic;
    signal led: std_logic_vector(3 downto 0);
    signal btn_deb : std_logic;
    signal btn2_deb : std_logic;
    signal btn3_deb : std_logic;

    signal buzzer_en : std_logic;
    signal ver : std_logic;

    signal cnt : std_logic_vector(15 downto 0);
    signal div : std_logic_vector(20 downto 0);

begin 
    process(cnt)
    begin
        case cnt is 
        when "0000" => div <= "100110001001011010000"
        when "0001" => div <= "11110100001001000000"
        when "0010" => div <= "11011011101110100000"
        when "0011" => div <= "11000011010100000000"
        when "0100" => div <= "10101010111001100000"
        when "0101" => div <= "10010010011111000000"
        when "0110" => div <= "01111010000100100000"
        when "0111" => div <= "01100001101010000000"
        when "1000" => div <= "01001001001111100000"
        when "1001" => div <= "00110000110101000000"
        when "1010" => div <= "00011000011010100000"
        when "1011" => div <= "00001100001101010000"
        when "1100" => div <= "00000110000110101000"
        when "1101" => div <= "00000010011100010000"
        when "1110" => div <= "00000001001110001000"   
        when "1111" => div <= "00000000010011100010" 
    end case;
begin
    reset <= not reset_n;
    btn_sync <= not btn_n_sync;
    led_n <= not led;

    ver <= '0' when led = "1111" else
        btn_deb;
    
    buzz <= 1 when btn2 = '1';
    
    synchro_btn : entity work.synchro
    port map(
        clock => clock,
        async_i => btn_n,
        sync_o => btn_n_sync
    );

    traba_1_vlsi : entity work.traba_1_vlsi
    port map(
        clock => clock,
        reset => reset,
        btn => btn_sync,
        btn2 => btn2_sync,
        btn3 => btn3_sync,
        led => led
    );

    debounce : entity work.debounce
    port map(
        clock => clock,
        reset => reset,
        bounce_i => btn_sync,
        debounce_o => btn_deb
    );

    debounce : entity work.debounce
    port map(
        clock => clock,
        reset => reset,
        bounce_i => btn_sync,
        debounce_o => btn2_deb
    );

    debounce : entity work.debounce
    port map(
        clock => clock,
        reset => reset,
        bounce_i => btn_sync,
        debounce_o => btn3_deb
    );

    buzzer : entity work.buzzer
    port map(
        clock => clock,
        reset => reset,
        en => buzzer_en,
        buzz => buzzer_o
    );

end architecture;
