----------------------------------------------------------------------------------
-- Ԫ�����ƣ�IF/ID��ˮ�߼Ĵ���
-- ��Ϊ��������Bubble/Hold��Ϊ�͵�ƽʱ��ʱ�������ش����Ĵ���д���������BubbleΪ1��HoldΪ0ʱ��
-- 	�Ĵ���Insnֵ��ΪNOPָ�NPcΪ��Ȼд�����NPc����HoldΪ1��BubbleΪ0ʱ���Ĵ���Insn��NPc
-- 	��ֵ����Ϊʱ�������صĵ������ı䣻��Bubble��Hold��Ϊ1ʱ��Bubble���ȣ�Insn��ΪNOP��NPcΪ
-- 	��Ȼд�����NPc��
-- �˿�������
-- 	InsnWr	Insn�Ĵ���д���
-- 	InsnRd	Insn�Ĵ�����ȡ��
--		PcWr		Pc�Ĵ���д���
--		PcRd 		Pc�Ĵ�����ȡ��
--		IfPfWr	IfPf�ź�д���
--		IfPfRd	IfPf�źŶ�ȡ��
--		Bubble	���ݣ�ʹIF����Ч���ź�
-- 	Hold 		���֣������ý׶Σ��ź�
--		Clk		ʱ���ź�
--		Rst		��λ�ź�
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IF_ID is
    Port ( InsnWr : in  STD_LOGIC_VECTOR(15 downto 0);
           InsnRd : out  STD_LOGIC_VECTOR(15 downto 0);
           PcWr : in  STD_LOGIC_VECTOR(15 downto 0);
           PcRd : out  STD_LOGIC_VECTOR(15 downto 0);
			  IfPfWr : in  STD_LOGIC;
			  IfPfRd : out  STD_LOGIC;
           Bubble : in  STD_LOGIC;
           Hold : in  STD_LOGIC;
			  Clk : in  STD_LOGIC;
			  Rst : in  STD_LOGIC);
end IF_ID;

architecture Behavioral of IF_ID is
signal Insn, Pc : std_logic_vector(15 downto 0);
signal IfPf : std_logic;
begin
	InsnRd <= Insn;
	PcRd <= Pc;
	IfPfRd <= IfPf;
	
	process(Rst,Clk)
	begin
		if Rst = '0' then
			Insn <= "0000100000000000"; -- NOPָ��
			Pc <= "0000000000000000";
			IfPf <= '0';
		elsif rising_edge(Clk) then
			if Bubble = '1' then -- ���ݲ���
				Insn <= "0000100000000000"; -- NOPָ��
				Pc <= PcWr;
				IfPf <= '0';
			else
				if Hold = '0' then -- �����֣�����������
					Insn <= InsnWr;
					Pc <= PcWr;
					IfPf <= IfPfWr;
				end if;
			end if;
		end if;
	end process;
end Behavioral;

