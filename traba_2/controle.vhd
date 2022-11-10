library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;


entity controle is
    port(
        clock : in std_logic;
        reset : in std_logic;

        prime_o :  in std_logic;
		valid_o :  in std_logic;

        buzzer_en : out std_logic
        
    );
end entity;


architecture controle of controle is
    type stateFSM is (aguard, apita, espera, fim);
    signal FSM : stateFSM;
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
                    if prime_o = '0' and cnt = tempo and disparou = '0' then
                        buzzer_en <= '1';
                        FSM <= espera;
                    else
                        cnt <= cnt + '1';
                    end if;
                    if prime_o = '0' and cnt = tempo and disparou = '1' then
                        FSM <= fim;
                    elsif prime_o = '1' and cnt = tempo then
                        FSM <= fim;
                    end if;
                
                when espera =>
                    if cnt = tempo then
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


end architecture;