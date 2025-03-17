library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rca_structural is
    port (
        A : in std_logic_vector(3 downto 0);
        B : in std_logic_vector(3 downto 0);
        S : out std_logic_vector(4 downto 0)
    );
end rca_structural;

architecture structural of rca_structural is
    signal carry: std_logic_vector(3 downto 0);
	 
	 component full_adder
		port (
        a : in std_logic;
        b : in std_logic;
        c_in : in std_logic;
        s : out std_logic;
        c_out : out std_logic
		);
	 end component;
	 
begin
    fa0: full_adder port map(A(0), B(0), '0', S(0), carry(0));
    fa1: full_adder port map(A(1), B(1), carry(0), S(1), carry(1));
    fa2: full_adder port map(A(2), B(2), carry(1), S(2), carry(2));
    fa3: full_adder port map(A(3), B(3), carry(2), S(3), S(4));
end structural;
