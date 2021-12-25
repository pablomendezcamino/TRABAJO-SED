Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity frec_divider is
    generic( FMHZ: positive := 8 ); 
    port(
        clock_FMHZ : in std_logic; -- Señal de reloj externa. 
        Reset : in std_logic; -- Reset del Módulo 
        clock_1Hz : out std_logic -- Salida a 1Hz.
    );
end frec_divider;

architecture behavioral of frec_divider is

    Signal count_1Mhz : std_logic_vector(4 downto 0); 
    Signal Clock_1MHz : std_logic;
    Signal Count_1Hz : integer range 0 to 10_000_000;

begin

    process 
    begin
        -- Divisor por FMHZ
        wait until rising_edge(clock_FMHZ);
        if Reset = '1' then
            if count_1Mhz < (FMHZ + 1) then
                count_1Mhz <= count_1Mhz + 1;
            else
                count_1Mhz <= "00000";
            end if;
            if count_1Mhz < FMHZ / 2 then
                clock_1MHz <= '0';
            else
                clock_1MHz <= '1';
            end if;
        else Count_1Mhz <= "00000";
        end if;
    end process;
    -- Divisor por 1000000

    process ( clock_1Mhz, Reset)
    begin
        if Reset = '0' then
            Count_1Hz <= 0;
        else
            if clock_1Mhz'event and clock_1Mhz = '1' then
                if count_1Hz < 10_000_000 then
                    count_1Hz <= count_1Hz + 1;
                else
                    count_1Hz <= 0;
                end if;
                if count_1Hz < 5_000_000 then
                    clock_1Hz <= '0';
                else
                    clock_1Hz <= '1';
                end if;
            end if;
        end if;
    end process;
end behavioral;