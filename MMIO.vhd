----------------------------------------------------------------------------------
-- Ԫ�����ƣ�MMIO�ڴ���˿ڷ���ģ��
-- ������������ȡ/�޸��ڴ浥Ԫ/���ʴ���
-- ��Ϊ������ǰ�������Ԫ�����������ȴ������źţ�ʱ���½��ش��������������MEM�׶ηô�������ͺ���
--		IF�׶ε�ȡָ�������ֱ�ӷ���NOPָ�������ɶ�д������������Ӧ���źţ������򣬾�ȡָ�
-- �˿�������
-- 	IfAddr 		ȡָ���ָ���ַ
-- 	Insn			ȡ����ָ������
--		MemAddr 		MEM�׶η��ʵ��ڴ��ַ
--		MemDataWr 	��д���ڴ�����
--		MemDataRd	���ڴ��ж���������
--		MemRd			MEM�׶ε�MemRd�ź�
--		MemWr			MEM�׶ε�MemWr�ź�
--		Ram2Addr		����RAM2��A�ź�
--		Ram2Data		����RAM2��D�ź�
--		Ram2WE		RAM2��дʹ���ź�
--		Ram2OE		RAM2�����ʹ���ź�
--		Clk			ʱ���ź�		
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MMIO is
    Port ( IfAddr : in  STD_LOGIC_VECTOR(15 downto 0);
           Insn : out  STD_LOGIC_VECTOR(15 downto 0);
           MemAddr : in  STD_LOGIC_VECTOR(15 downto 0);
           MemDataWr : in  STD_LOGIC_VECTOR(15 downto 0);
           MemDataRd : out  STD_LOGIC_VECTOR(15 downto 0);
           MemRd : in  STD_LOGIC;
           MemWr : in  STD_LOGIC;
			  Ram2Addr : out  STD_LOGIC_VECTOR(15 downto 0);
			  Ram2Data : inout  STD_LOGIC_VECTOR(15 downto 0);
			  Ram2WE :  out STD_LOGIC;
			  Ram2OE :  out STD_LOGIC;
			  Clk :  in STD_LOGIC);
end MMIO;

architecture Behavioral of MMIO is
begin
	Ram2Addr <= IfAddr when MemRd = '0' and MemWr = '0' else MemAddr;
	Ram2Data <= MemDataWr when MemWr = '1' else "ZZZZZZZZZZZZZZZZ";
	Insn <= Ram2Data when MemRd = '0' and MemWr = '0' else "0000100000000000"; -- NOP
	MemDataRd <= Ram2Data when MemRd = '1' else "0000000000000000";
	Ram2OE <= '0' when MemWr = '0' and Clk = '0' else '1';
	Ram2WE <= (not MemWr) or Clk;
end Behavioral;

