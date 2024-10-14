library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity IRMem is
	port (
		address: in STD_LOGIC_VECTOR (31 downto 0);
		read_data: out STD_LOGIC_VECTOR (31 downto 0)
	);
end IRMem;


architecture bhv of IRMem is	  

type MemArray is array(0 to 31) of STD_LOGIC_VECTOR (31 downto 0);

signal Memdata: MemArray := (
    X"00000000", 	-- linha 0
    X"21080000",
    X"21290001",
    X"214A0011",
    X"216B0000",
    X"AE080000",	-- tirei a linha de cima (la)
    X"01096020",
    X"01204020",
    X"01804820",
    X"216B0001",
    X"22100004",
    X"116A0001",	-- beq para fim 
    X"08000005",	-- j para AE... (linha 5)
    X"0800000D",	-- fim (j para esta mesma)
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",  
    X"00000000", 	
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000", 
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000", 
    X"00000000", 
    X"00000000");
	 
	 --

begin

read_data <= Memdata(conv_integer(address(6 downto 2)));

end bhv;