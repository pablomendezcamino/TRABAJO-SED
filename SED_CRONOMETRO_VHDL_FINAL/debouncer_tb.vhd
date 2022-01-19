library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity debouncer_tb is
end debouncer_tb;

architecture behavioral of debouncer_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component debouncer
        port(
            CLK : in  std_logic;
            RST_N : in  std_logic;
            button_in : in  std_logic;
            pulse_out : out  std_logic
        );
    end component;
    
    --Inputs
    signal CLK : std_logic := '0';
    signal RST_N : std_logic := '0';
    signal button_in : std_logic := '0';

    --Outputs
    signal pulse_out : std_logic;

    -- Clock period definitions
    constant clk_freq : positive := 1000;
    constant clk_period : time := 1*sec/clk_freq;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: debouncer
        port map( CLK => CLK, RST_N => RST_N, button_in => button_in, pulse_out => pulse_out );

    -- Clock process definitions
    CLK <= not CLK after 0.5 * clk_period;

    -- Stimulus process
    stim_proc: process
    begin
        button_in <= '0';
        RST_N <= '0';
        wait for 1 * clk_period;
        RST_N <= '1';
        wait for clk_period * 1;
        button_in <= '1';   wait for clk_period * 2;
        button_in <= '0';   wait for clk_period * 1;
        button_in <= '1';   wait for clk_period * 1;
        button_in <= '0';   wait for clk_period * 2;
        button_in <= '1';   wait for clk_period * 1;
        button_in <= '0';
        wait;
    end process;
end architecture;