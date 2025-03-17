library ieee;
  use ieee.std_logic_1164.all;

entity mux_behavioral_vhd_tst is
end entity mux_behavioral_vhd_tst;

architecture mux_behavioral_arch of mux_behavioral_vhd_tst is

  -- constants
  -- signals
  signal a : std_logic;
  signal b : std_logic;
  signal s : std_logic;
  signal y : std_logic;

  component mux_behavioral is
    port (
      a : in    std_logic;
      b : in    std_logic;
      s : in    std_logic;
      y : out   std_logic
    );
  end component mux_behavioral;

begin

  i1 : component mux_behavioral
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

end architecture mux_behavioral_arch;
