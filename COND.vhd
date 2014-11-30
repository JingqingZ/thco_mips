----------------------------------------------------------------------------------
-- Ԫ�����ƣ�COND��ת�����ж���
-- ��������������תģʽJcond�£����ݵ�ǰ������TF/ZF�������Ƿ���ת������˵��PCֵ����Դ��
-- ��Ϊ��������Jcond=0ʱ������ת����ʱ����TF/ZF��ֵ��
-- 	Jcond=1ʱ��������ת����PCֵΪALU����������ʱ����TF/ZF��ֵ��
-- 	Jcond=2ʱ�����TFΪ0������ת����PCֵΪALU�����������򣬲���ת��
-- 	Jcond=3ʱ�����TFΪ1������ת����PCֵΪALU�����������򣬲���ת��
--		Jcond=4ʱ�����ZFΪ0������ת����PCֵΪALU�����������򣬲���ת��
-- 	Jcond=5ʱ�����ZFΪ1������ת����PCֵΪALU�����������򣬲���ת��
-- 	Jcond=6ʱ��������ת����PCֵΪ�Ĵ�����Data2��
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COND is
    Port ( TF : in  STD_LOGIC;
           ZF : in  STD_LOGIC;
           Jcond : in  STD_LOGIC_VECTOR(2 downto 0);
			  Pc : in  STD_LOGIC_VECTOR(15 downto 0);
			  AluRes : in  STD_LOGIC_VECTOR(15 downto 0);
			  Data2 : in  STD_LOGIC_VECTOR(15 downto 0);
           NPc : out  STD_LOGIC_VECTOR(15 downto 0);
			  JFlag : out  STD_LOGIC);
end COND;

architecture Behavioral of COND is
begin
	process(TF,ZF,Jcond,Pc,AluRes,Data2)
	begin
		JFlag <= '0';
		case Jcond is
			when "000" => -- No
				NPc <= Pc;
			when "001" => -- ��������ת
				NPc <= AluRes;
				JFlag <= '1';
			when "010" => -- TF=0��ת
				if TF = '0' then
					NPc <= AluRes;
					JFlag <= '1';
				else
					NPc <= Pc;
				end if;
			when "011" => -- TF=1��ת
				if TF = '1' then
					NPc <= AluRes;
					JFlag <= '1';
				else
					NPc <= Pc;
				end if;
			when "100" => -- ZF=0��ת
				if ZF = '0' then
					NPc <= AluRes;
					JFlag <= '1';
				else
					NPc <= Pc;
				end if;
			when "101" => -- ZF=1��ת
				if ZF = '1' then
					NPc <= AluRes;
					JFlag <= '1';
				else
					NPc <= Pc;
				end if;
			when "110" => -- ��������ת����ԴΪData2
				NPc <= Data2;
				JFlag <= '1';
			when others => -- �������룬����ת
				NPc <= Pc;
		end case;
	end process;
end Behavioral;

