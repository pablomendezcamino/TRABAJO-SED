----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2021 20:49:15
-- Design Name: 
-- Module Name: debuoncer_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer_tb is
end debouncer_tb;

architecture Behavioral of debouncer_tb is
component debouncer is
    Port (
        DATA: in std_logic;
        CLK : in std_logic;
        OP_DATA : out std_logic
    );
end component;

        signal DATA: std_logic := '0';
        signal CLK : std_logic := '0';
        signal OP_DATA : std_logic;
        constant clk_freq : positive := 1000;
        constant clk_period : time := 1*sec/clk_freq;
begin
uut: debouncer
port map( DATA => DATA, CLK => CLK, OP_DATA => OP_DATA);

CLK <= not CLK after 0.5 * clk_period;
DATA <= not DATA after 0.75 * clk_period;

end architecture Behavioral;