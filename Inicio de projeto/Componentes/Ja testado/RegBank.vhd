library IEEE;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegBank is
    Port (
        clk, reset, we      : in std_logic;
        rdAddr1, rdAddr2, wrAddr  : in std_logic_vector(4 downto 0);
        wData   : in std_logic_vector(31 downto 0);
        rdData1, rdData2 : out std_logic_vector(31 downto 0)
    );
end RegBank;

architecture bhv of RegBank is
    type matriz is array (0 to 31) of std_logic_vector(31 downto 0);
    signal registradores : matriz:= (others => x"00000000");
begin      
	rdData1 <= registradores(conv_integer(rdAddr1));
	rdData2 <= registradores(conv_integer(rdAddr2));
    process(clk, reset)
    begin
        if rising_edge(clk) and reset = '1' then -- quando reset = 1, zera todos os registradores
            
            for i in 0 to 31 loop
                registradores(i) <= (others => '0');
            end loop;
        elsif rising_edge(clk) then -- faz leitura do registrador
            if we = '1' then -- escreve no registrador
					 if wrAddr /= "00000" then
						registradores(conv_integer(wrAddr)) <= wData;
					 end if;
				 end if;
        end if;
    end process;
end bhv;
