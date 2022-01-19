library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity fsmm is  --MASTER FMS
    generic(width: positive := 5);
    port (
        RESET_n : in std_logic;         --RESET BUTTON ,RESETS SYSTEM
        LOAD : in std_logic;          --LOAD BUTTON
        CLK : in std_logic;           --CLK 100MHZ
        START : in std_logic;         --START BUTTON ,STARTS COUNT
        STOP_n : in std_logic;        --STOP BUTTON ,STOP COUNT NEGATED
        SLAVE_START :out std_logic;   --FMS SLAVE INITIALIZATION 
        SLAVE_FINISH :in std_logic;   --FSM SLAVE FINALIZATION
        COUNT_UP: in std_logic;       --ON COUNT UP/OFF COUNT DOWN
        CE : out std_logic;
        led_control : out std_logic_vector(width - 1 DOWNTO 0)   --7 SEGMENT DYSPLAY 
    );
end fsmm;
architecture behavioral of fsmm is
    type STATES is (S0, S1, S2, S3, S4,S5);  --STATES RESET, LOAD, START, SLAVE_START, INIT_COUNT, WAIT
    signal current_state: STATES := S0;
    signal next_state: STATES;
begin
    state_register: process (RESET_n, LOAD, CLK)
    begin
        if RESET_n = '0' then
            current_state <= S0;
        end if;
        if LOAD = '1' then
            current_state <= S1;
        elsif rising_edge(clk)then
            current_state <= next_state;
        end if;
    end process;
    
    nextstate_decod: process (START, LOAD, STOP_n, SLAVE_FINISH, current_state)
    begin
        next_state <= current_state;
        case current_state is
            when S0 =>
                if LOAD = '1' then
                    next_state <= S1;
                end if;
            when S1 =>
                if START = '1' then
                    next_state <= S2;
                end if;
            when S2 =>
                next_state <= S3;
            when S3 =>
                if SLAVE_FINISH = '1' then
                    next_state <= S4;
                end if;
            when S4 =>
                next_state <= S5;
            when S5 =>
                if STOP_n = '0' then
                    next_state <= S3;
                end if;
            when others =>
                next_state <= S0;
        end case;
    end process;
    
     --STATES RESET(S0), LOAD(S1), START(S2), SLAVE_START(S3), INIT_COUNT(S4), WAIT(S5)
     
    output_decod: process (current_state)
    begin
    SLAVE_START <= '0';
    led_control<= "00000";
        case current_state is
            when S0 =>
                ce <= '0';
                led_control<= "11111";
            when S1 =>
                ce <= '0';
                led_control<= "00001";
            when S2 =>
                ce <= '0';
                led_control<= "00010";
            when S3 =>
                SLAVE_START <= '1';
                ce <= '0';
                led_control<= "00100";
            when S4 =>
                ce <= '1';
                led_control<= "01000";
            when S5 =>
                ce <= '0';
                led_control<= "10000";
            when others =>
                ce <= '0';
        end case;
    end process;
end behavioral;