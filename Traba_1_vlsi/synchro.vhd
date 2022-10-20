library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity synchro is
    port(
        clock: in std_logic;
        async_i: in std_logic;

        sync_o: out std_logic

    );

end synchro;

architecture synchro of synchro is

    signal sig : std_logic;
    
begin

    process(clock)
    begin
        
        if rising_edge(clock) then
            sig <= async_i;
            sync_o <= sig;
            

        end if;
    end process;
end architecture;
