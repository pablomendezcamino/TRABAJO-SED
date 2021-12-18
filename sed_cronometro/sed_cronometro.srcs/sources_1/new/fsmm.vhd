library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity fsmm is  --MASTER FMS
    generic(width: positive :=16);
    port (
        RESET : in std_logic;         --RESET BUTTON ,RESETS SYSTEM
        LOAD : in std_logic;          --LOAD BUTTON
        CLK : in std_logic;           --CLK 10MHZ
        START : in std_logic;         --START BUTTON ,STARTS COUNT
        STOP_n : in std_logic;          --STOP BUTTON ,STOP COUNT NEGATED
        SLAVE_START :out std_logic;   --FMS SLAVE INITIALIZATION 
        SLAVE_FINISH :in std_logic;   --FSM SLAVE FINALIZATION
        COUNT_UP: in std_logic;       --ON COUNT UP/OFF COUNT DOWM
        CE : out std_logic
    );
end fsmm;
architecture behavioral of fsmm is
    type STATES is (S0, S1, S2, S3, S4); --STATES RESET,LOAD,INIT_COUNT, FIN_COUNT
    signal current_state: STATES := S0;
    signal next_state: STATES;
begin
    state_register: process (RESET, CLK)
    begin
        if RESET = '0' then
            next_state <= S0;
        elsif rising_edge(clk)then
            current_state<=next_state;
        end if;
    end process;
    nextstate_decod: process (START,SLAVE_START,SLAVE_FINISH, current_state)
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
                if SLAVE_FINISH = '1' then
                    next_state <= S3;
                end if;
            when S3 =>
                next_state <= S4;
            when S4 =>
                if STOP_n = '1' then
                    next_state <= S3;
                end if;
            when others =>
                next_state <= S0;
        end case;
    end process;
    output_decod: process (current_state)
    begin
        case current_state is
            when S0 =>
                ce <= '0';
            when S1 =>
            when S2 =>
                ce <= '1';
            when S3 =>
                SLAVE_START<= '1';
                ce <= '1';
            when S4 =>
                ce <= '1';
            when others =>
                ce <= '0';
        end case;
    end process;
end behavioral;