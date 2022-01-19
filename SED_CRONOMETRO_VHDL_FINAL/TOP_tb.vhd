library ieee;
use ieee.std_logic_1164.all;

entity tb_TOP is
end tb_TOP;

architecture tb of tb_TOP is

    component top
        port (
            CPU_RESETN      : in std_logic;
            LOAD            : in std_logic;
            CLK100MHZ       : in std_logic;
            START           : in std_logic;
            STOP            : in std_logic;
            COUNT_UP        : in std_logic;
            COUNT_IN        : in std_logic_vector (12 downto 0);
            CODE            : out std_logic_vector (7 downto 0);
            led             : out std_logic_vector (6 downto 0);
            led_control     : out std_logic_vector(4 DOWNTO 0);
            num_sec         : out std_logic_vector(12 downto 0)
        );
    end component;

    signal CPU_RESETN      : std_logic;
    signal LOAD            : std_logic;
    signal CLK100MHZ       : std_logic := '0';
    signal START           : std_logic;
    signal STOP            : std_logic;
    signal COUNT_UP        : std_logic;
    signal COUNT_IN        : std_logic_vector (12 downto 0) := "0000000000000";
    signal CODE            : std_logic_vector (7 downto 0) := "00000000";
    signal led             : std_logic_vector (6 downto 0);
    signal led_control     : std_logic_vector(4 DOWNTO 0);
    signal num_sec         : std_logic_vector(12 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbSimEnded : std_logic := '0';

begin

    dut : TOP
        port map (
            CPU_RESETN      => CPU_RESETN,
            LOAD      => LOAD,
            CLK100MHZ => CLK100MHZ,
            START      => START,
            STOP      => STOP,
            COUNT_UP  => COUNT_UP,
            COUNT_IN  => COUNT_IN,
            CODE      => CODE,
            led       => led,
            led_control => led_control,
            num_sec => num_sec
        );

    -- Clock generation
    genclk : CLK100MHZ <= not CLK100MHZ after 0.5 * TbPeriod when TbSimEnded /= '1' else '0';

    -- RESET => BTNC, LOAD => BTNL, START => BTNU, STOP => BTNR.

    reset_proc : process
    begin
        --FUNCTION RESET IMPLEMENTATION
        wait for 1 * TbPeriod;
        CPU_RESETN <= '1';
--        wait for 5100000 * TbPeriod;
--        CPU_RESETN <= '0';
        wait until CPU_RESETN = '0';
        assert led_control = "11111"
        report "RESET malfunction"
        severity FAILURE;
    end process;

    load_proc: process
    begin
        --FUNCTION LOAD IMPLEMENTATION
        wait for 1 * TbPeriod;
        LOAD <= '1';
        wait for 10 * TbPeriod;
        LOAD <= '0';
        wait for 20 * TbPeriod;
        LOAD <= '1';
        COUNT_IN <= "0000000000000";
        wait until LOAD = '0';
        wait for 0.1 * TbPeriod;
        assert led_control = "00001"
        report "LOAD malfunction"
        severity FAILURE;
    end process;

    start_proc: process
    begin
        --FUNCTION START IMPLEMENTATION
        wait for 0.1 * TbPeriod;
        START <= '1';
        wait for 1 * TbPeriod;
        START <= '0';
        wait for 100000 * TbPeriod;
        START <= '1';
        COUNT_IN <= "0000000000000";
        wait until START = '0';
        assert led_control = "00010"
        report "START malfunction"
        severity FAILURE;
    end process;

    stop_proc: process
    begin
        --FUNCTION STOP IMPEMENTATION
        STOP <= '1' after 1 * TbPeriod;
        COUNT_IN <= "0000000000000";
        wait until CLK100MHZ = '0';
        wait for 0.1 * TbPeriod;
        wait until STOP = '0';
        assert led_control = "11111"
        report "STOP malfunction"
        severity FAILURE;
    end process;

    count_in_proc: process
    begin
        --FUNCTION COUNT_IN IMPLEMENTATION
--        wait for 0.1 * TbPeriod;
        COUNT_IN <= (others => '0');
        wait for 10 * TbPeriod;
        COUNT_IN <= "0000000010100";
    end process;

    count_up_proc: process
    begin
        --FUNCTION COUNT_UP IMPLEMENATION
        wait for 1 * TbPeriod;
        COUNT_UP <= '1';
        wait until COUNT_IN = "0000000010100";
        assert num_sec = "0000000010101"
        report "COUNT_UP malfunction"
        severity FAILURE;
        wait for 100000000 * TbPeriod;
    end process;

    assert FALSE
    report "[SUCCESS] : simulation finished"
    severity FAILURE;
end tb;