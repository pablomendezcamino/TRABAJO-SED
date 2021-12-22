library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity frec_divider is
    Port (
        entrada: in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        salida : out STD_LOGIC
    );
end frec_divider;
 
architecture Behavioral of frec_divider is
    signal temporal: STD_LOGIC;
    signal contador: integer range 0 to 6 := 0;
begin
    divisor_frecuencia: process (reset, entrada) begin
        if (reset = '1') then
            temporal <= '0';
            contador <= 0;
        elsif rising_edge(entrada) then
            if (contador = 6) then
                temporal <= NOT(temporal);
                contador <= 0;
            else
                contador <= contador +1;
            end if;
        end if;
    end process;
    salida <= temporal;
end Behavioral;