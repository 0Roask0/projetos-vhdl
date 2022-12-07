LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE testbench OF testbench IS

signal clock_tb : std_logic := '0';
signal reset_tb : std_logic;

signal data_tb : std_logic_vector(13 downto 0) := "00000000000000";
signal en_tb : std_logic := '0';

signal prime_tb   : std_logic;
signal valid_tb : std_logic;

BEGIN

    traba_2 : ENTITY work.traba_2
        PORT MAP(
            clock => clock_tb,
            reset => reset_tb,
            data_i => data_tb,
            en_i => en_tb,
            prime_o => prime_tb,
            valid_o => valid_tb
        );
    
    

    reset_tb <= '1', '0' after 100ns;
    clock_tb <=  not clock_tb after 5 ns;
    process
    begin
        wait for 100 ns;
        en_tb <= '1';
        data_tb <= "00000000000101";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "00000000000111";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "00000000001001";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "00001000001011";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        assert prime_tb = '0';
        
        
    end process;

END testbench;