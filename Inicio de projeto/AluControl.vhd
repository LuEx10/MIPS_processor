library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity AluControl is
	port (
		funct: in std_logic_vector(5 downto 0);
		ALUOp: in std_logic_vector(1 downto 0);
		ALUCtl: out std_logic_vector(3 downto 0)
	);
end AluControl;

architecture bhv of AluControl is
	Signal tipoR : std_logic_vector(3 downto 0) := (others => '0');
	begin
	
	--R-type:
	with funct select tipoR <=
   "0010" when "100000",
   "0110" when "100010",
   "0000" when "100100",
   "0001" when "100101",
   "0111" when "101010",
	"0000" when others;
	
	with ALUOp select ALUCtl <=
	"0010" when "00",
	"0110" when "01",
	tipoR when "10",
	"0000" when others;

end bhv;