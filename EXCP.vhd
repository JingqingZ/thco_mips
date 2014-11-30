----------------------------------------------------------------------------------
-- Ԫ�����ƣ�EXCP�ж��쳣������
-- �������������ж����쳣������Ӧ��׼���������жϷ������
-- ��Ϊ������EXCP��MEM�׶�ָ����м�أ�����ý׶ε�ָ������쳣�����߸�ָ����֮ǰ�Ľ׶��Ѿ������쳣��
--		����ֱ������׶βŽ��д�������ô�ͽ��쳣�����ź�ExcpTr��Ϊ1���ò�������CPU�����ں�̬��
--		Ҳ����LFLAG����һ��ʱ�������ر���Ϊ0��Ҳ����IH���λ���㣩��ͨ��BubExcp�źŽ�ǰ�����׶����ϡ���ʱ�������ص���ʱ��
--		����Ƿ����쳣����������У��ʹ�״̬0����״̬3��LfΪ0ʱ������״̬1(LfΪ1ʱ)������ExcpPrep��Ϊ1����ʱ���쳣
-- 	�����������쳣׼��״̬����
--		״̬0�����쳣״̬��ExcpPrep��0��������쳣�źţ������ݻ�ǰ�����׶Σ��������쳣״̬1��3������ά�����쳣״̬��
--		״̬1��ExcpPrep��1�����ݻ�IF/ID�Ĵ���������ָ��SVUP
--		״̬2��ExcpPrep��1�����ݻ�IF/ID�Ĵ���������ָ��LDKP
--		״̬3��ExcpPrep��1�����ݻ�IF/ID�Ĵ���������ָ��LI_ER EPc
--		״̬4��ExcpPrep��1�����ݻ�IF/ID�Ĵ���������ָ��SW_ER -1
--		״̬5��ExcpPrep��1�����ݻ�IF/ID�Ĵ���������ָ��LI_ER ENo
--		״̬6��ExcpPrep��1�����ݻ�IF/ID�Ĵ���������ָ��SW_ER -2
--		״̬7��ExcpPrep��1�����ݻ�IF/ID�Ĵ���������ָ��LI_ER Reason
--		״̬8��ExcpPrep��1�����ݻ�IF/ID�Ĵ���������ָ��SW_ER -3 
--		״̬9��ExcpPrep��1�����ݻ�IF/ID�Ĵ���������ָ��LI_ER Addr
--		״̬10��ExcpPrep��1�����ݻ�IF/ID�Ĵ���������ָ��SW_ER -4
-- 	״̬11��ExcpPrep��1�����ݻ�IF/ID�Ĵ���������ָ��SUBU SP 4 ==> 0
--		
--		�����ⲿ�жϣ����������쳣���ơ�ֻ�е��ⲿ�жϴ�����IntEn��־λ1ʱ���Ž���״̬0����3.
--
-- �˿�������
--		IfPf		��IF�׶�һֱ���ݶ�����PageFault�ź�
--		MemPc		MEM�׶ε�PCֵ
--		NPc		MEM�׶ε�֪����һ��ָ���ַ
--		IdInval	��ID�׶�һֱ���ݶ����ķǷ�ָ���ź�
--		IdPriv	���û���ִ���ں˼�ָ��
--		Insn     �쳣ָ������
--		MemPf		MEM�׶β�����PageFault�ź�
--		MemVA		MEM�׶������ʵ������ڴ��ַ
--		MemWr		MEM�׶��Ƿ�Ϊд�ڴ�
--		IntInsn	���е�INTָ��
--		IntEn		�ж������־λ
--		IntTimer	�ⲿʱ���жϹܽ�
--		IntKb		�ⲿ�����жϹܽ�
--		BubExcp	���ݻ��μĴ������ź�
--		ExcpPrep	�쳣����׼���׶��ź�
--		ExcpInsn	�쳣���������ݳ���ָ��
-- 	ExcpTr	�쳣����ʱ���źţ����������쳣�������
--		Lf			CPU���м�
--		Clk		ʱ���ź�
--
--	�쳣���жϺ���ָ�������
--		0 		�Ƿ�ָ�����ִ�� II = Invalid Instruction
-- 	1		ҳ�쳣������ִ�� PF = Page Fault
--		2		��Ȩָ�����ִ�� PI = Privileged Instruction
--		3		�ж�ָ�����һ��ָ��ִ�� INT = Interrupt Instruction
--		16		�������жϣ�����һ��ָ��ִ��
--		17		�����жϣ�����һ��ָ��ִ��
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity EXCP is
    Port ( IfPf : in  STD_LOGIC;
           MemPc : in  STD_LOGIC_VECTOR(15 downto 0);
			  NPc : in  STD_LOGIC_VECTOR(15 downto 0);
			  BrchPc : out  STD_LOGIC_VECTOR(15 downto 0);
           IdInval : in  STD_LOGIC;
			  IdPriv : in  STD_LOGIC;
           MemPf : in  STD_LOGIC;
           MemVA : in  STD_LOGIC_VECTOR(15 downto 0);
			  MemWr : in  STD_LOGIC;
			  IntInsn : in  STD_LOGIC;
           IntEn : in  STD_LOGIC;
           IntTimer : in  STD_LOGIC;
           IntKb : in  STD_LOGIC;
           BubExcp : out  STD_LOGIC_VECTOR(2 downto 0);
           ExcpPrep : out  STD_LOGIC;
			  Lf : in  STD_LOGIC;
           ExcpTr : out  STD_LOGIC;
           ExcpInsn : out  STD_LOGIC_VECTOR(19 downto 0);
			  Clk : in  STD_LOGIC;
			  Rst : in  STD_LOGIC);
