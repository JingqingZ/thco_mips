----------------------------------------------------------------------------------
-- Ԫ�����ƣ�BRCH��֧������
-- �������������ݷ�֧Ԥ���¼�ҵ����ʵ���һPCֵ�����ƶμĴ��������ݣ���Ӧ�ж�
-- ��Ϊ���������Jcond == 0����ô���ӷ�֧Ԥ���¼�а���OldPc���ҵ���Ӧ���
-- 	�������ֵ����NPc�����Jcond != 0��
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BRCH is
    Port ( Pc : in  STD_LOGIC_VECTOR(15 downto 0);
			  NPc : out  STD_LOGIC_VECTOR(15 downto 0);
			  MemPc : in  STD_LOGIC_VECTOR(15 downto 0);
           MemNPc : in  STD_LOGIC_VECTOR(15 downto 0);
           Jcond : in  STD_LOGIC_VECTOR(2 downto 0);
			  JFlag : in  STD_LOGIC;
			  ExcpPrep : in  STD_LOGIC;
			  EPc : in  STD_LOGIC_VECTOR(15 downto 0);
           Bubble : out  STD_LOGIC_VECTOR(2 downto 0);
			  Clk : in  STD_LOGIC;
			  Rst : in  STD_LOGIC);
end BRCH;

architecture Behavioral of BRCH is

	-- ��֧Ԥ��Ĵ�����д��˿�
	signal KeyWr : std_logic_vector(15 downto 0);
	signal ValWr : std_logic_vector(15 downto 0);
	
	-- ��֧Ԥ��Ĵ����Ķ�ȡ�˿�
	signal KeyRd : std_logic_vector(15 downto 0);
	signal ValRd : std_logic_vector(15 downto 0);
	
	-- ��֧Ԥ��Ĵ�����д����ƶ˿�
	signal KeyWrEn : std_logic;
	signal ValWrEn : std_logic;
	
	-- ��֧Ԥ��Ĵ���
	component REG16 is
		 Port ( DataWr : in  STD_LOGIC_VECTOR(15 downto 0);
				  DataRd : out  STD_LOGIC_VECTOR(15 downto 0);
				  Wr : in  STD_LOGIC;
				  Clk : in  STD_LOGIC;
				  Rst : in  STD_LOGIC);
	end component;
	
begin
	-- ���ӼĴ���
	Key : REG16 port map (DataWr => KeyWr, DataRd => KeyRd, Wr => KeyWrEn, Clk => Clk, Rst => Rst);
	Val : REG16 port map (DataWr => ValWr, DataRd => ValRd, Wr => ValWrEn, Clk => Clk, Rst => Rst);
	
	
	-- IF�׶��У�����PC+1��ֵ��Ҳ���Ǹ�Ԫ����Pc�˿ڣ����������ֵ����AluRes/Data2�������MEM�׶ε�ָ�����ת�źţ�
	process(Pc, MemPc, MemNPc, Jcond, JFlag, KeyRd, ValRd, ExcpPrep, EPc)
	begin
		-- Ϊ��֤��·������߼��ԣ�����������ú���������˿ڵ�ֵ,��ʹ���ǲ���Ҫ�����κ���Ϣ��
		KeyWrEn <= '0';
		ValWrEn <= '0';
		KeyWr <= "0000000000000000";
		ValWr <= "0000000000000000";
		Bubble <= "000";
		
		if ExcpPrep = '1' then -- �жϵ������ұ��뱻��Ӧ
			NPc <= EPc; -- ��Ӧ�����ж�׼��������ڵ�ַ
		else -- ���ж�
			if Jcond = "000" then -- MEM�׶�ָ�����תָ��
				if Pc = KeyRd then
					NPc <= ValRd;
				else
					NPc <= Pc;
				end if;
			else -- MEM�׶ε�ָ��Ϊ��תָ������ָ������֧Ԥ����У������Ԥ���Ƿ�ɹ�
				-- �Ƿ��ڷ�֧Ԥ��Ĵ�����
				if MemPc = KeyRd then
					if MemNPc = ValRd then -- Ԥ��ɹ���������
						NPc <= Pc;
					else -- Ԥ��ʧ�ܣ��Ѿ�������ˮ�ߵ���������ָ������
						NPc <= MemNPc;
						ValWr <= MemNPc;
						ValWrEn <= '1';
						Bubble <= "111";
					end if;
				else -- ���ڱ�����
					if JFlag = '0' then -- ��Ȼ����תָ����Ǹ�ָ��û��ִ����ת����
						NPc <= Pc;
					else -- ������ת���Ѿ�������ˮ�ߵ�ָ������
						-- ��¼�µķ�֧Ԥ���
						KeyWr <= MemPc;
						ValWr <= MemNPc; 
						KeyWrEn <= '1'; 
						ValWrEn <= '1';

						NPc <= MemNPc;
						Bubble <= "111";
					end if;
				end if;
			end if;
		end if;
	end process;
end Behavioral;

