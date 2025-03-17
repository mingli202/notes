library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity circular_barrel_shifter_behavioral is
  port (
    x   : in    std_logic_vector(3 downto 0);
    sel : in    std_logic_vector(1 downto 0);
    y   : out   std_logic_vector(3 downto 0)
  );
end entity circular_barrel_shifter_behavioral;

architecture circular_barrel_shifter of circular_barrel_shifter_behavioral is
  component mux_behavioral is
    port (
      a : in    std_logic;
      b : in    std_logic;
      s : in    std_logic;
      y : out   std_logic
    );
  end component mux_behavioral;

  signal m1 : std_logic;
  signal m2 : std_logic;
  signal m3 : std_logic;
  signal m4 : std_logic;

begin
  i1 : component mux_behavioral port map (x(0), x(2), sel(1), m1);
  i2 : component mux_behavioral port map (x(1), x(3), sel(1), m2);
  i3 : component mux_behavioral port map (x(2), x(0), sel(1), m3);
  i4 : component mux_behavioral port map (x(3), x(1), sel(1), m4);

  i5 : component mux_behavioral port map (m1, m4, sel(0), y(0));
  i6 : component mux_behavioral port map (m2, m1, sel(0), y(1));
  i7 : component mux_behavioral port map (m3, m2, sel(0), y(2));
  i8 : component mux_behavioral port map (m4, m3, sel(0), y(3));
end architecture circular_barrel_shifter;
