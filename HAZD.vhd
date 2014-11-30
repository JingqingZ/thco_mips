----------------------------------------------------------------------------------
-- Ԫ�����ƣ�HAZD��ͻ�����
-- ������������Ⲣ����LW/LW_SPָ���ֱ�Ӷ�Ŀ�ļĴ������в��������ݳ�ͻ���ڴ���ʽṹ��ͻ��
-- ��Ϊ�������������������ʱ���������ݳ�ͻ��
--			MEM.MemRd = '1' and MEM.RegDst = Reg1(����2)
--		��ʱ����������·�����ͻ����������ǽ�EXE�׶ε�ִ�н��ð�ݣ���EXE_MEM�´�Bubble�źţ���
--		����PC�Ĵ�����IF/ID��ˮ�߼Ĵ�����ID/EXE��ˮ�߼Ĵ������䣬�൱�ڽ�LW֮���ָ���ӳ�һ�����ڡ�
--		�������ַ��������ͻ��һ�����ں󣬳�ͻ�˻�ΪEXE/WB��ͻ����������·�����
--		��MEM�׶���Ҫ�ô�ʱ�������ṹ��ͻ����ʱ�������MEM�׶ηô����ȣ�IF�׶���ͣһ�����ڡ�
-- �˿�������
-- 	MemRd 	MEM�׶�MemRd�����ź�
--		MemWr		MEM�׶�MemWr�����ź�
-- 	RegDst	MEM�׶�RegDst�����ź�
--		Reg1		EXE�׶�Reg1�����ź�
--		Reg2		EXE�׶�Reg2�����ź�
--		HoldReg	������ˮ�߶μĴ��������ź�
--		HoldPc	����PC������ź�
--		Bubble	���ݿ����ź�
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

