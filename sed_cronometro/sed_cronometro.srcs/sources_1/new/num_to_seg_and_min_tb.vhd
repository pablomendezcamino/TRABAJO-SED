library ieee;
use ieee.std_logic_1164.all;

entity num_to_seg_and_min_tb is
end entity;

architecture foo of num_to_seg_and_min_tb is
    component num_to_seg_and_min
        port(
            NUM  : in STD_LOGIC_VECTOR(12 downto 0);
            ones_sec : out STD_LOGIC_VECTOR(12 downto 0);
            tens_sec : out STD_LOGIC_VECTOR(12 downto 0);
            ones_min : out STD_LOGIC_VECTOR(12 downto 0);
            tens_min : out STD_LOGIC_VECTOR(12 downto 0)
        );
    end component num_to_seg_and_min;

    signal NUM  : STD_LOGIC_VECTOR(12 downto 0);
    signal ones_sec : STD_LOGIC_VECTOR(12 downto 0);
    signal tens_sec : STD_LOGIC_VECTOR(12 downto 0);
    signal ones_min : STD_LOGIC_VECTOR(12 downto 0);
    signal tens_min : STD_LOGIC_VECTOR(12 downto 0);
begin

uut: num_to_seg_and_min
port map (NUM=>NUM, ones_sec=>ones_sec, tens_sec=>tens_sec, ones_min=>ones_min, tens_min=>tens_min);

STIMULUS: process 
    begin
        wait for 10 ns;
        NUM <= "0111000001111";
        wait for 500 ns;
        NUM <= "0000111111001";
        wait;      
    end process;
end architecture;