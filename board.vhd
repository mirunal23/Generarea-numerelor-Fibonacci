library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fib_on_board is
    Port (clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          led : out std_logic_vector (15 downto 0);
          seg : out STD_LOGIC_VECTOR (0 to 6);
          dp : out STD_LOGIC;
          an : out STD_LOGIC_VECTOR (3 downto 0));
end fib_on_board;

architecture Behavioral of fib_on_board is

component Fibo is
        Port (clk : in STD_LOGIC;
              rst : in STD_LOGIC;
              fibo_out : out STD_LOGIC_VECTOR (13 downto 0);
              thousand : out integer range 0 to 9;
              hundred : out integer range 0 to 9;
              ten : out integer range 0 to 9;
              unit : out integer range 0 to 9);
    end component Fibo;

component bcd is
    generic(N: positive := 16);
     port( clk, reset: in std_logic;
           binary_in: in std_logic_vector(N-1 downto 0);
           bcd0, bcd1, bcd2, bcd3: out std_logic_vector(3 downto 0));
end component bcd ;
     
signal bcd0, bcd1, bcd2, bcd3 : STD_LOGIC_VECTOR(3 downto 0);

component driver7_seg is
        Port (clk : in STD_LOGIC; --100MHz board clock input
              Din : in STD_LOGIC_VECTOR (15 downto 0); --16 bit binary data for 4 displays
              an : out STD_LOGIC_VECTOR (3 downto 0); --anode outputs selecting individual displays 3 to 0
              seg : out STD_LOGIC_VECTOR (0 to 6); -- cathode outputs for selecting LED-s in each display
              dp_in : in STD_LOGIC_VECTOR (3 downto 0); --decimal point input values
              dp_out : out STD_LOGIC; --selected decimal point sent to cathodes
              rst : in STD_LOGIC); --global reset  
end component driver7_seg;

signal fibo_out : STD_LOGIC_VECTOR (13 downto 0);
signal clk1Hz : STD_LOGIC;
signal mii, sute, zeci, unitati, unit, ten, thousand, hundred : integer range 0 to 9;
signal counting_done, conversion_ok : std_logic := '0';
signal an_local : STD_LOGIC_VECTOR(3 downto 0);
signal din : STD_LOGIC_VECTOR(15 downto 0);

begin

process(clk, rst)
    variable q : integer := 0;
    begin
        if rst = '1' then
            q := 0;
            clk1Hz <= '0';
           elsif rising_edge(clk) then
              if q = 10**8 - 1 then
                 q := 0;
                 clk1Hz <= '1';
              else
                  q := q + 1;
                  clk1Hz <= '0';
              end if;
        end if;
end process;

u_fib : Fibo port map (clk => clk1Hz,
                       rst => rst,
                       fibo_out => fibo_out); --,

counting_process: process (clk)
    begin
        if rising_edge(clk) then
                if not(std_logic_vector(to_unsigned(1000*mii + 100*sute + 10*zeci + unitati, 14)) = fibo_out) then
                    if unitati = 9 then
                       unitati <= 0;
                        if zeci = 9 then
                           zeci <= 0;
                            if sute = 9 then
                               sute <= 0;
                               if mii = 9 then
                                  mii <= 0;
                               else
                                  mii <= mii + 1;
                               end if;  
                            else
                                sute <= sute + 1;  
                            end if;
                       else
                            zeci <= zeci + 1;
                       end if;
                  else 
                       unitati <= unitati + 1;  
                  end if;
            else
                  unit <= unitati;
                  ten <= zeci;
                  hundred <= sute;
                  thousand <= mii;
                  
            end if;
end if;

din <= std_logic_vector(to_unsigned(mii, 4)) &
       std_logic_vector(to_unsigned(sute, 4)) &
       std_logic_vector(to_unsigned(zeci, 4)) &
       std_logic_vector(to_unsigned(unitati, 4));

end process;

u_driver7seg : driver7_seg port map ( clk => clk,
                                      Din => din,
                                      an => an_local,
                                      seg => seg,
                                      dp_in => "0000",
                                      dp_out => dp,
                                      rst => rst);
   
an <= an_local;-- when conversion_ok = '1' else "1111";
        
led <= "00" & fibo_out;        
        
        
  u_bcd : bcd port map ( clk => clk,
                         reset => rst,
                         binary_in => din,
                         bcd0 => bcd0,
                         bcd1 => bcd1,
                         bcd2 => bcd2,
                         bcd3 => bcd3);
end Behavioral;
