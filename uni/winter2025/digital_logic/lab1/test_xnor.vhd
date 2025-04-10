-- Testbench for XNOR gate
library IEEE;
use IEEE.std_logic_1164.all;

entity test_xnor is
-- empty
end test_xnor;

architecture tb of test_xnor is

-- DUT component
component xnor_gate is
port(
  a: in std_logic;
  b: in std_logic;
  q: out std_logic);
end component;

signal a_in, b_in, q_out: std_logic;

begin

  -- Connect DUT
  DUT: xnor_gate port map(a_in, b_in, q_out);

  process
  begin
    a_in <= '0';
    b_in <= '0';
    wait for 1 ns;
    assert(q_out='1') report "Fail 0/0" severity error;

    a_in <= '0';
    b_in <= '1';
    wait for 1 ns;
    assert(q_out='0') report "Fail 0/1" severity error;

    a_in <= '1';
    b_in <= '0';
    wait for 1 ns;
    assert(q_out='0') report "Fail 1/0" severity error;

    a_in <= '1';
    b_in <= '1';
    wait for 1 ns;
    assert(q_out='1') report "Fail 1/1" severity error;

    -- Clear inputs
    a_in <= '0';
    b_in <= '0';

    assert false report "Test done." severity note;
    wait;
  end process;
end tb;
