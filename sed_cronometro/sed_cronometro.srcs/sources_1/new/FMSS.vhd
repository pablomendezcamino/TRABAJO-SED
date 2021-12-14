library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FMSS is
    port(
        CLK: in std_logic;
        RST_N: in std_logic;
        -- Handshake signals
        Done: out std_logic;
        Start: out std_logic;
        Delay: out unsigned(3 downto 0)
    );
end entity FMSS;

architecture behavioral of FMSS is
    signal count: unsigned(Delay'range);
begin
    process(CLK, RST_N)
    begin
        if RST_N = '0' then
            count <= (others => '0');
            Done <= '1';
        elsif rising_edge(CLK) then
            if Start = '1' then
                count <= Delay;
                Done <= '0';
            elsif count /= 0 then
                count <= count - 1;
            else
                Done <= '1';
            end if;
        end if;
    end process;
end architecture behavioral;



