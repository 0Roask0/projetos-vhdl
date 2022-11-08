library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;


entity traba_1 is
    port(
        clock : in std_logic;
        reset : in std_logic;

        led : in std_logic_vector(3 downto 0);
        buzzer_o : out std_logic

        
    );
end entity;


architecture traba_1 of traba_1 is

    type stateFSM is (aguard, apita, espera, fim);
    signal FSM : stateFSM;
    signal cnt : std_logic_vector(24 downto 0);
    signal buzzer_en : std_logic;
    signal div : std_logic_vector(20 downto 0);

    signal disparou : std_logic;
    signal prime_o : std_logic;
    signal valid_o : std_logic;
    signal en_i : std_logic;
    

begin


    process(clock, reset)
    begin
        if reset = '1' then
            valid_o <= '0';
            prime_o <= '0';
            FSM <= aguard;
        elsif rising_edge(clock) then
            
            case FSM is
                when aguard =>
                    if valid_o = '0' then
                        FSM <= aguard;
                        prime_o <= '0';
                    else 
                        --buzzer_en <= '1';
                        -- disparou <= '1';
                        FSM <= apita;
                    end if;
                
                when apita =>
                    if primo_o = '0' and cnt = "25000000" and disparou = '0' then
                        buzzer_en <= '1';
                        FSM <= espera;
                    else
                        cnt <= cnt + '1';
                    end if;
                    if primo_o = '0' and cnt = "25000000" and disparou = '1' then
                        FSM <= fim;

                    elsif primo_o = '1' and cnt = "25000000"
                        FSM <= fim;
                    end if;
                
                when espera =>
                    if cnt = "25000000" then
                        disparou <= '1';
                        FSM <= apita;
                    else
                        cnt <= cnt + '1';
                    end if;

                when fim =>
                    if valid_o = '0' then
                        FSM <= aguard;
                    else 
                        FSM <= apita;
                    end if;
            end case;
        end if;  
    end process;

    traba_2 : entity work.traba_2
    port map(
        clock => clock,
        reset => reset,
        data_i => led,
        en_i => en_i,
        prime_o => prime_o
        valid_o => valid_o
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