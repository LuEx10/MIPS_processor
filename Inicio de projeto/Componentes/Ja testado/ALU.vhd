library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity ALU is
    Port (
    A, B     : in  STD_LOGIC_VECTOR(31 downto 0);  -- 2 inputs 32-bit
    ALUCtl  : in  STD_LOGIC_VECTOR(3 downto 0);  -- selecoes possiveis de funcoes
    R   : out  STD_LOGIC_VECTOR(31 downto 0); 
	 Zero, Overflow, Cout : out STD_LOGIC  
    );
end ALU; 
architecture ALU_Simples of ALU is

signal ALU_Result, AuxA, AuxB : signed (32 downto 0);
signal SLt: signed (32 downto 0);

begin
	SLT <= '0'&x"00000001" when(signed(A)<signed(B)) else '0'&x"00000000";
	AuxA <= resize(signed(A), AuxA'length);
	AuxB <= resize(signed(B), AuxB'length);

	with ALUCtl select ALU_Result <=
   AuxA + AuxB when "0010",
   AuxA - AuxB when "0110",
   AuxA and AuxB when "0000",
   AuxA or AuxB when "0001",
	not(AuxA or AuxB) when "1100",
	SLT when "0111",
	"000000000000000000000000000000000" when others;
   
	R <= std_logic_vector(ALU_Result(31 downto 0));
	Zero <= '1' when (ALU_Result(31 downto 0) = x"00000000") else '0';
	Overflow <= '1' when ((ALUCtl = "0010" and (
                           (A(31) = '0' and B(31) = '0' and ALU_Result(31)='1') 
									or (A(31) = '1' and B(31) = '1' and ALU_Result(31)='0')
									)
								) 
								or (ALUCtl = "0110" and (
									(A(31) = '0' and B(31) = '1' and ALU_Result(31)='1') 
									or (A(31) = '1' and B(31) = '0' and ALU_Result(31)='0')
                           ))
                     ) 
						else '0';
	Cout <= ALU_Result(32);
	 
end ALU_Simples;