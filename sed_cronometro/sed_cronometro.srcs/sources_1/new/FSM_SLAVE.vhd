----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.12.2021 19:12:14
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Implement a timer
entity FSM_SLAVE is
  port (
    CLK   : in  std_logic;
    RST_N : in  std_logic;
    start : in  std_logic;
    delay : in  unsigned(15 downto 0); --
    prescaler : in  unsigned(15 downto 0);
    DONE  : out std_logic
  );
end FSM_SLAVE;

architecture BEHAVIORAL of FSM_SLAVE is
  signal count : unsigned(delay'range);
  signal count_i : unsigned(delay'range);
begin
  DONE <= '1' when count = 0 else '0';
  process (CLK, RST_N)
  begin
    if RST_N = '0' then
      count <= (others => '0');
    elsif rising_edge(CLK) then
      if start = '1' then
        count <= prescaler;
        count_i <= delay;
      elsif count /= 0 then
        if count_i /= 0 then
          count_i <= count_i - 1;
        elsif count_i = 0 then 
          count_i<= delay;
          count <= count -1;    
        end if;       
      end if;
    end if;
  end process;
end BEHAVIORAL;
