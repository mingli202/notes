library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity mux_structural is
  port (
    a : in    std_logic;
    b : in    std_logic;
    s : in    std_logic;
    y : out   std_logic
  );
end entity mux_structural;

architecture mux of mux_structural is

begin

  y <= (a and (not s)) or (b and s);

end architecture mux;
