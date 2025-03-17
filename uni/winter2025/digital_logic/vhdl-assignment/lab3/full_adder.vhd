library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    port (
        a : in std_logic;
        b : in std_logic;
        c_in : in std_logic;
        s : out std_logic;
        c_out : out std_logic
    );
end full_adder;

architecture structural of full_adder is
    signal s1, c1, c2: std_logic;
		
    component half_adder
		port (
        a : in std_logic;
        b : in std_logic;
        s : out std_logic;
        c : out std_logic
		);
	 end component;
	 
begin
    ha1: half_adder port map(a, b, s1, c1);
    ha2: half_adder port map(s1, c_in, s, c2);
    c_out <= c1 OR c2;
end structural;