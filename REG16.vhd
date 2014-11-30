----------------------------------------------------------------------------------
-- Ԫ�����ƣ�16λͨ�üĴ���
-- ����������ͨ�üĴ�����ʱ�������ص���ʱд�����ݡ�
-- �˿�������
-- 	DataWr 	����д���
-- 	DataRd 	���ݶ�ȡ��
--		Clk		ʱ���ź�
-- 	Rst		��λ�ź�
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REG16 is
    Port ( DataWr : in  STD_LOGIC_VECTOR(15 downto 0);
           DataRd : out  STD_LOGIC_VECTOR(15 downto 0);
			  Wr : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC);
end REG16;

architecture Behavioral of REG16 is
signal Data : std_logic_vector(15 downto 0);
begin
	DataRd <= Data;
	
	process(Rst, Clk)
	begin
		if Rst = '0' then
			Data <= "0000000000000000";
		elsif rising_edge(Clk) then
			if Wr = '1' then
				Data <= DataWr;
			end if;
		end if;
	end process;
end Behavioral;

