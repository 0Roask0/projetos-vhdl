library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;


entity traba_2 is
    port(
        clock : in std_logic;
        reset : in std_logic;

        data_i : in std_logic_vector(3 downto 0);
        en_i : in std_logic;
        
        prime_o : out std_logic;
        valid_o : out std_logic
    );
end entity;


architecture traba_2 of traba_2 is

    type stateFSM is (aguard, calc);
    signal FSM : stateFSM;
    signal num: std_logic_vector(3 downto 0);
    signal cnt : std_logic_vector(3 downto 0);

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
                    if en_i ='0' then
                        FSM <= aguard;
                    else 
                        FSM <= calc;
                        valid_o <= '0';
                        prime_o <= '0';
                        cnt <= x"2";
                        num <= data_i;
                    end if;

                when calc =>
                    if cnt < num then
                        if std_logic_vector(unsigned(num) mod unsigned(cnt)) = "0000" then
                            prime_o <= '0';
                            valid_o <= '1';
                            FSM <= aguard;
                        else 
                            cnt <= cnt + '1';
                        end if;
                    else 
                        prime_o <= '1';
                        valid_o <= '1';
                        FSM <= aguard;
                    end if;
            end case;
        end if;
    end process;
end architecture;


    
