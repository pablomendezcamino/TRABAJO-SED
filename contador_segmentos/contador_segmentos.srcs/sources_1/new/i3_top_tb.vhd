library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i3_top_tb is
end entity i3_top_tb;

architecture behavioral of i3_top_tb is
    component i3_top is
        Port (
            NUM : in std_logic_vector(12 downto 0);
            SEGMENTS_o_s : out std_logic_vector(6 downto 0);
            SEGMENTS_t_s : out std_logic_vector(6 downto 0);
            SEGMENTS_o_m : out std_logic_vector(6 downto 0);
            SEGMENTS_t_m : out std_logic_vector(6 downto 0);
            ce : in std_logic;
            clk : in std_logic;
            up : in std_logic;
            clr_n : in std_logic;
            load: in std_logic
        );
    end component;

    signal NUM : std_logic_vector(12 downto 0);
    signal SEGMENTS_o_s : std_logic_vector(6 downto 0);
    signal SEGMENTS_t_s : std_logic_vector(6 downto 0);
    signal SEGMENTS_o_m : std_logic_vector(6 downto 0);
    signal SEGMENTS_t_m : std_logic_vector(6 downto 0);
    signal ce : std_logic;
    signal clk : std_logic := '0';
    signal up : std_logic;
    signal clr_n : std_logic;
    signal load: std_logic;

    constant clk_freq : positive := 1e6;
    constant clk_period : time := 1 sec / clk_freq;
begin

    uut : i3_top
        port map(
            NUM=>NUM,
            SEGMENTS_o_s=>segments_o_s,
            SEGMENTS_t_s=>SEGMENTS_t_s,
            SEGMENTS_o_m=>segments_o_m,
            SEGMENTS_t_m=>SEGMENTS_t_m,
            clk=>clk,
            ce=>ce,
            up=>up,
            clr_n=>clr_n,
            load=>load
        );

    clkgen: clk <= not clk after 0.5 * clk_period;
    ce <= '0' after 0.25 * clk_period, '1' after 0.75 * clk_period;
    up <= '1';
    clr_n <= '0' after 0.3 *clk_period, '1' after 0.9 * clk_period;
    load <= '0' after 0.3 * clk_period, '1' after 4 * clk_period, '0' after 5 *clk_period;
    NUM <= "0000111111001";

    assert false
    report "[SUCCESS]: simulation finished."
    severity failure;
end architecture;