end EXCP;

architecture Behavioral of EXCP is
	
	-- ����߼�λ�����쳣״̬�ı�־
	signal ExcpFlag : std_logic;
	
	-- �Ĵ������쳣��
	signal ENo : std_logic_vector(15 downto 0);
	
	-- �Ĵ�����EPc������Ϊ�����쳣��ָ�Ҳ����Ϊ��һ��ָ���֮�����Ǵ��쳣�лָ���Ӧ��ִ�е�ָ��
	signal EPc : std_logic_vector(15 downto 0);
	
	-- �Ĵ�����Reason�����ڴ���ָ��ͷǷ�ָ��洢��ָ�����ҳ�쳣�洢�쳣״̬��0λΪ���м���1λΪд�������
	signal Reason : std_logic_vector(15 downto 0);
	
	-- �Ĵ�����Addr������ҳ�쳣�洢���ʵ��ڴ浥Ԫ��ַ
	signal Addr : std_logic_vector(15 downto 0);
	
	-- �Ĵ�����״̬������һ״̬
	signal NextState : std_logic_vector(3 downto 0);
	
	-- ����߼���״̬���ĵ�ǰ״̬
	signal State : std_logic_vector(3 downto 0);
	
begin

	ExcpFlag <= '1' when IfPf = '1' or IdInval = '1' or IdPriv = '1' or MemPf = '1' or IntInsn = '1' or (IntEn = '1' and (IntTimer = '1' or IntKb = '1')) else '0';
	ExcpTr  <= ExcpFlag;
	BubExcp <= 	"111" when ExcpFlag = '1' else
					"100" when ExcpFlag = '0' and State /= "0000" else
					"000";
	
	process(Clk, Rst)
	begin
		if Rst = '0' then 
			State <= "0000";
			NextState <= "0000";
			Addr <= "0000000000000000";
			Reason <= "0000000000000000";
			EPc <= "0000000000000000";
			ENo <= "0000000000000000";
		elsif rising_edge(Clk) then
			BrchPc <= "0000000000000011"; -- �жϷ���������
			case NextState is
				when "0000" =>
					State <= "0000";
					NextState <= "0000";
					ExcpPrep <= '0';
					ExcpInsn <= "00000000000000000000";
					BrchPc <= "0000000000000000";
					
					if ExcpFlag = '1' then
						if Lf = '1' then
							NextState <= "0001";
						else 
							NextState <= "0011";
						end if;
						
						Reason <= "0000000000000000";
						Addr <= "0000000000000000";
						if IfPf = '1' then -- Page fault during fetching an instruction
							ENo <= "0000000000000001";
							ENo(15) <= Lf;
							EPc <= MemPc - 1;
							Reason(0) <= Lf;
							Addr <= MemPc - 1;
						elsif MemPf = '1' then -- Page fault during accessing memory
							ENo <= "0000000000000001";
							ENo(15) <= Lf;
							EPc <= MemPc - 1;
							Reason(0) <= Lf;
							Reason(1) <= MemWr;
							Addr <= MemVA;
						elsif IdInval = '1' then -- Invalid instruction
							ENo <= "0000000000000000";
							ENo(15) <= Lf;
							EPc <= MemPc - 1;
						elsif IdPriv = '1' then -- Privileged instruction
							ENo <= "0000000000000010";
							ENo(15) <= Lf;
							EPc <= MemPc - 1;
						elsif IntInsn = '1' then -- INT
							ENo <= "0000000000000011";
							ENo(15) <= Lf;
							EPc <= NPc;
						elsif IntTimer = '1' then -- Timer
							ENo <= "0000000000010000";
							ENo(15) <= Lf;
							EPc <= NPc;
						elsif IntKb = '1' then -- Keyboard
							ENo <= "0000000000010001";
							ENo(15) <= Lf;
							EPc <= NPc;
						else
							ENo <= "0000000000000000";
							EPc <= "0000000000000000";
						end if;
					end if;
				when "0001" =>
					State <= "0001";
					NextState <= "0010";
					ExcpPrep <= '1';
					ExcpInsn <= "00001000000000000100"; -- SVUP
				when "0010" =>
					State <= "0010";
					NextState <= "0011";
					ExcpPrep <= '1';
					ExcpInsn <= "00001000000000000101"; -- LDKP
				when "0011" =>
					State <= "0011";
					NextState <= "0100";
					ExcpPrep <= '1';
					ExcpInsn(19 downto 16) <= "1000"; -- LI_ER EPc
					ExcpInsn(15 downto 0) <= EPc;
				when "0100" =>
					State <= "0100";
					NextState <= "0101";
					ExcpPrep <= '1';
					ExcpInsn(19 downto 16) <= "1001"; -- SW_ER -1
					ExcpInsn(15 downto 0) <= "1111111111111111";
				when "0101" =>
					State <= "0101";
					NextState <= "0110";
					ExcpPrep <= '1';
					ExcpInsn(19 downto 16) <= "1000"; -- LI_ER ENo
					ExcpInsn(15 downto 0) <= ENo;
				when "0110" =>
					State <= "0110";
					NextState <= "0111";
					ExcpPrep <= '1';
					ExcpInsn(19 downto 16) <= "1001"; -- SW_ER -2
					ExcpInsn(15 downto 0) <= "1111111111111110";
				when "0111" =>
					State <= "0111";
					NextState <= "1000";
					ExcpPrep <= '1';
					ExcpInsn(19 downto 16) <= "1000"; -- LI_ER Reason
					ExcpInsn(15 downto 0) <= Reason;
				when "1000" =>
					State <= "1000";
					NextState <= "1001";
					ExcpPrep <= '1';
					ExcpInsn(19 downto 16) <= "1001"; -- SW_ER -3
					ExcpInsn(15 downto 0) <= "1111111111111101";
				when "1001" =>
					State <= "1001";
					NextState <= "1010";
					ExcpPrep <= '1';
					ExcpInsn(19 downto 16) <= "1000"; -- LI_ER Addr
					ExcpInsn(15 downto 0) <= Addr;
				when "1010" =>
					State <= "1010";
					NextState <= "1011";
					ExcpPrep <= '1';
					ExcpInsn(19 downto 16) <= "1001"; -- SW_ER -4
					ExcpInsn(15 downto 0) <= "1111111111111100";
				when "1011" =>
					State <= "1011";
					NextState <= "0000";
					ExcpPrep <= '1';
					ExcpInsn <= "00000110001111111100"; -- ADDSP -4
				when others =>
					State <= "0000";
					NextState <= "0000";
					ExcpPrep <= '0';
					ExcpInsn <= "00000000100000000000"; -- NOP
			end case;
		end if;
	end process;

end Behavioral;

