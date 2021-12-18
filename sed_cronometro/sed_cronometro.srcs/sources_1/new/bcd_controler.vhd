-- Design Name: 
-- Module Name: bcd_controler - Behavioral
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

entity bcd_controler is
    generic(order: positive);
    Port ( clk :in std_logic;
         code :in std_logic_vector(7 downto 0)
        );
end bcd_controler;

architecture Behavioral of bcd_controler is

begin


end Behavioral;
