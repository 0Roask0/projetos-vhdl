library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;


entity traba_2 is
    port(
        clock : in std_logic;
        reset : in std_logic;

        data_i : in std_logic_vector(13 downto 0);
        en_i : in std_logic;
        
        prime_o : out std_logic;
        valid_o : out std_logic
    );
end entity;


architecture traba_2 of traba_2 is

    type stateFSM is (aguard, calc, result);
    signal FSM : stateFSM;
    signal num: std_logic_vector(13 downto 0);
    signal cnt : std_logic_vector(13 downto 0);
    signal req_i : std_logic;
    signal quocient_o : std_logic_vector(13 downto 0);
    signal remainder_o : std_logic_vector(13 downto 0);
    signal ack_o : std_logic;

begin

    process(clock, reset)
    begin
        if reset = '1' then
            valid_o <= '0';
            prime_o <= '0';
        elsif rising_edge(clock) then
        
            case FSM is
                when aguard =>
                    if en_i ='0' then
                        FSM <= aguard;
                    else 
                        cnt <= "00000000000011";
                        num <= data_i;
                        valid_o <= '0';
                        prime_o <= '0';
                        FSM <= calc;
                    end if;
                when calc =>
                    if cnt < num  then
                            req_i <= '1';
                            FSM <= result;
                    else
                        valid_o <= '1';
                        prime_o <= '1';    
                        FSM <= aguard; 
                    end if;
                when result => 
                        IF ack_o = '1' then
                            req_i <= '0';
                            if remainder_o = "00000000000000" then
                                prime_o <= '0';
                                valid_o <= '1';
                                FSM <= aguard;

                            else 
                                prime_o <= '1';
                                valid_o <= '1';
                                FSM <= aguard;
                            end if;
                        else 
                            cnt <= cnt + '1';
                        end if;
            end case;
        end if;
    end process;

    divisor : entity work.divisor
    port map(
        clock => clock,
        reset => reset,
        dividend_i => data_i,
        divisor_i => cnt,
        req_i => req_i,
        quocient_o => quocient_o,
        remainder_o => remainder_o,
        ack_o => ack_o
    );
end architecture;


    
