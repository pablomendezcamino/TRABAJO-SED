library ieee;
use ieee.std_logic_1164.all;

entity num_to_seg_and_min_tb is
end entity;

architecture foo of num_to_seg_and_min_tb is
component num_to_seg_and_min
port(
    X   : in STD_LOGIC_VECTOR(15 downto 0);
    Y   : in STD_LOGIC_VECTOR(15 downto 0);
    R   : out STD_LOGIC_VECTOR(15 downto 0);
    S   : out STD_LOGIC_VECTOR(15 downto 0)
);
end component num_to_seg_and_min;

    signal X   : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    signal Y   : STD_LOGIC_VECTOR(15 downto 0) := "0000000000111100";
    signal R   : STD_LOGIC_VECTOR(15 downto 0);
    signal S   : STD_LOGIC_VECTOR(15 downto 0);
begin

uut: num_to_seg_and_min
port map (X => X, Y => Y, R => R, S => S);

STIMULUS:
    process 
    begin
        wait for 10 ns;
        X <= "0000000110010000";
        wait for 500 ns;
        X <= "0000000111111001";
        wait;      
    end process;
end architecture;