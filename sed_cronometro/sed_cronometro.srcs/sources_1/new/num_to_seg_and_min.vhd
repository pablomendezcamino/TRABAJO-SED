----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.12.2021 19:55:06
-- Design Name: 
-- Module Name: num_to_seg_and_min - Behavioral
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

library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity num_to_seg_and_min is
port(
    X   : in STD_LOGIC_VECTOR(15 downto 0);
    Y   : in STD_LOGIC_VECTOR(15 downto 0);
    R   : out STD_LOGIC_VECTOR(15 downto 0);
    S   : out STD_LOGIC_VECTOR(15 downto 0)
);
end num_to_seg_and_min;

architecture Behavioral of num_to_seg_and_min is
signal SEC_i: std_logic_vector(X'range);
begin
SEC_i <= std_logic_vector(to_signed(to_integer(signed(X) / signed(Y)),16));
S <= std_logic_vector(to_signed(to_integer(signed(X)- signed(Y) * signed(SEC_i)),16));
R <= SEC_i;
end Behavioral;
