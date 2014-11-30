----------------------------------------------------------------------------------
-- Ԫ�����ƣ�MEM/WB����ˮ�߼Ĵ���
-- ��Ϊ������ʱ�������ش���д�����
-- �˿�������
--		XXXWrΪ�����Ĵ�����д��ˣ�XXXRdΪ�����Ĵ����Ķ�ȡ��
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MEM_WB is
    Port ( AluResWr : in  STD_LOGIC_VECTOR(15 downto 0);
           MemDataWr : in  STD_LOGIC_VECTOR(15 downto 0);
           RegDstWr : in  STD_LOGIC_VECTOR(3 downto 0);
           MemRdWr : in  STD_LOGIC;
           RegWrWr : in  STD_LOGIC;
           AluResRd : out  STD_LOGIC_VECTOR(15 downto 0);
           MemDataRd : out  STD_LOGIC_VECTOR(15 downto 0);
           RegDstRd : out  STD_LOGIC_VECTOR(3 downto 0);
           MemRdRd : out  STD_LOGIC;
           RegWrRd : out  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC);
end MEM_WB;

architecture Behavioral of MEM_WB is
signal AluRes : STD_LOGIC_VECTOR(15 downto 0);
signal MemData : STD_LOGIC_VECTOR(15 downto 0);
signal RegDst : STD_LOGIC_VECTOR(3 downto 0);
signal MemRd : STD_LOGIC;
signal RegWr : STD_LOGIC;
begin
	AluResRd <= AluRes;
	MemDataRd <= MemData;
	RegDstRd <= RegDst;
	MemRdRd <= MemRd;
	RegWrRd <= RegWr;
	
	-- д�����
	process(Rst,Clk)
	begin
		if Rst = '0' then
			AluRes <= "0000000000000000";
			MemData <= "0000000000000000";
			RegDst <= "1111";
			MemRd <= '0';
			RegWr <= '0';
		elsif rising_edge(Clk) then
			AluRes <= AluResWr;
			MemData <= MemDataWr;
			RegDst <= RegDstWr;
			MemRd <= MemRdWr;
			RegWr <= RegWrWr;
		end if;
	end process;
end Behavioral;

