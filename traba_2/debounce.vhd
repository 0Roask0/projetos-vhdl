library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity debounce is
    port(
        clock: in std_logic;
        reset: in std_logic;

        bounce_i : in std_logic;
        debounce_o: out std_logic
    );

end debounce;

architecture debounce of debounce is

    signal timer : std_logic_vector(21 downto 0);
    signal state : std_logic;

begin
    debounce_o <= state;
    process(clock, reset)
    begin
        if reset = '1' then 
            timer <= (others => '0');
            state <= '0';
        elsif rising_edge(clock) then
            if bounce_i /= state and timer = x"0" then
                state <= bounce_i;
                timer <= (0 => '1', others => '0');
            elsif timer /= x"0" then
                timer <= timer + '1';
            end if;
        end if;
    end process;
end architecture;
