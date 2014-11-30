----------------------------------------------------------------------------------
-- Ԫ�����ƣ�ID/EXE����ˮ�߼Ĵ���
-- ��Ϊ������Bubble/Hold��Ϊ0ʱ����Clk������д��Ĵ�����Bubble1 = 1ʱ��
-- 	����HoldֵΪʲô�����������ݣ���Bubble = 0��HoldΪ1ʱ����д��Ĵ���
-- �˿�������
--		XXXWrΪ�����Ĵ�����д��ˣ�XXXRdΪ�����Ĵ����Ķ�ȡ��
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ID_EXE is
    Port ( Data1Wr : in  STD_LOGIC_VECTOR(15 downto 0);
           Data2Wr : in  STD_LOGIC_VECTOR(15 downto 0);
           Reg1Wr : in  STD_LOGIC_VECTOR(3 downto 0);
           Reg2Wr : in  STD_LOGIC_VECTOR(3 downto 0);
			  RegDstWr : in  STD_LOGIC_VECTOR(3 downto 0);
           ImmWr : in  STD_LOGIC_VECTOR(15 downto 0);
           PcWr : in  STD_LOGIC_VECTOR(15 downto 0);
           Op1SrcWr : in  STD_LOGIC;
           Op2SrcWr : in  STD_LOGIC;
           AluOpWr : in  STD_LOGIC_VECTOR(3 downto 0);
           TWrWr : in  STD_LOGIC;
			  JcondWr : in  STD_LOGIC_VECTOR(2 downto 0);
           MemRdWr : in  STD_LOGIC;
           MemWrWr : in  STD_LOGIC;
           RegWrWr : in  STD_LOGIC;
			  IfPfWr : in  STD_LOGIC;
			  IdInvalWr : in  STD_LOGIC;
			  IdPrivWr : in  STD_LOGIC;
			  IntWr : in  STD_LOGIC;
			  DegradeWr : in  STD_LOGIC;
           Data1Rd : out  STD_LOGIC_VECTOR(15 downto 0);
           Data2Rd : out  STD_LOGIC_VECTOR(15 downto 0);
           Reg1Rd : out  STD_LOGIC_VECTOR(3 downto 0);
           Reg2Rd : out  STD_LOGIC_VECTOR(3 downto 0);
			  RegDstRd : out  STD_LOGIC_VECTOR(3 downto 0);
           ImmRd : out  STD_LOGIC_VECTOR(15 downto 0);
           PcRd : out  STD_LOGIC_VECTOR(15 downto 0);
           Op1SrcRd : out  STD_LOGIC;
           Op2SrcRd : out  STD_LOGIC;
           AluOpRd : out  STD_LOGIC_VECTOR(3 downto 0);
           TWrRd : out  STD_LOGIC;
			  JcondRd : out  STD_LOGIC_VECTOR(2 downto 0);
           MemRdRd : out  STD_LOGIC;
           MemWrRd : out  STD_LOGIC;
           RegWrRd : out  STD_LOGIC;
			  IfPfRd : out  STD_LOGIC;
			  IdInvalRd : out  STD_LOGIC;
			  IdPrivRd : out  STD_LOGIC;
			  IntRd : out  STD_LOGIC;
			  DegradeRd : out  STD_LOGIC;
           Bubble : in  STD_LOGIC;
           Hold : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC);
end ID_EXE;

architecture Behavioral of ID_EXE is
signal Data1 : STD_LOGIC_VECTOR(15 downto 0);
signal Data2 : STD_LOGIC_VECTOR(15 downto 0);
signal Reg1 : STD_LOGIC_VECTOR(3 downto 0);
signal Reg2 : STD_LOGIC_VECTOR(3 downto 0);
signal RegDst : STD_LOGIC_VECTOR(3 downto 0);
signal Imm : STD_LOGIC_VECTOR(15 downto 0);
signal Pc : STD_LOGIC_VECTOR(15 downto 0);
signal Op1Src : STD_LOGIC;
signal Op2Src : STD_LOGIC;
signal AluOp : STD_LOGIC_VECTOR(3 downto 0);
signal TWr : STD_LOGIC;
signal Jcond : STD_LOGIC_VECTOR(2 downto 0);
signal MemRd : STD_LOGIC;
signal MemWr : STD_LOGIC;
signal RegWr : STD_LOGIC;
signal IfPf : STD_LOGIC;
signal IdInval : STD_LOGIC;
signal IdPriv : STD_LOGIC;
signal Int : STD_LOGIC;
signal Degrade : STD_LOGIC;
begin
	Data1Rd <= Data1;
	Data2Rd <= Data2;
	Reg1Rd <= Reg1;
	Reg2Rd <= Reg2;
	RegDstRd <= RegDst;
	ImmRd <= Imm;
	PcRd <= Pc;
	Op1SrcRd <= Op1Src;
	Op2SrcRd <= Op2Src;
	AluOpRd <= AluOp;
	TWrRd <= TWr;
	JcondRd <= Jcond;
	MemRdRd <= MemRd;
	MemWrRd <= MemWr;
	RegWrRd <= RegWr;
	IfPfRd <= IfPf;
	IdInvalRd <= IdInval;
	IdPrivRd <= IdPriv;
	IntRd <= Int;
	DegradeRd <= Degrade;
	
	-- д�����
	process(Rst,Clk)
	begin
		if Rst = '0' then -- ��λ
			Data1 <= "0000000000000000";
			Data2 <= "0000000000000000";
			Reg1 <= "1111";
			Reg2 <= "1111";
			RegDst <= "1111";
			Imm <= "0000000000000000";
			Pc <= "0000000000000000";
			Op1Src <= '0';
			Op2Src <= '0';
			AluOp <= "0000";
			TWr <= '0';
			Jcond <= "000";
			MemRd <= '0';
			MemWr <= '0';
			RegWr <= '0';
			IfPf <= '0';
			IdInval <= '0';
			IdPriv <= '0';
			Int <= '0';
			Degrade <= '0';
		elsif rising_edge(Clk) then
			if Bubble = '1' then
				Data1 <= "0000000000000000";
				Data2 <= "0000000000000000";
				Reg1 <= "1111";
				Reg2 <= "1111";
				RegDst <= "1111";
				Imm <= "0000000000000000";
				Pc <= "0000000000000000";
				Op1Src <= '0';
				Op2Src <= '0';
				AluOp <= "0000";
				TWr <= '0';
				Jcond <= "000";
				MemRd <= '0';
				MemWr <= '0';
				RegWr <= '0';
				IfPf <= '0';
				IdInval <= '0';
				IdPriv <= '0';
				Int <= '0';
				Degrade <= '0';
			else
				if Hold = '0' then
					Data1 <= Data1Wr;
					Data2 <= Data2Wr;
					Reg1 <= Reg1Wr;
					Reg2 <= Reg2Wr;
					RegDst <= RegDstWr;
					Imm <= ImmWr;
					Pc <= PcWr;
					Op1Src <= Op1SrcWr;
					Op2Src <= Op2SrcWr;
					AluOp <= AluOpWr;
					TWr <= TWrWr;
					Jcond <= JcondWr;
					MemRd <= MemRdWr;
					MemWr <= MemWrWr;
					RegWr <= RegWrWr;
					IfPf <= IfPfWr;
					IdInval <= IdInvalWr;
					IdPriv <= IdPrivWr;
					Int <= IntWr;
					Degrade <= DegradeWr;
				end if;
			end if;
		end if;
	end process;

end Behavioral;

