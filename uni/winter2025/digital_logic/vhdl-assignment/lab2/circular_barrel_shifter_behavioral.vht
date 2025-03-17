library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity circular_barrel_shifter_behavioral_vhd_tst is
end entity circular_barrel_shifter_behavioral_vhd_tst;

architecture arch of circular_barrel_shifter_behavioral_vhd_tst is

  -- constants
  -- signals
  signal sel : std_logic_vector(1 downto 0);
  signal x   : std_logic_vector(3 downto 0);
  signal y   : std_logic_vector(3 downto 0);

  component circular_barrel_shifter_behavioral is
    port (
      sel : in    std_logic_vector(1 downto 0);
      x   : in    std_logic_vector(3 downto 0);
      y   : out   std_logic_vector(3 downto 0)
    );
  end component circular_barrel_shifter_behavioral;

begin

  i1 : component circular_barrel_shifter_behavioral
    port map (
      -- list connections between master ports and signals
      sel => sel,
      x   => x,
      y   => y
    );

  always : process is
  begin

    x <= "1110";

    for j in 0 to 4 loop

      sel <= std_logic_vector(to_unsigned(j, 2));
      wait for 10 ns;

    end loop;

    wait;

  end process always;

end architecture arch;

