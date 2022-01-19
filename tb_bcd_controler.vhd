library ieee;
use ieee.std_logic_1164.all;

entity tb_bcd_controler is
end tb_bcd_controler;

architecture tb of tb_bcd_controler is

    component bcd_controler
        port (ce         : in std_logic;
              clk        : in std_logic;
              code       : out std_logic_vector (7 downto 0);
              tens_min   : in std_logic_vector (3 downto 0);
              ones_min   : in std_logic_vector (3 downto 0);
              tens_sec   : in std_logic_vector (3 downto 0);
              ones_sec   : in std_logic_vector (3 downto 0);
              number_out : out std_logic_vector (3 downto 0));
    end component;

    signal ce         : std_logic;
    signal clk        : std_logic :='0';
    signal code       : std_logic_vector (7 downto 0);
    signal tens_min   : std_logic_vector (3 downto 0);
    signal ones_min   : std_logic_vector (3 downto 0);
    signal tens_sec   : std_logic_vector (3 downto 0);
    signal ones_sec   : std_logic_vector (3 downto 0);
    signal number_out : std_logic_vector (3 downto 0);

    constant clk_freq : positive := 10_000_000;
    constant clk_period : time := 1*sec/clk_freq;
begin

    dut : bcd_controler
    port map (ce         => ce,
              clk        => clk,
              code       => code,
              tens_min   => tens_min,
              ones_min   => ones_min,
              tens_sec   => tens_sec,
              ones_sec   => ones_sec,
              number_out => number_out);

    -- Clock generation
    
    CLK <= not CLK after 0.5 * clk_period;

    --  EDIT: Replace YOURCLOCKSIGNAL below by the name of your clock as I haven't guessed it
    --  YOURCLOCKSIGNAL <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as bcd_controle
        ce <= '1';
        tens_min <= (others => '0');
        ones_min <= (others => '0');
        tens_sec <= (others => '0');
        ones_sec <= (others => '0');
        wait for 0.5* clk_period;
        tens_min <= X"5";
        ones_min <= X"4";
        tens_sec <= X"3";
        ones_sec <= X"1";
        wait for 7* clk_period;
        tens_min <= X"4";
        ones_min <= X"3";
        tens_sec <= X"1";
        ones_sec <= X"5";
        -- EDIT Add stimuli here
        wait for 100 * clk_period;
    end process;
    
    assert false
    report "[SUCCESS]: simulation finished."
    severity failure;
end architecture;
