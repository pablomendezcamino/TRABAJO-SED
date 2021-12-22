
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity bcd_controler is
    Port (
        ce:in std_logic;
        clk :in std_logic;
        code :out std_logic_vector(7 downto 0);
        tens_min:in std_logic_vector(3 downto 0);
        ones_min:in std_logic_vector(3 downto 0);
        tens_sec:in std_logic_vector(3 downto 0);
        ones_sec:in std_logic_vector(3 downto 0);
        number_out:out std_logic_vector(3 downto 0)

    );
end bcd_controler;

architecture Behavioral of bcd_controler is
    signal code_t : std_logic_vector(code'range);
begin
    process(clk)
        variable count :positive :=3;
    begin
        if rising_edge(clk) then
            if ce='1' then
                code_t<="00000000";
                code_t(count)<='1';
                count:=count+1;
                if count>7 then
                    count:=3;
                end if;
            end if;
        end if;       
    end process;
code <=  code_t;

    WITH code_t SELECT
 number_out<= ones_sec when "00010000",
        tens_sec when "00100000",
        ones_min when "01000000",
        tens_min when "10000000",
        "1111"   when others;

end Behavioral;
