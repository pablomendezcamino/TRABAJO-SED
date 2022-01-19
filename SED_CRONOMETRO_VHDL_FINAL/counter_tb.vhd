library ieee;
use ieee.std_logic_1164.all;

entity counter_tb is
end counter_tb;

architecture tb of counter_tb is

    component counter
        port (ce        : in std_logic;
             count_in  : in std_logic_vector (12 downto 0);
             count_out : out std_logic_vector (12 downto 0);
             clk       : in std_logic;
             up        : in std_logic;
             clr_n     : in std_logic;
             load      : in std_logic);
    end component;

    signal ce        : std_logic;
    signal count_in  : std_logic_vector (12 downto 0);
    signal count_out : std_logic_vector (12 downto 0);
    signal clk       : std_logic :='0';
    signal up        : std_logic;
    signal clr_n     : std_logic;
    signal load      : std_logic;

    constant clk_freq : positive := 10_000_000;
    constant clk_period : time := 1*sec/clk_freq;

begin

    dut : counter
        port map (ce        => ce,
                 count_in  => count_in,
                 count_out => count_out,
                 clk       => clk,
                 up        => up,
                 clr_n     => clr_n,
                 load      => load
                 );

    -- Clock generation
    CLK <= not CLK after 0.5 * clk_period;

    --  EDIT: Replace YOURCLOCKSIGNAL below by the name of your clock as I haven't guessed it
    --  YOURCLOCKSIGNAL <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        count_in <= (others => '0');
        clr_n <= '1';
        load <= '0';
        --binary_read
        ce<='1';
        up <= '1';
        clr_n <= '1';
        wait for 0.5 * clk_period;
        load <= '1';
        count_in <="0000000000010";
        wait for 0.5 * clk_period;
        load <= '0';
        wait for 3 * clk_period;
        clr_n <= '0';
        wait for 0.5 * clk_period;
        clr_n <= '1';
        -- EDIT Add stimuli here
        wait for 100 * clk_period;
    end process;

    assert false
    report "[SUCCESS]: simulation finished."
    severity failure;
end tb;
