library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ShiftL is
	generic (i: natural:= 32; j: natural:= 32; k: natural:= 2);
	port (
		x: in std_logic_vector(i-1 downto 0);
		y: out std_logic_vector(j-1 downto 0)
	);
end entity;

architecture bhv of ShiftL is
	signal temp: std_logic_vector(j-1 downto 0);

	begin
	temp <= std_logic_vector(resize(unsigned(x), j)); 
	y <= std_logic_vector(shift_left(signed(temp), k));
end bhv;