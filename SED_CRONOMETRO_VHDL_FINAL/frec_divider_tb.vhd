library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity freq_divider_tb is
end freq_divider_tb;

architecture behavioral of freq_divider_tb is

    component frec_divider is
        PORT (
            clk        : in  STD_LOGIC;
            reset      : in  STD_LOGIC;
            escala     : in  STD_LOGIC_VECTOR(15 downto 0);
            preescaler : in  STD_LOGIC_VECTOR(15 downto 0);
            clk_out    : out STD_LOGIC
        );
    end component frec_divider;
    --Inputs 
    signal clk : std_logic := '0';
    signal Reset : std_logic := '0';
    signal escala : std_logic_vector(15 downto 0);
    signal preescaler : std_logic_vector(15 downto 0);
    --Outputs
    signal clk_out : std_logic;
    -- Clock period definitions
    constant clk_period : time := 10 ns;
begin

    uut: frec_divider
        port map (
            clk => clk,
            Reset => Reset,
            escala => escala,
            preescaler => preescaler,
            clk_out => clk_out
        );
    -- Clock process definitions
    clock_process :process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    stim_proc: process
    begin
        wait for 0.25* clk_period;
        Reset <= '0';
        escala <= (others => '0');
        preescaler <= (others => '0');
        wait for 0.75 *clk_period;
        Reset <= '1';
        escala     <= "0000001111101000";
        preescaler <= "0000000001100100";
        wait;
    end process;

    assert false
    report "[SUCCESS]: simulation finished."
    severity failure;

end architecture;