----------------------------------------------------------------------------------
-- Ԫ�����ƣ�FWD��·������
-- ������������·���������������ݳ�ͻ��������ˮ�߶η������ݳ�ͻ����������·���ʱ����·����������
-- 	�����źţ�ѡ��ָ����·��Ϊ��ӦALU�������Դ��
-- ��Ϊ��������·��������������ݳ�ͻ���ͣ�
-- 	1. ����ָ�ǰ�ߵ�ALU����Ǻ��ߵ�ALU���롣��ʱ��ǰ�߸ոս���MEM�׶Σ����߸ոս���EXE�׶Σ�
-- 		��������������
--				MEM.MemRd == '0' and
--				MEM.RegWr == '1' and
--				MEM.RegDst != "1111" and
-- 			MEM.RegDst == EXE.Reg1(����2)
-- 		��ʱ��ͨ����·��Mem.AluResֱ������EXE�׶�ALU��Ӧ�Ĳ�������
--		2. ��һ��ָ�ǰ�ߵ�д�ؼĴ����Ǻ��ߵ�ALU���롣��ʱ��ǰ�߸ոս���WB�׶Σ����߸ոս���EXE�׶Σ�
--			��������������
--				WB.RegDst != "1111" and 
--				WB.RegWr == '1' and
--				WB.RegDst == EXE.Reg1(����2) and
--				MEM.RegDst != EXE.Reg1(����2) // ע�⣬��������������ͻͬʱ��������ʱEXE/MEM��ͻ
--														// ����һ��������ļ�������Ȼ�����¡�
--			��ʱ��ͨ����·��WB.RegDataWrֱ������EXE�׶�ALU��Ӧ�Ĳ�������
-- �˿�������
-- 	MemRdM	MEM�׶�MemRd�ź�
--		RegDstM	MEM�׶�RegDst�ź�
--		RegWrM	MEM�׶�RegDst�ź�
--		RegDstW	WB�׶�RegDst�ź�
--		RegWrW	WB�׶�RegWr�ź�
--		Reg1		EXE�׶�Reg1�ź�
--		Reg2		EXE�׶�Reg2�ź�
--		Op1Src	EXE�׶�Op1Src�ź�
--		Op2Src	EXE�׶�Op2Src�ź�
--		Fwd1		ALU��һ������ѡ���ź�
--		Fwd2		ALU�ڶ�������ѡ���ź�
--		Fwd3		Data2(Reg2)ֱ������(д���ڴ������/��ת��ַ)ѡ���ź�
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

