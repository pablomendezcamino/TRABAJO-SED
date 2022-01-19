library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity frec_divider is
    PORT (
        clk        : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        escala     : in  STD_LOGIC_VECTOR(15 downto 0);
        preescaler : in  STD_LOGIC_VECTOR(15 downto 0);
        clk_out    : out STD_LOGIC
    );
end frec_divider;

architecture Behavioral of frec_divider is

    signal contador    : integer range 0 to 10_000_000;
    signal escala_num  : UNSIGNED(31 downto 0) := (others => '0');

begin
    escala_num <= unsigned(escala) * unsigned(preescaler);

    divisor_frecuencia: process (clk, reset) 
    begin
        if (reset = '0') then
            clk_out <= '0';
            contador <= 0;
        elsif rising_edge(clk) then
            if (contador = escala_num) then
                contador <= 0;
            else
                if (contador < escala_num / 2) then
                    clk_out <= '1';
                else
                    clk_out <= '0';
                end if;
                contador <= contador + 1;
            end if;
        end if;
    end process;
end Behavioral;