----------------------------------------------------------------------------------
-- Ԫ�����ƣ�ZCMP��Ƚ���
-- �����������ж������16λ�����Ƿ�Ϊ0
-- ��Ϊ������������Ϊ0ʱ�����Ϊ1�����������ʱ�����Ϊ0
-- �˿�������
-- 	Data	�����16λ��
--		ZF		���������Ƿ�Ϊ0�ı�־λ
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ZCMP is
    Port ( Data : in  STD_LOGIC_VECTOR(15 downto 0);
           ZF : out  STD_LOGIC);
end ZCMP;

architecture Behavioral of ZCMP is
begin
	with Data select
		ZF <= '1' when "0000000000000000",
				'0' when others;
end Behavioral;
