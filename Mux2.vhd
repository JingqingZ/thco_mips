----------------------------------------------------------------------------------
-- Ԫ�����ƣ�Mux2��ѡһ��·ѡ����
-- ��������������Selѡ��ֵ������������ѡ��һ����·���䵽Y
-- �˿�������
-- 	X0,X1	����
--		Sel 	ѡ����
--		Y		���
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux2 is
    Port ( X0 : in  STD_LOGIC_VECTOR(15 downto 0);
           X1 : in  STD_LOGIC_VECTOR(15 downto 0);
           Y : out  STD_LOGIC_VECTOR(15 downto 0);
           Sel : in  STD_LOGIC);
end Mux2;

architecture Behavioral of Mux2 is
begin
	with Sel select
		Y <=  X0 when '0',
				X1 when '1',
				"0000000000000000" when others;
end Behavioral;

