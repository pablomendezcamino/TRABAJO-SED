library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i3_top is
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
end i3_top;

architecture behabioral of i3_top is

    component bin2_segments is
        port (
            BCDVAL   : in  std_logic_vector(3 downto 0);
            SEGMENTS : out std_logic_vector(6 downto 0)
        );
    end component;

    component num_to_min_and_seg is
        port(
            NUM  : in STD_LOGIC_VECTOR(12 downto 0);
            ones_sec : out STD_LOGIC_VECTOR(3 downto 0);
            tens_sec : out STD_LOGIC_VECTOR(3 downto 0);
            ones_min : out STD_LOGIC_VECTOR(3 downto 0);
            tens_min : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component count is
        port (
            ce : in std_logic;                                  --count name
            count_in : in std_logic_vector(12 downto 0);   --count_int load
            count_out : out std_logic_vector(12 downto 0); --count out // cuenta en seg
            clk : in std_logic;                                 --clock signal // time to count
            up : in std_logic;                                  --variable count up//up'-> count down
            clr_n : in std_logic;                               --reset botton 
            load: in std_logic                                  --load flag
        );
    end component;

    signal NUM_out : STD_LOGIC_VECTOR(12 downto 0);
    signal ones_sec : STD_LOGIC_VECTOR(3 downto 0);
    signal tens_sec : STD_LOGIC_VECTOR(3 downto 0);
    signal ones_min : STD_LOGIC_VECTOR(3 downto 0);
    signal tens_min : STD_LOGIC_VECTOR(3 downto 0);

begin

    count1: count
        port map(ce=>ce,count_in=>NUM,count_out=>NUM_out,clk=>clk,up=>up,clr_n=>clr_n,load=>load);
        
     min_seg: num_to_min_and_seg
     port map(NUM=>NUM,ones_sec=>ones_sec,tens_sec=>tens_sec,ones_min=>ones_min,tens_min=>tens_min);
     
     segments1 : bin2_segments 
     port map(BCDVAL=>ones_sec,SEGMENTS=>SEGMENTS_o_s);
     
      segments2 : bin2_segments 
     port map(BCDVAL=>tens_sec,SEGMENTS=>SEGMENTS_t_s);
     
      segments3 : bin2_segments 
     port map(BCDVAL=>ones_min,SEGMENTS=>SEGMENTS_o_m);
     
      segments4 : bin2_segments 
     port map(BCDVAL=>tens_min,SEGMENTS=>SEGMENTS_t_m);

end architecture;
