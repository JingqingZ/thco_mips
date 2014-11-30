----------------------------------------------------------------------------------
-- Ԫ�����ƣ�TFLAG�Ĵ���
-- ������������ȡT��־λ�����޸�T��־λ
-- ��Ϊ��������ʱ���Դ�TValueRd�˿ڶ�ȡ��ǰT��־λ����ʱ�������ص���ʱ�����TWrΪ�ߵ�ƽ������
-- 	TvalueWr��ֵд��Ĵ���
-- �˿�������
-- 	TValueWr 	��T��־ֵ
-- 	TValueRd 	��ǰT��־
-- 	TWr 			�����޸�Tֵ
-- 	Clk			ʱ���ź�
-- 	Rst 			��λ�ź�
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TFLAG is
    Port ( TValueWr : in  STD_LOGIC;
           TValueRd : out  STD_LOGIC;
           TWr : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC);
end TFLAG;

architecture Behavioral of TFLAG is
signal T : std_logic;
begin
	TValueRd <= T;
	
	process(Rst,Clk)
	begin
		if Rst = '0' then
			T <= '0';
		elsif rising_edge(Clk) then
			case TWr is
				when '1' => T <= TValueWr;
				when others => -- ʲô������
			end case;
		end if;
	end process;
end Behavioral;

