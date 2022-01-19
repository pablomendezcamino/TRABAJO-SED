library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    generic(width: positive := 12);
    port (
        ce : in std_logic;                                  --count name
        count_in : in std_logic_vector(width downto 0);     --count_int load
        count_out : out std_logic_vector(width downto 0);   --count out // cuenta en seg
        clk : in std_logic;                                 --clock signal // time to count
        up : in std_logic;                                  --variable count up//up'-> count down
        clr_n : in std_logic;                               --reset botton 
        load: in std_logic                                  --load flag
    );
end counter;

architecture Behavioral of counter is
    signal count_i: unsigned(count_out'range);
begin
    cntr: process(clk, clr_n, load)
    begin
        if(clr_n) = '0' then
            count_i <= to_unsigned(0,count_out'length);
        elsif load = '1' then
            count_i <= unsigned(count_in);
        elsif rising_edge(clk) then
            if ce= '1' then              
                if up = '1' then
                    count_i <= count_i + 1;
                else
                    count_i <= count_i - 1;
                end if;
            end if;
        end if;
    end process;
    count_out <= std_logic_vector(count_i);
end Behavioral;