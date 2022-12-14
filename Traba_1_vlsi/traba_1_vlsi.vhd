library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity traba_1_vlsi is
    port(
        clock: in std_logic;
        reset: in std_logic;

        btn1: in std_logic;

        led: out std_logic_vector(3 downto 0)

    );

end traba_1_vlsi;

architecture traba_1_vlsi of traba_1_vlsi is

    signal pressed : std_logic;
    signal cnt : std_logic_vector(3 downto 0);
    
begin
    led <= cnt;
    process(clock, reset)
    begin
        if reset = '1' then
            cnt <= (others => '0');
            pressed <= '0';
        elsif rising_edge(clock) then
            if btn1 = '1' and pressed = '0' then
                cnt <= cnt +'1';
                pressed<= '1';
            elsif btn1 = '0' and pressed = '1' then
                pressed <= '0';
            end if;

        end if;
    end process;
end architecture;


                



