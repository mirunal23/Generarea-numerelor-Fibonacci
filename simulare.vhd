library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity fib_test is
--  Port ( );
end fib_test;

architecture Behavioral of fib_test is

component  Fibo is
Port ( clk : in STD_LOGIC;
rst : in STD_LOGIC;
fibo_out : out STD_LOGIC_VECTOR (13 downto 0);
thousand : out integer range 0 to 9;
hundred  : out integer range 0 to 9;
ten : out integer range 0 to 9;
unit : out integer range 0 to 9);

end component ;

signal clk, rst : std_logic;
signal fibo_out :std_logic_vector (13 downto 0);
signal thousand , hundred , ten ,unit : integer range 0 to 9;

begin

uut : Fibo port map (clk => clk, 
                            rst =>rst, 
                            fibo_out=>fibo_out ,
                            thousand =>thousand ,
                            hundred =>hundred  ,
                            ten=>ten, 
                            unit=>unit);

rst <= '1' after 0 ns, '0' after 1 ns; 

process
begin
clk <= '0'; wait for 5 ns;
clk <= '1'; wait for 5 ns;


end process;
end Behavioral;
