library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity top is
	port(
		clk_i  : in std_logic;
		rst_ni : in std_logic;

		seg_no  : out std_logic_vector(7 downto 0);
		sel_no  : out std_logic_vector(3 downto 0)
	);
end entity;

architecture rtl of top is
	signal seg0 : std_logic_vector(6 downto 0);
	signal seg1 : std_logic_vector(6 downto 0);
	signal seg2 : std_logic_vector(6 downto 0);
	signal seg3 : std_logic_vector(6 downto 0);

	-- SSS.d = 10 Hz: 50.000.000 / 10 = 5.000.000: log2 5.000.000 = 23
	signal cntr : std_logic_vector(22 downto 0);

	signal d    : std_logic_vector(3 downto 0); 
	signal s0   : std_logic_vector(3 downto 0);
	signal s1   : std_logic_vector(3 downto 0);
	signal s2   : std_logic_vector(3 downto 0);

	signal enable : std_logic_vector(3 downto 0);
begin

	process(s2, s1)
	begin
		if(s2 /= (s2'range => '0')) then
			enable <= "1111";
		elsif(s1 /= (s1'range => '0')) then
			enable <= "0111";
		else
			enable <= "0011";
		end if;
	end process;

	process(clk_i, rst_ni)
	begin
		if(rst_ni = '0') then
			cntr <= (others => '0');
		elsif(rising_edge(clk_i)) then
			if(cntr = x"4C4B40") then
				cntr <= (others => '0');
			else
				cntr <= cntr + '1';
			end if;
		end if;
	end process;

	process(clk_i, rst_ni)
	begin
		if(rst_ni = '0') then
			d  <= (others => '0');
			s0 <= (others => '0');
			s1 <= (others => '0');
			s2 <= (others => '0');
		elsif(rising_edge(clk_i)) then
			if(cntr = x"4C4B40") then
				if(d = x"9") then
					d <= (others => '0');
					if(s0 = x"9") then
						s0 <= (others => '0');
						if(s1 = x"9") then
							s1 <= (others => '0');
							if(s2 = x"9") then
								s2 <= (others => '0');
							else
								s2 <= s2 + '1';
							end if;
						else
							s1 <= s1 + '1';
						end if;
					else
						s0 <= s0 + '1';
					end if;
				else
					d <= d + '1';
				end if;
			end if;
		end if;
	end process;

	dec0 : entity work.SevenSegmentDecoder
	port map(
		bcd_i => d,
		seg_o => seg0
	);

	dec1 : entity work.SevenSegmentDecoder
	port map(
		bcd_i => s0,
		seg_o => seg1
	);

	dec2 : entity work.SevenSegmentDecoder
	port map(
		bcd_i => s1,
		seg_o => seg2
	);

	dec3 : entity work.SevenSegmentDecoder
	port map(
		bcd_i => s2,
		seg_o => seg3
	);

	driver : entity work.SevenSegmentDriver
	port map(
		clk_i  => clk_i,
		rst_ni => rst_ni,
		en_i   => enable,
		dots_i => "0010",
		seg0_i => seg0,
		seg1_i => seg1,
		seg2_i => seg2,
		seg3_i => seg3,
		seg_no => seg_no,
		sel_no => sel_no 
	);

end architecture;
