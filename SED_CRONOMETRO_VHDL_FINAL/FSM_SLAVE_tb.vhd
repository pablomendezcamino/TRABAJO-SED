----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2021 19:04:10
-- Design Name: 
-- Module Name: FSM_SLAVE - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_SLAVE_tb is
end entity;

architecture behavioral of FSM_SLAVE_tb is
component FSM_SLAVE
    port(
    CLK   : in  std_logic;
    RST_N : in  std_logic;
    start : in  std_logic;
    delay : in  unsigned(3 downto 0);
    DONE  : out std_logic
    );
end component;

    signal CLK :std_logic := '0';
    signal RST_N : std_logic;
    signal DONE : std_logic;
    signal start : std_logic := '0';
    signal delay : unsigned(3 downto 0);
    
    constant clk_freq : positive := 1000;
    constant clk_period : time := 1*sec/clk_freq;
    
    subtype t is unsigned(3 downto 0);
    type t_vector is array(natural range <>) of t;
    constant v: t_vector := ( "0000", "0001", "0010", "0100", "1000" );    
begin

uut: FSM_SLAVE
port map(CLK => CLK, RST_N => RST_N, Done => Done, start => start, delay => delay);

CLK <= not CLK after 0.5 * clk_period;
RST_N <= '0' after 0.25 * clk_period, '1' after 0.75 * clk_period;

start <= not start after 0.75 * clk_period;

process (CLK, RST_N)
        subtype i_t is integer range v'range;
        variable i: i_t;
    begin
        if RST_N = '0' then
            delay <= (others => '0');
        end if;
        if rising_edge(clk) then
            if start = '1' then 
                i := v'low;
            elsif i < v'high then
                i := i + 1;
            else
                i := v'low;
            end if;
        end if;
        delay <= v(i);
    end process;
end architecture;