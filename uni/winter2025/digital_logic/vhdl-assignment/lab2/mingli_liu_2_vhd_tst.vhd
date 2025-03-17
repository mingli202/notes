library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity mingli_liu_2_vhd_tst is
end entity mingli_liu_2_vhd_tst;

architecture mingli_liu_2_arch of mingli_liu_2_vhd_tst is

  -- constants
  -- signals
  signal a    : std_logic_vector(3 downto 0);
  signal aeqb : std_logic;
  signal b    : std_logic_vector(3 downto 0);

  component mingli_liu_2 is
    port (
      a    : in    std_logic_vector(3 downto 0);
      aeqb : out   std_logic;
      b    : in    std_logic_vector(3 downto 0)
    );
  end component mingli_liu_2;

begin

  i1 : component mingli_liu_2
    port map (
      -- list connections between master ports and signals
      a    => a,
      aeqb => aeqb,
      b    => b
    );

  generate_test : process is
  begin

    for i in 0 to 16 loop

      a <= std_logic_vector(to_unsigned(i, 4));

      for j in 0 to 16 loop

        b <= std_logic_vector(to_unsigned(j, 4));
        wait for 10 ns;

      end loop;

    end loop;

    wait;

  end process generate_test;

end architecture mingli_liu_2_arch;
