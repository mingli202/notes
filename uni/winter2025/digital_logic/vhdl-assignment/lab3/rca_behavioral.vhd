library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity rca_behavioral is
    port (
        A : in std_logic_vector(3 downto 0);
        B : in std_logic_vector(3 downto 0);
        S : out std_logic_vector(4 downto 0)
    );
end rca_behavioral;

architecture behavioral of rca_behavioral is
begin

	S <= to_integer(A) + to_integer(B);

end behavioral;