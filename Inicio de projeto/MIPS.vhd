library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MIPS is
	port(
		clk: in std_logic
	);
end MIPS;

architecture bhv of MIPS is

-- sinais de controle:
signal ALUSrc, RegWrite, RegDst, MemtoReg, Branch, Jump, MemRead, MemWrite	:std_logic; 
signal ALUOp 	:std_logic_vector(1 downto 0) := (others => '0');

--outros sinais:
signal reset, Zero, Overflow, Cout, BranchCond      					: std_logic;	
signal ALUCtl  																	: STD_LOGIC_VECTOR(3 downto 0) 	:= (others => '0');
signal rdAddr1, rdAddr2, wrAddr, RWriteAddr1, RWriteAddr2  			: std_logic_vector(4 downto 0)	:= (others => '0');
signal opcode, funct																: std_logic_vector(5 downto 0)	:= (others => '0');
signal SignExtIn 																	: std_logic_vector(15 downto 0) 	:= (others => '0');
signal InstJump 																	: std_logic_vector(25 downto 0) 	:= (others => '0');
signal ShiftJump 																	: std_logic_vector(27 downto 0) 	:= (others => '0');
signal wData, shiftExt, BranchDst, PC0, PC1   							: std_logic_vector(31 downto 0)	:= (others => '0');
signal rdData1, rdData2, AluOut, AluIn2, SignExt						: std_logic_vector(31 downto 0)	:= (others => '0');
signal nextPC, PC, Instruction, PC4 ,mrData			  					: std_logic_vector(31 downto 0)	:= (others => '0');

begin
	opcode <= Instruction(31 downto 26);
	--Unidade de Controle:
	Control_instance	: entity work.UnidControle
		PORT MAP(
			opcode => opcode,
			ALUSrc => ALUSrc, 
			RegWrite => RegWrite, 
			RegDst => RegDst, 
			MemtoReg => MemtoReg, 
			Branch => Branch, 
			Jump => Jump, 
			MemRead => MemRead, 
			MemWrite => MemWrite,
			ALUOp => ALUOp
		);
	
	--Memoria de instrução: MemWrite = 0, WriteData = X, MemRead = 1
	IR_Mem_instance	: entity work.IRMem
		PORT MAP(
			address => PC,
			read_data => Instruction
		);
		
	--Memoria Principal
	Data_Mem_instance	: entity work.Memory
		PORT MAP(
			address => AluOut,
			write_data => rdData2,
			MemWrite => MemWrite,
			MemRead => MemRead,
			clk => clk,
			read_data => mrData
		);

	--Shift-2 Extend
	ShiftExt_instance : entity work.ShiftL
		generic map (
			i => 32,
			j => 32,
			k => 2
		)
		PORT MAP(
			x => SignExt,								-- entrada
			y => ShiftExt								-- saida
		);


	--Shift-2 jump
	InstJump <= Instruction(25 downto 0);
	ShiftJump_instance : entity work.ShiftL
		generic map (
			i => 26,
			j => 28,
			k => 2
		)
		PORT MAP(
			x => InstJump,								-- entrada
			y => ShiftJump								-- saida
		);

	--Mux Branch:
	BranchCond <= Zero and Branch;
	PC4 <= PC + 4;
	BranchDst <= PC4 + ShiftExt;
	BranchDst_instance : entity work.MUX21
		PORT MAP(
			key => BranchCond,						-- controle
			O => PC4,									-- entrada 0
			I => BranchDst,							-- entrada 1
			M => PC0										-- saida
		);
		
	--Jump:
	PC1 <= PC4(31 downto 28) & ShiftJump;
	MUX_Jump_instance : entity work.MUX21
		PORT MAP(
			key => Jump,								-- controle
			O => PC0,									-- entrada 0
			I => PC1,									-- entrada 1
			M => nextPC									-- saida
		);

	--PC
	PC_instance : entity work.PC
		PORT MAP(
			clk => clk,
			next_address => nextPC,
			current_address => PC
		);

	--Sign-Extend
	SignExtIn <= Instruction(15 downto 0);
	SigneExtend_instance : entity work.sign_extend
		PORT MAP(
			x => SignExtIn,
			y => SignExt
		);
	
	--RegDst
	RWriteAddr1 <= Instruction(20 downto 16);
	RWriteAddr2 <= Instruction(15 downto 11);
	
	MuxRegDst_instance: entity work.MUX21
		generic map (
			n => 5
		)
		PORT MAP(
			key => RegDst,								-- controle
			O => RWriteAddr1,							-- entrada 0
			I => RWriteAddr2,							-- entrada 1
			M => wrAddr									-- saida
		);

	--RegBank
	rdAddr1 <= Instruction(25 downto 21);
	rdAddr2 <= Instruction(20 downto 16);
	reset <= '0';
	RegBank_instance : entity work.RegBank
		PORT MAP (
			clk => clk,
			reset => reset,
			we => RegWrite,
			rdAddr1 => rdAddr1,
			rdAddr2 => rdAddr2,
			wrAddr => wrAddr,
			wData => wData,
			rdData1 => rdData1,
			rdData2 => rdData2
		);
		  
	--ALUSrc
	MuxAlu_instance: entity work.MUX21
		PORT MAP(
			key => ALUSrc,								-- controle
			O => rdData2,								-- entrada 0
			I => SignExt,								-- entrada 1
			M => AluIn2									-- saida
		);
	
	--ALU CTRL (saída ALUCtl):
	funct <= Instruction(5 downto 0);
	AluControl_instance: entity work.ALUControl
		PORT MAP(
			funct => funct,
			ALUOp => ALUOp,
			ALUCtl => ALUCtl
		);
	
	--ALU
	ALU_instance : entity work.ALU
		PORT MAP(
			A => rdData1,								-- Reg1
			B => AluIn2,								-- MUX (entrada 2 da ALU)
			ALUCtl => ALUCtl,							-- ALU Ctrl
			R => AluOut,								-- ALU result
			Zero => Zero,								-- Zero
			Overflow => Overflow,					-- ! ver se precisa
			Cout => Cout								-- ! ver se precisa
		);
		
	MuxMemToReg_instance: entity work.MUX21
		generic map (
			n => 32
		)
		PORT MAP(
			key => MemtoReg,							-- controle
			O => AluOut,								-- entrada 0
			I => mrData,								-- entrada 1
			M => wData									-- saida
		);
	

end bhv;