LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE testbench OF testbench IS

signal clock_tb : std_logic := '0';
signal reset_tb : std_logic;

signal data_tb : std_logic_vector(3 downto 0);
signal en_tb : std_logic;

signal prime_tb   : std_logic;
signal valid_tb : std_logic;

BEGIN

    traba_1 : ENTITY work.traba_1
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
        data_tb <= "0001";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "0010";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "0011";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "0100";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "0101";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "0110";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "0111";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "1000";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "1001";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "1010";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "1011";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "1100";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "1101";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "1110";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        en_tb <= '1';
        data_tb <= "1111";
        wait for 10ns;
        en_tb <= '0';
        wait until rising_edge(valid_tb);
        assert prime_tb = '0';
        
        
    end process;

END testbench;