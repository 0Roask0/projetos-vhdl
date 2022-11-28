library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;


entity controle is
    port(
        clock : in std_logic;
<<<<<<< HEAD
        reset : in std_logic;

        prime_o :  in std_logic;
		valid_o :  in std_logic;

        buzzer_en : out std_logic
        
=======
        reset : in std_logic
>>>>>>> 6d39288bb1924b2e86b197142d2c523030e9cd4d
    );
end entity;


architecture controle of controle is
<<<<<<< HEAD
    type stateFSM is (aguard, apita, espera, fim);
    signal FSM : stateFSM;
=======

    type stateFSM is (aguard, apita, espera, fim);
    signal FSM : stateFSM;
    signal cnt : std_logic_vector(24 downto 0);
    signal div : std_logic_vector(20 downto 0);
    signal led :  std_logic_vector(3 downto 0);

    signal buzzer_en : std_logic;
    signal buzzer_o :  std_logic;
>>>>>>> 6d39288bb1924b2e86b197142d2c523030e9cd4d
    signal disparou : std_logic;
    signal cnt :  std_logic_vector(24 downto 0);
    signal tempo :  std_logic_vector(24 downto 0); 

   
begin
    tempo <= ("1011111010111100001000000");

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
<<<<<<< HEAD
                    if prime_o = '0' and cnt = tempo and disparou = '0' then
=======
                    if prime_o = '0' and cnt = "1011111010111100001000000" and disparou = '0' then
>>>>>>> 6d39288bb1924b2e86b197142d2c523030e9cd4d
                        buzzer_en <= '1';
                        FSM <= espera;
                    else
                        cnt <= cnt + '1';
                    end if;
<<<<<<< HEAD
                    if prime_o = '0' and cnt = tempo and disparou = '1' then
                        FSM <= fim;
                    elsif prime_o = '1' and cnt = tempo then
=======
                    if prime_o = '0' and cnt = "1011111010111100001000000" and disparou = '1' then
                        buzzer_en <= '1';
                        FSM <= fim;

                    elsif prime_o = '1' and cnt = "1011111010111100001000000" then
>>>>>>> 6d39288bb1924b2e86b197142d2c523030e9cd4d
                        FSM <= fim;
                    end if;
                
                when espera =>
<<<<<<< HEAD
                    if cnt = tempo then
=======
                    if cnt = "1011111010111100001000000" then
>>>>>>> 6d39288bb1924b2e86b197142d2c523030e9cd4d
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

<<<<<<< HEAD
=======
    traba_2 : entity work.traba_2
    port map(
        clock => clock,
        reset => reset,
        data_i => led,
        en_i => en_i,
        prime_o => prime_o,
        valid_o => valid_o
    );
>>>>>>> 6d39288bb1924b2e86b197142d2c523030e9cd4d

end architecture;