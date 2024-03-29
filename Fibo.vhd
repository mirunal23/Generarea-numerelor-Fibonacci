library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity Fibo is
  Port ( clk      : in STD_LOGIC;
         rst      : in STD_LOGIC;
         fibo_out : out STD_LOGIC_VECTOR (13 downto 0);
         thousand : out integer range 0 to 9;
         hundred  : out integer range 0 to 9;
         ten      : out integer range 0 to 9;
         unit     : out integer range 0 to 9);
end Fibo;

architecture Behavioral of Fibo is

signal fib1, fib2  : STD_LOGIC_VECTOR (13 downto 0);
signal unitati, zeci, sute, mii : integer range 0 to 9;
signal counting_done : std_logic := '0';
constant fibo_max : integer := 9999;
  
begin
  p1: process (clk, rst)
      begin
         if rst = '1' then
             fib1 <= "00000000000000";
             fib2 <= "00000000000001";
         elsif rising_edge(clk) then
             if fib2 < fibo_max and counting_done = '0' then
                fib2 <= fib1 + fib2;
                fib1 <= fib2;
             else
                fib1 <= "00000000000000";
                fib2 <= "00000000000001";
             end if;
         end if;
  end process p1;

fibo_out <= fib1;

end Behavioral;
