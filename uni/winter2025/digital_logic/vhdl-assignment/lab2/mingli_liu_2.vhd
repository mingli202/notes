library ieee;
  use ieee.std_logic_1164.all;

library work;

entity mingli_liu_2 is
  port (
    a    : in    std_logic_vector(3 downto 0);
    b    : in    std_logic_vector(3 downto 0);
    aeqb : out   std_logic
  );
end entity mingli_liu_2;

architecture bdf_type of mingli_liu_2 is

  signal synthesized_wire_0 : std_logic;
  signal synthesized_wire_1 : std_logic;
  signal synthesized_wire_2 : std_logic;
  signal synthesized_wire_3 : std_logic;

begin

  synthesized_wire_0 <= NOT(a(0) xor b(0));
  synthesized_wire_1 <= NOT(a(1) xor b(1));
  synthesized_wire_2 <= NOT(a(2) xor b(2));
  synthesized_wire_3 <= NOT(a(3) xor b(3));

  aeqb <= synthesized_wire_0 and synthesized_wire_1 and synthesized_wire_2 and synthesized_wire_3;

end architecture bdf_type;
