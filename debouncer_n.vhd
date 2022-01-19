library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity debouncer_n is
    port(
        CLK : in std_logic;
        RST_N : in std_logic;
        button_in : in std_logic;
        pulse_out : out std_logic
    );
end debouncer_n;

architecture behavioral of debouncer_n is

    --the below constants decide the working parameters.
    --the higher this is, the more longer time the user has to press the button.
    constant COUNT_MAX : integer := 60;
    --set it '1' if the button creates a high pulse when its pressed, otherwise '0'.
    constant BTN_ACTIVE : std_logic := '0';

    signal count : integer := 0;
    type state_type is (idle,wait_time); --state machine
    signal state : state_type := idle;

begin

    process(RST_N,CLK)
    begin
        if(RST_N = '0') then
            state <= idle;
            pulse_out <= '1';
        elsif(rising_edge(CLK)) then
            case (state) is
                when idle =>
                    if(button_in = BTN_ACTIVE) then
                        state <= wait_time;
                    else
                        state <= idle; -- wait until button is pressed.
                    end if;
                    pulse_out <= '1';
                when wait_time =>
                    if(count = COUNT_MAX) then
                        count <= 0;
                        if(button_in = BTN_ACTIVE) then
                            pulse_out <= '0';
                        end if;
                        state <= idle;
                    else
                        count <= count + 1;
                    end if;
            end case;
        end if;
    end process;

end architecture behavioral;
