library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity freq_divider_tb is
end freq_divider_tb;

architecture behavioral of freq_divider_tb is

    component frec_divider Is

        generic( FMHZ: Natural := 8 ); -- FMHZ genérico 8MHz por defecto 
        port(
            clock_FMHZ : IN STD_LOGIC; -- Señal de reloj externa. 
            Reset : IN Std_Logic; -- Reset del Módulo 
            clock_1Hz : OUT STD_LOGIC -- Salida a 1Hz.
        );
    end component frec_divider;

    --Inputs
    signal clock_FMHZ : std_logic := '0';
    signal Reset : std_logic := '0';

    --Outputs
    signal clock_1Hz : std_logic;
    -- Clock period definitions
    constant clock_period : time := 10 ns;
    constant adjclk_period : time := 10 ns;
begin

    -- Instantiate the Unit Under Test (UUT)
    uut: frec_divider
        port map (
            clock_FMHZ => clock_FMHZ,
            Reset => Reset,
            clock_1Hz => clock_1Hz
        );

    -- Clock process definitions
    clock_process :process
    begin
        clock_FMHZ <= '0';
        wait for clock_period / 2;
        clock_FMHZ <= '1';
        wait for clock_period / 2;
    end process;

    stim_proc: process
    begin
        wait for 50 ns;
        Reset <= '0';
        wait for 100 ns;
        Reset <= '1';
        wait for clock_period * 10;
        -- insert stimulus here 
        wait;
    end process;

    assert false
    report "[SUCCESS]: simulation finished."
    severity failure;

end;