library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;


entity divisor is
    port(
        clock : in std_logic;
        reset: in std_logic;

        dividend_i : in std_logic_vector(13 downto 0);
        divisor_i : in std_logic_vector(13 downto 0);
        req_i : in std_logic;

        quocient_o : out std_logic_vector(13 downto 0);
        remainder_o : out std_logic_vector(13 downto 0);
        ack_o : out std_logic

    );
end entity;

architecture divisor of divisor is
    type stateFSM is (espera, teste, fim);
    signal FSM: stateFSM;
    signal divisor : std_logic_vector(13 downto 0);
    signal dividendo : std_logic_vector(13 downto 0);
    signal quociente : std_logic_vector(13 downto 0);
    signal acki : std_logic;

begin
    
    process(clock, reset)
    begin
        if  reset = '1' then
            dividendo  <= (others => '0');
            divisor   <= (others => '0');
            quociente <= (others => '0');
            quocient_o <= (others => '0');
            remainder_o <= (others => '0');
            ack_o <= '0';
        elsif rising_edge(clock) then
            case FSM is
                when espera =>
                    if req_i = '1' then
                        divisor <= divisor_i;
                        dividendo <= dividend_i;
                        FSM <= teste;
                    else 
                        FSM <= espera;
                    end if;
                when teste =>
                    if divisor <= dividendo then
                        dividendo <= dividendo - divisor;
                        quociente <= quociente + '1';
                    else 
                        remainder_o <= dividendo;
                        quocient_o <= quociente;
                        ack_o<= '1';
                        FSM <= fim;
                    end if;
                when fim =>
                    if req_i = '0' then
                        ack_o <= '0';
                        FSM <= espera;
                    end if;
                end case;
        end if;
    end process;
end architecture;