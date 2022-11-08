library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;


entity controle is
    port(
        clock : in std_logic;
        reset : in std_logic;
 
        buzzer_en : in std_logic;
        buzzer_o : out std_logic

        
    );
end entity;


architecture controle of controle is

    type stateFSM is (aguard, apita, espera, fim);
    signal FSM : stateFSM;
    signal cnt : std_logic_vector(24 downto 0);
    signal div : std_logic_vector(20 downto 0);
    signal led :  std_logic_vector(3 downto 0);

    signal disparou : std_logic;
    signal prime_o : std_logic;
    signal valid_o : std_logic;
    signal en_i : std_logic;
    

begin


    process(clock, reset)
    begin
        if reset = '1' then
            FSM <= aguard;
        elsif rising_edge(clock) then
            
            case FSM is
                when aguard =>
                    if valid_o = '0' then
                        FSM <= aguard;
                    else 
                        --buzzer_en <= '1';
                        -- disparou <= '1';
                        FSM <= apita;
                    end if;
                
                when apita =>
                    if prime_o = '0' and cnt = "1011111010111100001000000" and disparou = '0' then
                        FSM <= espera;
                    else
                        cnt <= cnt + '1';
                    end if;
                    if prime_o = '0' and cnt = "1011111010111100001000000" and disparou = '1' then
                        FSM <= fim;

                    elsif prime_o = '1' and cnt = "1011111010111100001000000" then
                        FSM <= fim;
                    end if;
                
                when espera =>
                    if cnt = "1011111010111100001000000" then
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
        prime_o => prime_o,
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