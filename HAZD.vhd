----------------------------------------------------------------------------------
-- 元件名称：HAZD冲突检测器
-- 功能描述：检测并处理LW/LW_SP指令后直接对目的寄存器进行操作的数据冲突和内存访问结构冲突。
-- 行为描述：当满足以下情况时，发生数据冲突：
--			MEM.MemRd = '1' and MEM.RegDst = Reg1(或者2)
--		此时，不可用旁路解决冲突。解决方法是将EXE阶段的执行结果冒泡（给EXE_MEM下达Bubble信号），
--		保持PC寄存器、IF/ID流水线寄存器、ID/EXE流水线寄存器不变，相当于将LW之后的指令延迟一个周期。
--		经过这种方法解决冲突后，一个周期后，冲突退化为EXE/WB冲突，可以用旁路解决。
--		当MEM阶段需要访存时，发生结构冲突。此时，以完成MEM阶段访存优先，IF阶段暂停一个周期。
-- 端口描述：
-- 	MemRd 	MEM阶段MemRd控制信号
--		MemWr		MEM阶段MemWr控制信号
-- 	RegDst	MEM阶段RegDst控制信号
--		Reg1		EXE阶段Reg1控制信号
--		Reg2		EXE阶段Reg2控制信号
--		HoldReg	保持流水线段寄存器控制信号
--		HoldPc	保持PC不变的信号
--		Bubble	气泡控制信号
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HAZD is
    Port ( MemRd : in  STD_LOGIC;
			  MemWr : in  STD_LOGIC;
           RegDst : in  STD_LOGIC_VECTOR(3 downto 0);
           Reg1 : in  STD_LOGIC_VECTOR(3 downto 0);
           Reg2 : in  STD_LOGIC_VECTOR(3 downto 0);
           HoldReg : out  STD_LOGIC;
			  HoldPc : out  STD_LOGIC;
           Bubble : out  STD_LOGIC_VECTOR(2 downto 0));
end HAZD;

architecture Behavioral of HAZD is
begin
	HoldReg <= '1' when MemRd = '1' and (RegDst = Reg1 or RegDst = Reg2)	else '0';
	HoldPc <= '1' when MemRd = '1' or MemWr = '1' else '0';
	Bubble <= "001" when MemRd = '1' and (RegDst = Reg1 or RegDst = Reg2) else "000";
end Behavioral;	

