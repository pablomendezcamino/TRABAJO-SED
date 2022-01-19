library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity num_to_seg_and_min is
    port(
        NUM  : in STD_LOGIC_VECTOR(12 downto 0);
        ones_sec : out STD_LOGIC_VECTOR(3 downto 0);
        tens_sec : out STD_LOGIC_VECTOR(3 downto 0);
        ones_min : out STD_LOGIC_VECTOR(3 downto 0);
        tens_min : out STD_LOGIC_VECTOR(3 downto 0)
    );
end num_to_seg_and_min;

architecture Behavioral of num_to_seg_and_min is
    constant div : std_logic_vector(12 downto 0) := "0000000111100";
    constant dec : std_logic_vector(12 downto 0) := "0000000001010";
    signal SEC  : STD_LOGIC_VECTOR(12 downto 0);
    signal MIN  : STD_LOGIC_VECTOR(12 downto 0);
    signal tens_sec_i : std_logic_vector(12 downto 0);
    signal tens_min_i : std_logic_vector(12 downto 0);
    signal ones_sec_i : std_logic_vector(12 downto 0);
    signal ones_min_i : std_logic_vector(12 downto 0);
        
begin

    MIN <= std_logic_vector(to_signed(to_integer(signed(NUM)/signed(div)),13));
    SEC <= std_logic_vector(to_signed(to_integer(signed(NUM)-signed(div)*signed(MIN)),13));
    tens_sec_i <= std_logic_vector(to_signed(to_integer(signed(SEC)/signed(dec)),13));
    ones_sec_i <= std_logic_vector(to_signed(to_integer(signed(SEC)-signed(dec)*signed(tens_sec_i)),13));
    tens_min_i <= std_logic_vector(to_signed(to_integer(signed(MIN)/signed(dec)),13));
    ones_min_i <= std_logic_vector(to_signed(to_integer(signed(MIN)-signed(dec)*signed(tens_min_i)),13));
    
    ones_sec <= ones_sec_i(3 downto 0);
    ones_min <= ones_min_i(3 downto 0);
    tens_sec <= tens_sec_i(3 downto 0);
    tens_min <= tens_min_i(3 downto 0);
end Behavioral;