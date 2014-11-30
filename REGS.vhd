----------------------------------------------------------------------------------
-- Ԫ�����ƣ�REGS�Ĵ�����
-- ����������ͨ�üĴ���������Ĵ����Ĵ洢Ԫ��
-- ��Ϊ�������Ӷ�ȡ���濴��Data1��Data2�ֱ��������Reg1��Reg2��ָ���ļĴ���ֵ����д�뷽�濴��
-- 	����д������ݷ���RegDataWr������Ҫд��ļĴ�����ŷ���RegDst����д������ź�RegWr��Ϊ
--		�ߵ�ƽ����ʱ�������ص���ʱ���µ����ݼ���д�뵽Ŀ�ļĴ���������Ϊ�������ж���Ҫ�������¹涨��
-- 	����ͨ��һ���д��������޸��жϺżĴ���IC���ж�PC�Ĵ���EPC�����жϷ���ʱ��IntHdl����Ϊ
-- 	�ߵ�ƽ��IntCode��EPc�ֱ𱻸�ֵΪ�жϺź��жϵ�PCֵ������������£�ʱ�������ش�������������
-- 	д���Ӧ�ļĴ������Ĵ�����Ź���Ϊ��ͨ�üĴ����ı����ͨ�üĴ���������һ�£�����Ĵ����ı��Ϊ
--		SP=1000(8), IH=1001(9), RA=1010(10), IC=1011(11), EP=1100(12), ZERO=1111(15)
-- �˿�������
-- 	Reg1		��һ������ȡ�Ĵ������
--		Reg2 		�ڶ�������ȡ�Ĵ������
--		Data1		��һ������ȡ�Ĵ�����ֵ
--		Data2		�ڶ�������ȡ�Ĵ�����ֵ
--		RegWr		�Ĵ���д������źţ��ߵ�ƽʱ����д�������
--		RegDataWr��д������
--		RegDst	��д��Ĵ����ı��
--		IntEn		IH�����λ���ߵ�ƽʱ�����жϣ�
--		IntHdl	�жϴ�������źţ��ߵ�ƽʱ�޸�IC��EP�����жϼĴ�����
--		Clk		ʱ���ź�
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REGS is
    Port ( Reg1 : in  STD_LOGIC_VECTOR(3 downto 0);
           Reg2 : in  STD_LOGIC_VECTOR(3 downto 0);
           Data1 : out  STD_LOGIC_VECTOR(15 downto 0);
           Data2 : out  STD_LOGIC_VECTOR(15 downto 0);
           RegWr : in  STD_LOGIC;
           RegDataWr : in  STD_LOGIC_VECTOR(15 downto 0);
           RegDst : in  STD_LOGIC_VECTOR(3 downto 0);
           IntEn : out  STD_LOGIC;
           IntHdl : in  STD_LOGIC;
			  Clk : in  STD_LOGIC;
			  Rst : in  STD_LOGIC);
end REGS;

architecture Behavioral of REGS is
signal R0, R1, R2, R3, R4, R5, R6, R7, SP, IH, RA, ER, KP, UP : STD_LOGIC_VECTOR(15 downto 0);
begin

	-- ��ȡ�Ĵ�������ϵ�·
	with Reg1 select
		Data1 <= R0 when "0000",
					R1 when "0001",
					R2 when "0010",
					R3 when "0011",
					R4 when "0100",
					R5 when "0101",
					R6 when "0110",
					R7 when "0111",
					SP when "1000",
					IH when "1001",
					RA when "1010",
					ER when "1011",
					KP when "1100",
					UP when "1101",
					"0000000000000000" when others;

	with Reg2 select
		Data2 <= R0 when "0000",
					R1 when "0001",
					R2 when "0010",
					R3 when "0011",
					R4 when "0100",
					R5 when "0101",
					R6 when "0110",
					R7 when "0111",
					SP when "1000",
					IH when "1001",
					RA when "1010",
					ER when "1011",
					KP when "1100",
					UP when "1101",
					"0000000000000000" when others;

	-- IH���λ
	IntEn <= IH(15);

	-- д��Ĵ���
	process(Rst, Clk)
	begin
		if Rst = '0' then
			R0 <= "0000000000000000";
			R1 <= "0000000000000000";
			R2 <= "0000000000000000";
			R3 <= "0000000000000000";
			R4 <= "0000000000000000";
			R5 <= "0000000000000000";
			R6 <= "0000000000000000";
			R7 <= "0000000000000000";
			SP <= "0000000000000000"; -- �˴�Ӧ��Ϊ��ջ��ʼ��ַ
			IH <= "0000000000000000"; -- Ĭ�Ϲر��жϣ����λΪ0
			RA <= "0000000000000000";
			ER <= "0000000000000000";
			KP <= "0000000000000000";
			UP <= "0000000000000000";
		elsif falling_edge(Clk) then
			case RegWr is
				when '1' => -- �޸ĳ����жϼĴ���IC��EP֮��ļĴ���
					case RegDst is
						when "0000" => R0 <= RegDataWr;
						when "0001" => R1 <= RegDataWr;
						when "0010" => R2 <= RegDataWr;
						when "0011" => R3 <= RegDataWr;
						when "0100" => R4 <= RegDataWr;
						when "0101" => R5 <= RegDataWr;
						when "0110" => R6 <= RegDataWr;
						when "0111" => R7 <= RegDataWr;
						when "1000" => SP <= RegDataWr;
						when "1001" => IH <= RegDataWr;
						when "1010" => RA <= RegDataWr;
						when "1011" => ER <= RegDataWr;
						when "1100" => KP <= RegDataWr;
						when "1101" => UP <= RegDataWr;
						when others => -- ����ļĴ�����ţ�ʲô������
					end case;
				when others => -- ʲô������
			end case;
			case IntHdl is
				when '1' =>
					IH(15) <= '0';
				when others => -- ʲô������
			end case;
		end if;
	end process;

end Behavioral;

