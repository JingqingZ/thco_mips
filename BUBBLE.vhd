----------------------------------------------------------------------------------
-- Ԫ�����ƣ����ݿ�����
-- �������������������źŲ����ƶμĴ���
-- �˿�������
-- 	BubBr BRCHԪ���������ź�
-- 	BubHZ HAZDԪ���������ź�
--		BubFD IF/ID�Ĵ����Ŀ����ź�
--		BubDE ID/EXE�Ĵ����Ŀ����ź�
--		BubEM EXE/MEM�Ĵ����Ŀ����ź�
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BUBBLE is
    Port ( BubBr : in  STD_LOGIC_VECTOR(2 downto 0);
           BubHz : in  STD_LOGIC_VECTOR(2 downto 0);
			  BubEx : in  STD_LOGIC_VECTOR(2 downto 0);
           BubFD : out  STD_LOGIC;
           BubDE : out  STD_LOGIC;
           BubEM : out  STD_LOGIC);
end BUBBLE;

architecture Behavioral of BUBBLE is
begin
	BubFD <= BubBr(2) or BubHz(2) or BubEx(2);
	BubDE <= BubBr(1) or BubHz(1) or BubEx(1);
	BubEM <= BubBr(0) or BubHz(0) or BubEx(0);
end Behavioral;

