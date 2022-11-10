library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;


entity traba_2_top is
    port(
        clock: in std_logic;
        reset_n: in std_logic;

        btn1_n: in std_logic;
        btn2_n: in std_logic;
        btn3_n: in std_logic;

        led_n: out std_logic_vector(3 downto 0)
    );
end entity;


architecture traba_2_top of traba_2_top is

    signal btn1_n_sync: std_logic;
    signal btn2_n_sync: std_logic;
    signal btn3_n_sync: std_logic;
    
    signal reset: std_logic;

    signal btn1_sync: std_logic;
    signal btn2_sync: std_logic;
    signal btn3_sync: std_logic;

    signal led: std_logic_vector(3 downto 0);

    signal btn1_deb : std_logic;
    signal btn2_deb : std_logic;
    signal btn3_deb : std_logic;

    signal buzzer_en : std_logic;
    signal buzzer_o: std_logic;
    
    signal prime_o : std_logic;
    signal valid_o : std_logic;
    signal en_i : std_logic;

    signal blockbtn1 : std_logic;
    signal blockbtn2 : std_logic;
    signal blockbtn3 : std_logic;

    signal pressed : std_logic;
    signal div : std_logic_vector(20 downto 0);
    signal cnt : std_logic_vector(24 downto 0);
    signal num: std_logic_vector(3 downto 0);

begin
    reset <= not reset_n;
    btn1_sync <= not btn1_n_sync;
    btn2_sync <= not btn2_n_sync;
    btn3_sync <= not btn3_n_sync;
    led_n <= not led;



    process(clock, reset)
    begin
        if reset = '1' then 
            pressed <= '0';
            led <= (others => '0');
        elsif rising_edge(clock) then
            if btn1_deb = '1' and pressed = '0' then
                led <= led + '1';
                pressed<= '1';
            elsif btn1_deb = '0' and pressed = '1' then
                led <= led;
			else
                pressed <= '0';
            end if;
            if btn2_deb = '1' and pressed = '0' then
                led <= led - '1';
                pressed<= '1';
            elsif btn2_deb = '0' and pressed = '1' then
                led <= led;
			else
                pressed <= '0';
            end if;
            if btn3_deb = '1' and pressed = '0' then
                en_i <= '1';
                pressed<= '1';
            elsif btn3_deb = '0' and pressed = '1' then
                pressed <= '0';
                led <= led;
            end if;
        end if;  
    end process;

    
    synchro1_btn : entity work.synchro
    port map(
        clock => clock,
        async_i => btn1_n,
        sync_o => btn1_n_sync
    );

    synchro2_btn : entity work.synchro
    port map(
        clock => clock,
        async_i => btn2_n,
        sync_o => btn2_n_sync
    );

    synchro3_btn : entity work.synchro
    port map(
        clock => clock,
        async_i => btn3_n,
        sync_o => btn3_n_sync
    );

    traba_2 : entity work.traba_2
    port map(
        clock => clock,
        reset => reset,
        data_i => led,
        en_i => en_i,
        prime_o => prime_o,
        valid_o => valid_o
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
    controle : entity work.controle
    port map(
        clock => clock,
        reset => reset,
        buzzer_en => buzzer_en,
		prime_o => prime_o,
		valid_o => valid_o 
    );
end architecture;
