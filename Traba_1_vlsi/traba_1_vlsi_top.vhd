library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity traba_1_vlsi_top is
    port(
        clock: in std_logic;
        reset_n: in std_logic;

        btn1_n: in std_logic;
        btn2_n: in std_logic;
        btn3_n: in std_logic;
        led_n: out std_logic_vector(3 downto 0);
        buzzer_o: out std_logic

    );

end traba_1_vlsi_top;

architecture traba_1_vlsi_top of traba_1_vlsi_top is

    signal btn_n_sync: std_logic;
    signal reset: std_logic;

    signal btn1_sync: std_logic;
    signal btn2_sync: std_logic;
    signal btn3_sync: std_logic;

    signal led: std_logic_vector(3 downto 0);

    signal btn1_deb : std_logic;
    signal btn2_deb : std_logic;
    signal btn3_deb : std_logic;

    signal buzzer_en : std_logic;

    signal cnt : std_logic_vector(3 downto 0);
    signal div : std_logic_vector(20 downto 0);

begin 

	cnt <= led;
	
    process(cnt)
    begin
        case cnt is 
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
        end case;
    end process;

 
    process(clock, reset)
        begin 
            if reset ='1' then 
                buzzer_en <= '0';

            elsif rising_edge(clock) then 
                if btn2_deb = '1' then 
                    buzzer_en <= '1';
                elsif btn3_deb = '1' then
                    buzzer_en <='0';
                end if;
            end if;
    end process;

    reset <= not reset_n;
    btn1_sync <= not btn_n_sync;
    led_n <= not led;
    
    synchro1_btn : entity work.synchro
    port map(
        clock => clock,
        async_i => btn1_n,
        sync_o => btn_n_sync
    );

    synchro2_btn : entity work.synchro
    port map(
        clock => clock,
        async_i => btn2_n,
        sync_o => btn_n_sync
    );

    synchro3_btn : entity work.synchro
    port map(
        clock => clock,
        async_i => btn3_n,
        sync_o => btn_n_sync
    );

    traba_1_vlsi : entity work.traba_1_vlsi
    port map(
        clock => clock,
        reset => reset,
        btn1 => btn1_deb,
        led => led
    );

    debounce_1 : entity work.debounce
    port map(
        clock => clock,
        reset => reset,
        bounce_i => btn1_sync,
        debounce_o => btn1_deb
    );

    debounce_2 : entity work.debounce
    port map(
        clock => clock,
        reset => reset,
        bounce_i => btn2_sync,
        debounce_o => btn2_deb
    );

    debounce_3 : entity work.debounce
    port map(
        clock => clock,
        reset => reset,
        bounce_i => btn3_sync,
        debounce_o => btn3_deb
    );

    buzzer : entity work.buzzer
    port map(
        clock => clock,
        reset => reset,
        en => buzzer_en,
        buzz => buzzer_o,
        in_div => div
    );

end architecture;
