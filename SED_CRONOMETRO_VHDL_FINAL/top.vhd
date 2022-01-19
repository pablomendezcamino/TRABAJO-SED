library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TOP is
    port (
        CPU_RESETN : in std_logic;                       --RESET BUTTON ,RESETS SYSTEM BTNC
        LOAD: in std_logic;                              --LOAD BUTTON BTNL
        CLK100MHZ : in std_logic;                        --CLK 100MHZ
        START : in std_logic;                            --START BUTTON ,STARTS COUNT BTNU
        STOP : in std_logic;                             --STOP BUTTON ,STOP COUNT NEGATED BTNR
        COUNT_UP : in std_logic;                         --COUNT UP/DOWN NEGATED
        COUNT_IN :in std_logic_vector(12 downto 0);      --COUNT IN
        CODE :out std_logic_vector(7 downto 0);          --DYSPLAY SELECTED
        led : out std_logic_vector(6 DOWNTO 0);          --7 SEGMENT DYSPLAY 
        led_control : out std_logic_vector(4 DOWNTO 0);   --7 SEGMENT DYSPLAY
        num_sec : out std_logic_vector(12 downto 0)      --NUMBER OF SECONDS 
    );
end top;

ARCHITECTURE STRUCTURAL OF TOP IS
    COMPONENT fsmm
        PORT (
            RESET_n : in std_logic;         --RESET BUTTON ,RESETS SYSTEM
            LOAD : in std_logic;            --LOAD BUTTON
            CLK : in std_logic;             --CLK 10MHZ
            START : in std_logic;            --START BUTTON ,STARTS COUNT
            STOP_n : in std_logic;          --STOP BUTTON ,STOP COUNT NEGATED
            SLAVE_START :out std_logic;     --FMS SLAVE INITIALIZATION 
            SLAVE_FINISH :in std_logic;     --FSM SLAVE FINALIZATION
            COUNT_UP: in std_logic;         --ON COUNT UP/OFF COUNT DOWM
            CE : out std_logic;
            led_control : OUT std_logic_vector(4 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT FSM_SLAVE
        PORT (
            CLK   : in  std_logic;
            RST_N : in  std_logic;
            start : in  std_logic;
            delay : in  unsigned(15 downto 0); 
            prescaler : in  unsigned(15 downto 0);
            DONE  : out std_logic
        );
    END COMPONENT;
    COMPONENT DEBOUNCER
        PORT (
            CLK : in std_logic;
            RST_N : in std_logic;
            button_in : in std_logic;
            pulse_out : out std_logic
        );
    END COMPONENT;
    COMPONENT DEBOUNCER_n
        PORT (
            CLK : in std_logic;
            RST_N : in std_logic;
            button_in : in std_logic;
            pulse_out : out std_logic
        );
    END COMPONENT;
    COMPONENT COUNTER
        PORT (
            ce : in std_logic;                                  --count name
            count_in : in std_logic_vector(12 downto 0);     --count_int load
            count_out : out std_logic_vector(12 downto 0);   --count out // cuenta en seg
            clk : in std_logic;                                 --clock signal // time to count
            up : in std_logic;                                  --variable count up//up'-> count down
            clr_n : in std_logic;                               --reset botton 
            load: in std_logic                                  --load flag
        );
    END COMPONENT;
    COMPONENT frec_divider
        PORT (
            clk        : in  STD_LOGIC;
            reset      : in  STD_LOGIC;
            escala     : in  STD_LOGIC_VECTOR(15 downto 0);
            preescaler : in  STD_LOGIC_VECTOR(15 downto 0);
            clk_out    : out STD_LOGIC
        );
    END COMPONENT;
    COMPONENT DECODER
        PORT (
            NUMBER : IN std_logic_vector(3 DOWNTO 0);
            led : OUT std_logic_vector(6 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT BCD_CONTROLER
        PORT (
            ce:in std_logic;
            clk :in std_logic;
            code :out std_logic_vector(7 downto 0);
            tens_min:in std_logic_vector(3 downto 0);
            ones_min:in std_logic_vector(3 downto 0);
            tens_sec:in std_logic_vector(3 downto 0);
            ones_sec:in std_logic_vector(3 downto 0);
            number_out:out std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    COMPONENT num_to_seg_and_min
        PORT (
            NUM  : in STD_LOGIC_VECTOR(12 downto 0);
            ones_sec : out STD_LOGIC_VECTOR(3 downto 0);
            tens_sec : out STD_LOGIC_VECTOR(3 downto 0);
            ones_min : out STD_LOGIC_VECTOR(3 downto 0);
            tens_min : out STD_LOGIC_VECTOR(3 downto 0)
        );
    END COMPONENT;

    signal START_deb : std_logic;
    signal RESET_deb : std_logic;
    signal LOAD_deb : std_logic;
    signal STOP_deb : std_logic;
    signal SLAVE_START : std_logic;
    signal SLAVE_FINISH : std_logic;
    signal CE : std_logic;
    signal count_out : std_logic_vector(count_in'range);
    signal ones_sec :  STD_LOGIC_VECTOR(3 downto 0);
    signal tens_sec :  STD_LOGIC_VECTOR(3 downto 0);
    signal ones_min :  STD_LOGIC_VECTOR(3 downto 0);
    signal tens_min :  STD_LOGIC_VECTOR(3 downto 0);
    signal NUMBER_OUT :  STD_LOGIC_VECTOR(3 downto 0);
    signal clk_1MHZ: std_logic;
    signal clk_100KHZ : std_logic;
    
BEGIN
--    Inst_debouncer_START: DEBOUNCER 
--    PORT MAP (
--            CLK => clk_1MHZ,
--            RST_N => '1',
--            button_in =>BTNU,
--            pulse_out => START_deb
--        );
--    Inst_debouncer_STOP: DEBOUNCER 
--    PORT MAP (
--            CLK => clk_1MHZ,
--            RST_N => '1',
--            button_in => BTNR,
--            pulse_out => STOP_deb
--        );
    Inst_debouncer_n_RESET: debouncer_n 
    PORT MAP (
            CLK => clk_100KHZ,
            RST_N => '1',
            button_in => CPU_RESETN,
            pulse_out => RESET_deb
        );
--    Inst_debouncer_LOAD: DEBOUNCER 
--    PORT MAP (
--            CLK => clk_1MHZ,
--            RST_N => '1',
--            button_in =>BTNL,
--            pulse_out => LOAD_deb
--        );
    Inst_fsm: fsmm 
    PORT MAP (
            RESET_n =>      RESET_deb ,
            LOAD =>         LOAD ,
            CLK =>          clk_100KHZ ,
            START =>        START ,
            STOP_n =>       STOP ,
            SLAVE_START =>  SLAVE_START ,
            SLAVE_FINISH => SLAVE_FINISH,
            COUNT_UP =>     COUNT_UP,
            CE =>           CE,
            led_control => led_control
        );
    Inst_FSM_SLAVE: FSM_SLAVE 
    PORT MAP (
            CLK   => clk_100KHZ,
            RST_N => RESET_deb,
            start => SLAVE_START,
            delay => "0010001111110000",     --10869 --0010101001110101 --10001111110000 --9200
            prescaler => "0010011100010000", --10000 --10011100010000
            DONE  => SLAVE_FINISH
        );
    Inst_COUNTER: COUNTER 
    PORT MAP (
            ce => CE,
            count_in => COUNT_IN,
            count_out => count_out,
            clk => clk_1MHZ,
            up => COUNT_UP,
            clr_n => RESET_deb,
            load => LOAD
        );
-- Usado en el testbench
    Inst_COUNTER_1: COUNTER
        PORT MAP (
            ce => CE,
            count_in => COUNT_IN,
            count_out => num_sec,
            clk => clk_1MHZ,
            up => COUNT_UP,
            clr_n => RESET_deb,
            load => LOAD
        );
    Inst_num_to_seg_and_min: num_to_seg_and_min 
    PORT MAP (
            NUM  => count_out,
            ones_sec => ones_sec,
            tens_sec => tens_sec,
            ones_min => ones_min,
            tens_min => tens_min
        );
        
    Inst_BCD_CONTROLER: BCD_CONTROLER 
    PORT MAP (
            ce => '1',
            clk => clk_100KHZ, --DEBERIA SER OTRO RELOJ CON DIV_FREC
            code => CODE,
            tens_min => tens_min,
            ones_min => ones_min,
            tens_sec => tens_sec,
            ones_sec => ones_sec,
            number_out => NUMBER_OUT
        );       
    Inst_DECODER: DECODER 
    PORT MAP (
            NUMBER => NUMBER_OUT,
            led => LED
        );        
    Inst_FREC_DIVIDER: FREC_DIVIDER
        PORT MAP (
            clk        => CLK100MHZ,
            reset      => '1',
            escala     => "0000000001100100",--100
            preescaler => "0000000000001010",  --10
            clk_out    => clk_100KHZ
        );        
    Inst_FREC_DIVIDER_CLK: FREC_DIVIDER
        PORT MAP (
            clk        => clk_100KHZ,
            reset      => '1',
            escala     => "0000000000001010",
            preescaler => "0000000000000001",
            clk_out    => clk_1MHZ
        );        
end structural;