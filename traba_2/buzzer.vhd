library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity buzzer is
    port(
        clock : in std_logic;
        reset : is std_logic;

        in_div : in std_logic_vector( 20 downto 0 );
        en : in std_logic;
        buzz : out std_logic
    );
end buzzer;

architecture buzzer of buzzer is
    signal cnt : std_logic_vector(20 downto 0);
    signal square : std_logic;

begin
    buzz <= en and square;
    process (clock, reset)
    begin
        if reset = '1' then
            cnt <= (others => '0');
        elsif rising_edge(clock) then
            if cnt = in_div then
                cnt <= (others => '0');
            else 
                cnt <= cnt + '1'; 
            end if;              
        end if;
    end process;
    process (clock, reset)
    begin
        if reset = '1' then
            square <= '0';
        elsif rising_edge(clock) then
            if cnt = (cnt'range => '0') then
                square <= not square;
            end if;
        end if;
    end process;
end buzzer;
