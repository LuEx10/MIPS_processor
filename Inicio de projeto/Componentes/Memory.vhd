library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity memory is
	port (
		address, write_data: in STD_LOGIC_VECTOR (31 downto 0);
		MemWrite, MemRead,clk: in STD_LOGIC;
		read_data: out STD_LOGIC_VECTOR (31 downto 0)
	);
end memory;


architecture bhv of memory is	  

type MemArray is array(0 to 31) of STD_LOGIC_VECTOR (31 downto 0);

signal Memdata: MemArray := (
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

begin

read_data <= MemData(conv_integer(address(6 downto 2))) when MemRead = '1' else X"00000000";

mem_process: process(address, write_data,clk)
begin
	if rising_edge(clk) then
		if (MemWrite = '1') then
			MemData(conv_integer(address(6 downto 2))) <= write_data;
		end if;
	end if;
end process mem_process;

end bhv;