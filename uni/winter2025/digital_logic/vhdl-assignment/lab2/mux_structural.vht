library ieee;
  use ieee.std_logic_1164.all;

entity mux_structural_tst is
end entity mux_structural_tst;

architecture mux_structural_arch of mux_structural_tst is

  -- constants
  -- signals
  signal a : std_logic;
  signal b : std_logic;
  signal s : std_logic;
  signal y : std_logic;

  component mux_structural is
    port (
      a : in    std_logic;
      b : in    std_logic;
      s : in    std_logic;
      y : out   std_logic
    );
  end component mux_structural;

begin

  i1 : component mux_structural
    port map (
      -- list connections between master ports and signals
      a => a,
      b => b,
      s => s,
      y => y
    );

  always : process is
  begin

    a <= '1';
    b <= '1';
    s <= '0';
    wait for 10 ns;

    s <= '1';
    wait for 10 ns;

    a <= '1';
    b <= '0';
    s <= '0';
    wait for 10 ns;

    s <= '1';
    wait for 10 ns;

    a <= '0';
    b <= '1';
    s <= '0';
    wait for 10 ns;

    s <= '1';
    wait for 10 ns;

    a <= '0';
    b <= '0';
    s <= '0';
    wait for 10 ns;

    s <= '1';
    wait for 10 ns;

    wait;

  end process always;

end architecture mux_structural_arch;
