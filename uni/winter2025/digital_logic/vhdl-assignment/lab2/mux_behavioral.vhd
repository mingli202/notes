library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity mux_behavioral is
  port (
    a : in    std_logic;
    b : in    std_logic;
    s : in    std_logic;
    y : out   std_logic
  );
end entity mux_behavioral;

architecture mux of mux_behavioral is

begin

  with S select Y <=
    A when '0',
    B when '1',
    'X' when others;

end architecture mux;
