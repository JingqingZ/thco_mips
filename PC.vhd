----------------------------------------------------------------------------------
-- Ԫ�����ƣ�PC�Ĵ���
-- ����������PC�Ĵ����洢��Ҫȡָ���ָ���ַ��
-- ��Ϊ���������κ�״̬�£����Դ�PcValueRd�˿ڶ�����ǰPCֵ������Ҫ�޸�PC�Ĵ���ʱ������PCֵ����PcValueWr
--		�˿ڣ��ȴ�ʱ�������ص���ʱ���д����������������HoldΪ�ߵ�ƽʱ����ִ��д�������
-- �˿�������
-- 	Clk			ʱ���źţ�ʱ�������ش���д�������
-- 	PcValueRd	��ȡ��ǰPC�Ĵ���ֵ�Ķ˿�
--		PcValueWr	д����PCֵ�Ķ˿ڣ�ʱ�������ص���ʱ����д�������
--		Hold			����PCֵ����Ŀ����źţ�HoldΪ�ߵ�ƽʱ�ܾ�д����PCֵ��
--		Rst			��λ�ź� 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity PC is
    Port ( Rst: in  STD_LOGIC;
           Clk: in  STD_LOGIC;
           PcValueRd : out  STD_LOGIC_VECTOR(15 downto 0);
			  PcPlus1 : out  STD_LOGIC_VECTOR(15 downto 0);
           PcValueWr : in  STD_LOGIC_VECTOR(15 downto 0);
			  Hold : in STD_LOGIC);
end PC;

architecture Behavioral of PC is
signal PcValue : STD_LOGIC_VECTOR(15 downto 0);
begin
	PcValueRd <= PcValue;
	PcPlus1 <= PcValue + 1;
	
	-- д�����Process
	process(Rst,Clk)
	begin
		if Rst = '0' then
			PcValue <= "0000000000000000"; -- �˴�Ӧ��Ϊ��ʼPCֵ��Ҳ����ϵͳ�������ڵ�ַ
		elsif rising_edge(Clk) then
			case Hold is
				when '0' => PcValue <= PcValueWr;
				when others => -- ʲô������
			end case;
		end if;
	end process;
end Behavioral;

