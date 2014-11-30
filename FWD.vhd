----------------------------------------------------------------------------------
-- 元件名称：FWD旁路控制器
-- 功能描述：旁路控制器负责检测数据冲突。当各流水线段发生数据冲突并可以由旁路解决时，旁路控制器产生
-- 	控制信号，选择指定旁路作为对应ALU输入的来源。
-- 行为描述：旁路控制器解决的数据冲突类型：
-- 	1. 相邻指令，前者的ALU结果是后者的ALU输入。此时，前者刚刚进入MEM阶段，后者刚刚进入EXE阶段，
-- 		满足如下条件：
--				MEM.MemRd == '0' and
--				MEM.RegWr == '1' and
--				MEM.RegDst != "1111" and
-- 			MEM.RegDst == EXE.Reg1(或者2)
-- 		此时，通过旁路将Mem.AluRes直接送入EXE阶段ALU对应的操作数。
--		2. 隔一条指令，前者的写回寄存器是后者的ALU输入。此时，前者刚刚进入WB阶段，后者刚刚进入EXE阶段，
--			满足如下条件：
--				WB.RegDst != "1111" and 
--				WB.RegWr == '1' and
--				WB.RegDst == EXE.Reg1(或者2) and
--				MEM.RegDst != EXE.Reg1(或者2) // 注意，可能以上两个冲突同时发生，这时EXE/MEM冲突
--														// （第一种情况）的计算结果显然更“新”
--			此时，通过旁路将WB.RegDataWr直接送入EXE阶段ALU对应的操作数。
-- 端口描述：
-- 	MemRdM	MEM阶段MemRd信号
--		RegDstM	MEM阶段RegDst信号
--		RegWrM	MEM阶段RegDst信号
--		RegDstW	WB阶段RegDst信号
--		RegWrW	WB阶段RegWr信号
--		Reg1		EXE阶段Reg1信号
--		Reg2		EXE阶段Reg2信号
--		Op1Src	EXE阶段Op1Src信号
--		Op2Src	EXE阶段Op2Src信号
--		Fwd1		ALU第一操作数选择信号
--		Fwd2		ALU第二操作数选择信号
--		Fwd3		Data2(Reg2)直传数据(写入内存的数据/跳转地址)选择信号
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FWD is
    Port ( MemRdM : in  STD_LOGIC;
           RegDstM : in  STD_LOGIC_VECTOR(3 downto 0);
           RegWrM : in  STD_LOGIC;
           RegDstW : in  STD_LOGIC_VECTOR(3 downto 0);
           RegWrW : in  STD_LOGIC;
           Reg1 : in  STD_LOGIC_VECTOR(3 downto 0);
           Reg2 : in  STD_LOGIC_VECTOR(3 downto 0);
           Op1Src : in  STD_LOGIC;
           Op2Src : in  STD_LOGIC;
           Fwd1 : out  STD_LOGIC_VECTOR(1 downto 0);
           Fwd2 : out  STD_LOGIC_VECTOR(1 downto 0);
           Fwd3 : out  STD_LOGIC_VECTOR(1 downto 0));
end FWD;

architecture Behavioral of FWD is
begin
	process (MemRdM, RegDstM, RegWrM, RegDstW, RegWrW, Reg1, Reg2, Op1Src, Op2Src)
	begin
		if Op1Src = '0' and RegWrM = '1' and MemRdM = '0' and RegDstM /= "1111" and RegDstM = Reg1 then
			Fwd1 <= "10";
		elsif Op1Src = '0' and RegWrW = '1' and RegDstW = Reg1 and RegDstM /= Reg1 then
			Fwd1 <= "11";
		else
			Fwd1(1) <= '0';
			Fwd1(0) <= Op1Src;
		end if;
		
		if Op2Src = '0' and RegWrM = '1' and MemRdM = '0' and RegDstM /= "1111" and RegDstM = Reg2 then
			Fwd2 <= "10";
		elsif Op2Src = '0' and RegWrW = '1' and RegDstW = Reg2 and RegDstM /= Reg2 then
			Fwd2 <= "11";
		else
			Fwd2(1) <= '0';
			Fwd2(0) <= Op2Src;
		end if;
		
		if RegWrM = '1' and MemRdM = '0' and RegDstM /= "1111" and RegDstM = Reg2 then
			Fwd3 <= "01";
		elsif RegWrW = '1' and RegDstW = Reg2 and RegDstM /= Reg2 then
			Fwd3 <= "10";
		else
			Fwd3 <= "00";
		end if;
	end process;
end Behavioral;

