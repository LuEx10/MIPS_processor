library IEEE;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MUX21 is
	generic (n: natural:= 32);
	Port(
		key 			: in std_logic;
		O, I			: in std_logic_vector(n-1 downto 0);
		M				: out std_logic_vector(n-1 downto 0)
	);
end MUX21;

architecture bhv of MUX21 is
begin
	M <= O when(key = '0') else I;
end bhv;