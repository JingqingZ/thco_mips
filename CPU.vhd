----------------------------------------------------------------------------------
-- Ԫ�����ƣ�CPU����Ԫ��
-- �˿�������
--		Clk		ʱ���ź�
--		Rst		��λ�ź�
--		Ram2Data	RAM2��������
--		Ram2Addr	RAM2�ĵ�ַ��
--		Ram2OE	RAM2�����ʹ��
--		Ram2WE	RAM2��дʹ��
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPU is
    Port ( Clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           Ram2Data : inout  STD_LOGIC_VECTOR(15 downto 0);
           Ram2Addr : out  STD_LOGIC_VECTOR(15 downto 0);
           Ram2OE : out  STD_LOGIC;
           Ram2WE : out  STD_LOGIC;
           IntTimer : in  STD_LOGIC;
			  IntKb : in  STD_LOGIC;
			  DbInsnAddr : out STD_LOGIC_VECTOR(15 downto 0);
			  DbIfPc : out  STD_LOGIC_VECTOR(15 downto 0);
			  DbIfNPc : out  STD_LOGIC_VECTOR(15 downto 0);
			  DbMemJcond : out  STD_LOGIC_VECTOR(2 downto 0);
			  DbMemNPc : out  STD_LOGIC_VECTOR(15 downto 0);
			  DbBrchEPc : out  STD_LOGIC_VECTOR(15 downto 0);
			  DbMemPc : out  STD_LOGIC_VECTOR(15 downto 0)
			  );
end CPU;

architecture Behavioral of CPU is

	-- ������Ҫ��������Ԫ��
	
	component ALU is
		 Port ( Op1 : in  STD_LOGIC_VECTOR(15 downto 0);
				  Op2 : in  STD_LOGIC_VECTOR(15 downto 0);
				  AluOp : in  STD_LOGIC_VECTOR(3 downto 0);
				  AluRes : out  STD_LOGIC_VECTOR(15 downto 0);
				  Bool : out  STD_LOGIC);
	end component;
	
	component BRCH is
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
	end component;
	
	component BUBBLE is
		 Port ( BubBr : in  STD_LOGIC_VECTOR(2 downto 0);
				  BubHz : in  STD_LOGIC_VECTOR(2 downto 0);
				  BubEx : in  STD_LOGIC_VECTOR(2 downto 0);
				  BubFD : out  STD_LOGIC;
				  BubDE : out  STD_LOGIC;
				  BubEM : out  STD_LOGIC);
	end component;
	
	component COND is
		 Port ( TF : in  STD_LOGIC;
				  ZF : in  STD_LOGIC;
				  Jcond : in  STD_LOGIC_VECTOR(2 downto 0);
				  Pc : in  STD_LOGIC_VECTOR(15 downto 0);
				  AluRes : in  STD_LOGIC_VECTOR(15 downto 0);
				  Data2 : in  STD_LOGIC_VECTOR(15 downto 0);
				  NPc : out  STD_LOGIC_VECTOR(15 downto 0);
				  JFlag : out  STD_LOGIC);
	end component;
	
	component EXE_MEM is
		 Port ( RegDstWr : in  STD_LOGIC_VECTOR(3 downto 0);
				  PcWr : in  STD_LOGIC_VECTOR(15 downto 0);
				  BoolWr : in  STD_LOGIC;
				  AluResWr : in  STD_LOGIC_VECTOR(15 downto 0);
				  ZFWr : in  STD_LOGIC;
				  Data2Wr : in  STD_LOGIC_VECTOR(15 downto 0);
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
				  RegDstRd : out  STD_LOGIC_VECTOR(3 downto 0);
				  PcRd : out  STD_LOGIC_VECTOR(15 downto 0);
				  BoolRd : out  STD_LOGIC;
				  AluResRd : out  STD_LOGIC_VECTOR(15 downto 0);
				  ZFRd : out  STD_LOGIC;
				  Data2Rd : out  STD_LOGIC_VECTOR(15 downto 0);
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
				  Clk : in  STD_LOGIC;
				  Rst : in  STD_LOGIC);
	end component;
	
	component FWD is
		 Port ( MemRdM : in  STD_LOGIC;
				  RegDstM : in  STD_LOGIC_VECTOR(3 downto 0);
				  RegWrM : in  STD_LOGIC;
				  RegDstW : in  STD_LOGIC_VECTOR(3 downto 0);
				  RegWrW : in  STD_LOGIC;
				  Reg1 : in  STD_LOGIC_VECTOR(3 downto 0);
				  Reg2 : in  STD_LOGIC_VECTOR(3 downto 0);
				  Op1Src : in  STD_LOGIC;
				  Op2Src : in  STD_LOGIC;
				  Fwd1 : out  STD_LOGIC_VECTOR(1 downto 0);
				  Fwd2 : out  STD_LOGIC_VECTOR(1 downto 0);
				  Fwd3 : out  STD_LOGIC_VECTOR(1 downto 0));
	end component;
	
	component HAZD is
		 Port ( MemRd : in  STD_LOGIC;
				  MemWr : in  STD_LOGIC;
				  RegDst : in  STD_LOGIC_VECTOR(3 downto 0);
				  Reg1 : in  STD_LOGIC_VECTOR(3 downto 0);
				  Reg2 : in  STD_LOGIC_VECTOR(3 downto 0);
				  HoldReg : out  STD_LOGIC;
				  HoldPc : out  STD_LOGIC;
				  Bubble : out  STD_LOGIC_VECTOR(2 downto 0));
	end component;
	
	component ID_EXE is
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
	end component;
	
	component ID is
		 Port ( Insn : in  STD_LOGIC_VECTOR(19 downto 0);
				  Lf : in  STD_LOGIC;
				  Reg1 : out  STD_LOGIC_VECTOR(3 downto 0);
				  Reg2 : out  STD_LOGIC_VECTOR(3 downto 0);
				  RegDst : out  STD_LOGIC_VECTOR(3 downto 0);
				  Imm : out  STD_LOGIC_VECTOR(15 downto 0);
				  Op1Src : out  STD_LOGIC;
				  Op2Src : out  STD_LOGIC;
				  AluOp : out  STD_LOGIC_VECTOR(3 downto 0);
				  TWr : out  STD_LOGIC;
				  Jcond : out  STD_LOGIC_VECTOR(2 downto 0);
				  MemRd : out  STD_LOGIC;
				  MemWr : out  STD_LOGIC;
				  RegWr : out  STD_LOGIC;
				  Inval : out  STD_LOGIC;
				  Priv : out  STD_LOGIC;
				  Int : out  STD_LOGIC;
				  Degrade : out  STD_LOGIC);
	end component;
	
	component IF_ID is
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
	end component;
	
	component MEM_WB is
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
	end component;
	
	component MMIO is
    Port ( IfAddr : in  STD_LOGIC_VECTOR(15 downto 0);
           Insn : out  STD_LOGIC_VECTOR(15 downto 0);
           MemAddr : in  STD_LOGIC_VECTOR(15 downto 0);
           MemDataWr : in  STD_LOGIC_VECTOR(15 downto 0);
           MemDataRd : out  STD_LOGIC_VECTOR(15 downto 0);
           MemRd : in  STD_LOGIC;
           MemWr : in  STD_LOGIC;
			  Ram2Addr : out  STD_LOGIC_VECTOR(15 downto 0);
			  Ram2Data : inout  STD_LOGIC_VECTOR(15 downto 0);
			  Ram2WE :  out STD_LOGIC;
			  Ram2OE :  out STD_LOGIC;
			  Clk :  in STD_LOGIC);
	end component;
	
	component Mux2 is
		 Port ( X0 : in  STD_LOGIC_VECTOR(15 downto 0);
				  X1 : in  STD_LOGIC_VECTOR(15 downto 0);
				  Y : out  STD_LOGIC_VECTOR(15 downto 0);
				  Sel : in  STD_LOGIC);
	end component;
	
	component Mux4 is
		 Port ( X0 : in  STD_LOGIC_VECTOR(15 downto 0);
				  X1 : in  STD_LOGIC_VECTOR(15 downto 0);
				  X2 : in  STD_LOGIC_VECTOR(15 downto 0);
				  X3 : in  STD_LOGIC_VECTOR(15 downto 0);
				  Y : out  STD_LOGIC_VECTOR(15 downto 0);
				  Sel : in  STD_LOGIC_VECTOR(1 downto 0));
	end component;
	
	component PC is
		 Port ( Rst: in  STD_LOGIC;
				  Clk: in  STD_LOGIC;
				  PcValueRd : out  STD_LOGIC_VECTOR(15 downto 0);
				  PcPlus1 : out  STD_LOGIC_VECTOR(15 downto 0);
				  PcValueWr : in  STD_LOGIC_VECTOR(15 downto 0);
				  Hold : in STD_LOGIC);
	end component;
	
	component REGS is
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
	end component;
	
	component TFLAG is
		 Port ( TValueWr : in  STD_LOGIC;
				  TValueRd : out  STD_LOGIC;
				  TWr : in  STD_LOGIC;
				  Clk : in  STD_LOGIC;
				  Rst : in  STD_LOGIC);
	end component;
	
	component ZCMP is
    Port ( Data : in  STD_LOGIC_VECTOR(15 downto 0);
           ZF : out  STD_LOGIC);
	end component;
	
	component EXCP is
		 Port ( IfPf : in  STD_LOGIC;
				  MemPc : in  STD_LOGIC_VECTOR(15 downto 0);
				  NPc : in  STD_LOGIC_VECTOR(15 downto 0);
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
				  BrchPc : out  StD_LOGIC_VECTOR(15 downto 0);
				  ExcpPrep : out  STD_LOGIC;
				  Lf : in  STD_LOGIC;
				  ExcpTr : out  STD_LOGIC;
				  ExcpInsn : out  STD_LOGIC_VECTOR(19 downto 0);
				  Clk : in  STD_LOGIC;
				  Rst : in  STD_LOGIC);
	end component;
	
	component LFLAG is
		 Port ( Degrade : in  STD_LOGIC;
				  ExcpTr : in  STD_LOGIC;
				  Lf : out  STD_LOGIC;
				  Clk : in  STD_LOGIC;
				  Rst : in  STD_LOGIC);
	end component;
	
	-- ��ˮ�߶����ź�
	
	-- PC->MMIO�Ĵ�ȡָ���ַ
	signal IfAddr : std_logic_vector(15 downto 0);
	-- PC->BRCH��PC->IF/ID��PCֵ����ǰPC�Ĵ���ֵ+1��
	signal IfPc : std_logic_vector(15 downto 0);
	-- BRCH->PC����һ��PCֵ
	signal IfNPc : std_logic_vector(15 downto 0);
	-- MMIO->IF/ID��ָ��
	signal IfInsn : std_logic_vector(15 downto 0);
	-- VM->IF/ID���쳣�ź�
	signal IfPf : std_logic;
	-- IF/ID->MUX_INSN��ָ��
	signal IdInsn : std_logic_vector(15 downto 0);
	-- MUX_INSN->ID��ָ��
	signal IdExInsn : std_logic_vector(19 downto 0);
	-- IF/ID->ID/EXE��PCֵ
	signal IdPc : std_logic_vector(15 downto 0);
	-- IF/ID->ID/EXE��ҳ�쳣
	signal IdIfPf : std_logic;
	-- ID->REGS��Reg1�ź�
	signal IdReg1 : std_logic_vector(3 downto 0);
	-- ID->REGS��Reg2�ź�
	signal IdReg2 : std_logic_vector(3 downto 0);
	-- ID->ID/EXE��Imm������
	signal IdImm : std_logic_vector(15 downto 0);
	-- ID->ID/EXE��RegDst�ź�
	signal IdRegDst : std_logic_vector(3 downto 0);
	-- ID->ID/EXE��Op1Src�ź�
	signal IdOp1Src : std_logic;
	-- ID->ID/EXE��Op2Src�ź�
	signal IdOp2Src : std_logic;
	-- ID->ID/EXE��AluOp�ź�
	signal IdAluOp : std_logic_vector(3 downto 0);
	-- ID->ID/EXE��TWr�ź�
	signal IdTWr : std_logic;
	-- ID->ID/EXE��Jcond�ź�
	signal IdJcond : std_logic_vector(2 downto 0);
	-- ID->ID/EXE��MemRd�ź�
	signal IdMemRd : std_logic;
	-- ID->ID/EXE��MemWr�ź�
	signal IdMemWr : std_logic;
	-- ID->ID/EXE��RegWr�ź�
	signal IdRegWr : std_logic;
	-- ID->ID/EXE�ķǷ�ָ���쳣
	signal IdInval : std_logic;
	-- ID->ID/EXE��Ȩ��ָ���쳣
	signal IdPriv : std_logic;
	-- ID->ID/EXE��INTָ���ź�
	signal IdInt : std_logic;
	-- ID->ID/EXE�Ľ������м��ź�
	signal IdDegrade : std_logic;
	-- REGS->ID/EXE��Data1����
	signal IdData1 : std_logic_vector(15 downto 0);
	-- REGS->ID/EXE��Data2����
	signal IdData2 : std_logic_vector(15 downto 0);
	-- ID/EXE->MUX1��Data1����
	signal ExeData1 : std_logic_vector(15 downto 0);
	-- ID/EXE->MUX2��MUX3��Data2����
	signal ExeData2 : std_logic_vector(15 downto 0);
	-- ID/EXE->FWD��HAZD��Reg1�ź�
	signal ExeReg1 : std_logic_vector(3 downto 0);
	-- ID/EXE->FWD��HAZD��Reg2�ź�
	signal ExeReg2 : std_logic_vector(3 downto 0);
	-- ID/EXE->EXE/MEM��RegDst�ź�
	signal ExeRegDst : std_logic_vector(3 downto 0);
	-- ID/EXE->MUX3��Immֵ
	signal ExeImm : std_logic_vector(15 downto 0);
	-- ID/EXE->FWD��Op1Src�ź�
	signal ExeOp1Src : std_logic;
	-- ID/EXE->FWD��Op2Src�ź�
	signal ExeOp2Src : std_logic;
	-- ID/EXE->MUX1��EXE_MEM��PCֵ
	signal ExePc : std_logic_vector(15 downto 0);
	-- ID/EXE->ALU��AluOp�ź�
	signal ExeAluOp : std_logic_vector(3 downto 0);
	-- ID/EXE->EXE/MEM��Jcond�ź�
	signal ExeJcond : std_logic_vector(2 downto 0);
	-- ID/EXE->EXE/MEM��TWr�ź�
	signal ExeTWr : std_logic;
	-- ID/EXE->EXE/MEM��MemRd�ź�
	signal ExeMemRd : std_logic;
	-- ID/EXE->EXE/MEM��MemWr�ź�
	signal ExeMemWr : std_logic;
	-- ID/EXE->EXE/MEM��RegWr�ź�
	signal ExeRegWr : std_logic;
	-- ID/EXE->EXE/MEM��IfPf�쳣
	signal ExeIfPf : std_logic;
	-- ID/EXE->EXE/MEM�ķǷ�ָ���쳣
	signal ExeInval : std_logic;
	-- ID/EXE->EXE/MEM��Ȩ��ָ���쳣
	signal ExePriv : std_logic;
	-- ID/EXE->EXE/MEM��INT
	signal ExeInt : std_logic;
	-- ID/EXE->EXE/MEM�Ľ������м�
	signal ExeDegrade : std_logic;
	-- ALU->EXE/MEM��AluRes������
	signal ExeAluRes : std_logic_vector(15 downto 0);
	-- ALU->EXE/MEM��Bool����������
	signal ExeBool : std_logic;
	-- FWD->MUX1��ѡ���ź�
	signal ExeFwd1 : std_logic_vector(1 downto 0);
	-- FWD->MUX2��ѡ���ź�
	signal ExeFwd2 : std_logic_vector(1 downto 0);
	-- FWD->MUX3��ѡ���ź�
	signal ExeFwd3 : std_logic_vector(1 downto 0);
	-- MUX1->ALU�ĵ�һ������
	signal ExeOp1 : std_logic_vector(15 downto 0);
	-- MUX2->ALU�ĵڶ�������
	signal ExeOp2 : std_logic_vector(15 downto 0);
	-- MUX3->EXE/MEM��ZCMP��Data2����
	signal ExeFData2 : std_logic_vector(15 downto 0);
	-- ZCMP->EXE/MEM�����־λ
	signal ExeZf : std_logic;
	-- EXE/MEM->COND��PCֵ
	signal MemPc : std_logic_vector(15 downto 0);
	-- EXE/MEM->T���±�־
	signal MemBool : std_logic;
	-- EXE/MEM->BRCH��MEM/WB��MMIO����PC/ALU������/�ڴ��ַ
	signal MemAluRes : std_logic_vector(15 downto 0);
	-- EXE/MEM->MMIO��BRCH�Ĵ�д������/��PC
	signal MemData2 : std_logic_vector(15 downto 0);
	-- EXE/MEM->TFLAG��д���ź�
	signal MemTWr : std_logic;
	-- EXE/MEM->COND����ת����
	signal MemJcond : std_logic_vector(2 downto 0);
	-- EXE/MEM->MMIO��MEM/WB��FWD��HAZD��MemRd�ź�
	signal MemMemRd : std_logic;
	-- EXE/MEM->MMIO��FWD��HAZD��MemWr�ź�
	signal MemMemWr : std_logic;
	-- EXE/MEM->MEM/WB��FWD��RegWr�ź�
	signal MemRegWr : std_logic;
	-- EXE/MEM->MEM/WB��FWD��HAZD��RegDst�ź�
	signal MemRegDst : std_logic_vector(3 downto 0);
	-- EXE/MEM->EXCP��IfPf�쳣
	signal MemIfPf : std_logic;
	-- EXE/MEM->EXCP��II�쳣
	signal MemInval : std_logic;
	-- EXE/MEM->EXCP����Ȩָ���쳣
	signal MemPriv : std_logic;
	-- EXE/MEM->EXCP��INT�쳣
	signal MemInt : std_logic;
	-- EXE/MEM->LFLAG�Ľ������м��ź�
	signal MemDegrade : std_logic;
	-- VM->EXCP��Page Fault
	signal MemMemPf : std_logic;
	-- T->COND�������ź�
	signal MemTf : std_logic;
	-- COND->BRCH��ָ����ת�ź�
	signal MemJFlag : std_logic;
	-- COND->BRCH����PC�ź�
	signal MemNPc : std_logic_vector(15 downto 0); 
	-- EXE/MEM->COND��ZCMP���
	signal MemZf : std_logic;
	-- MMIO->MEM/WB�Ķ�������
	signal MemMemData : std_logic_vector(15 downto 0);
	-- MEM/WB->MUX4��ALU������
	signal WbAluRes : std_logic_vector(15 downto 0);
	-- MEM/WB->MUX4���ڴ�����
	signal WbMemData : std_logic_vector(15 downto 0);
	-- MEM/WB->MUX4��ѡ���ź�
	signal WbMemRd : std_logic;
	-- MEM/WB->REGS��FWD��RegDst�ź�
	signal WbRegDst : std_logic_vector(3 downto 0);
	-- MEM/WB->REGS��FWD��RegWr�ź�
	signal WbRegWr : std_logic;
	-- MUX4->REGS��MUX1��MUX2��MUX3��д������
	signal WbData : std_logic_vector(15 downto 0);
	
	-- ȫ���ź�
	-- REGS->EXCP��IntEn��־
	signal IntEn : std_logic;
	-- HAZD->PC�ı����ź�
	signal HoldPc : std_logic;
	-- HAZD->IF/ID��ID/EXE�ı����ź�
	signal HoldReg : std_logic;
	-- HAZD->BUBBLE�������ź�
	signal BubHz : std_logic_vector(2 downto 0);
	-- BUBBLE->IF/ID�������ź�
	signal BubFD : std_logic;
	-- BUBBLE->ID/EXE�������ź�
	signal BubDE : std_logic;
	-- BUBBLE->EXE/MEM�������ź�
	signal BubEM : std_logic;
	-- BRCH->BUBBLE�������ź�
	signal BubBr : std_logic_vector(2 downto 0);
	-- EXCP->BUBBLE�������ź�
	signal BubEx : std_logic_vector(2 downto 0);
	-- EXCP->MUX_INSN��BRCH��ExcpPrep�ź�
	signal ExcpPrep : std_logic;
	-- EXCP->MUX_INSN��ָ��
	signal ExcpInsn : std_logic_vector(19 downto 0);
	-- EXCP->LFLAG��REGS��ExcpTr�ź�
	signal ExcpTr : std_logic;
	-- EXCP->BRCH��BrchPc
	signal BrchPc : std_logic_vector(15 downto 0);
	-- LFLAG->ID��EXCP����Ȩ��
	signal Lf : std_logic;
begin

	PC1 : PC port map (
		Rst => Rst,
		Clk => Clk,
		PcValueRd => IfAddr,
		PcPlus1 => IfPc,
		PcValueWr => IfNPc,
		Hold => HoldPc
	);
	
	MMIO1 : MMIO port map (
		IfAddr => IfAddr,
		Insn => IfInsn,
		MemAddr => MemAluRes,
		MemDataWr => MemData2,
		MemDataRd => MemMemData,
		MemRd => MemMemRd,
		MemWr => MemMemWr,
		Ram2Addr => Ram2Addr,
		Ram2Data => Ram2Data,
		Ram2WE => Ram2WE,
		Ram2OE => Ram2OE,
		Clk => Clk
	);
	
	IF_ID1 : IF_ID port map (
		InsnWr => IfInsn,
		InsnRd => IdInsn,
		PcWr => IfPc,
		PcRd => IdPc,
		IfPfWr => IfPf,
		IfPfRd => IdIfPf,
		Bubble => BubFD,
		Hold => HoldReg,
		Clk => Clk,
		Rst => Rst
	);
	
	IdExInsn <= "0000" & IdInsn when ExcpPrep = '0' else
					ExcpInsn;
	
	ID1 : ID port map (
		Lf => Lf,
		Insn => IdExInsn,
		Reg1 => IdReg1,
		Reg2 => IdReg2,
		RegDst => IdRegDst,
		Imm => IdImm,
		Op1Src => IdOp1Src,
		Op2Src => IdOp2Src,
		AluOp => IdAluOp,
		TWr => IdTWr,
		Jcond => IdJcond,
		MemRd => IdMemRd,
		MemWr => IdMemWr,
		RegWr => IdRegWr,
		Inval => IdInval,
		Priv => IdPriv,
		Int => IdInt,
		Degrade => IdDegrade
	);
	
	REGS1 : REGS port map (
		Reg1 => IdReg1,
		Reg2 => IdReg2,
		Data1 => IdData1,
		Data2 => IdData2,
		RegWr => WbRegWr,
		RegDataWr => WbData,
		RegDst => WbRegDst,
		IntEn => IntEn,
		IntHdl => ExcpTr,
		Clk => Clk,
		Rst => Rst
	);
	
	ID_EXE1 : ID_EXE port map (
		Data1Wr => IdData1,
		Data2Wr => IdData2,
		Reg1Wr => IdReg1,
		Reg2Wr => IdReg2,
		RegDstWr => IdRegDst,
		ImmWr => IdImm,
		PcWr => IdPc,
		Op1SrcWr => IdOp1Src,
		Op2SrcWr => IdOp2Src,
		AluOpWr => IdAluOp,
		TWrWr => IdTWr,
		JcondWr => IdJcond,
		MemRdWr => IdMemRd,
		MemWrWr => IdMemWr,
		RegWrWr => IdRegWr,
		IfPfWr => IdIfPf,
		IdInvalWr => IdInval,
		IdPrivWr => IdPriv,
		IntWr => IdInt,
		DegradeWr => IdDegrade,
		Data1Rd => ExeData1,
		Data2Rd => ExeData2,
		Reg1Rd => ExeReg1,
		Reg2Rd => ExeReg2,
		RegDstRd => ExeRegDst,
		ImmRd => ExeImm,
		PcRd => ExePc,
		Op1SrcRd => ExeOp1Src,
		Op2SrcRd => ExeOp2Src,
		AluOpRd => ExeAluOp,
		TWrRd => ExeTWr,
		JcondRd => ExeJcond,
		MemRdRd => ExeMemRd,
		MemWrRd => ExeMemWr,
		RegWrRd => ExeRegWr,
		IfPfRd => ExeIfPf,
		IdInvalRd => ExeInval,
		IdPrivRd => ExePriv,
		IntRd => ExeInt,
		DegradeRd => ExeDegrade,
		Bubble => BubDE,
		Hold => HoldReg,
		Clk => Clk,
		Rst => Rst
	);
	
	MUX_1 : MUX4 port map (
		X0 => ExeData1,
		X1 => ExePc,
		X2 => MemAluRes,
		X3 => WbData,
		Y => ExeOp1,
		Sel => ExeFwd1
	);
	
	MUX_2 : MUX4 port map (
		X0 => ExeData2,
		X1 => ExeImm,
		X2 => MemAluRes,
		X3 => WbData,
		Y => ExeOp2,
		Sel => ExeFwd2
	);
	
	MUX_3 : MUX4 port map (
		X0 => ExeData2,
		X1 => MemAluRes,
		X2 => WbData,
		X3 => "0000000000000000",
		Y => ExeFData2,
		Sel => ExeFwd3
	);
	
	ZCMP1 : ZCMP port map (
		Data => ExeFData2,
		ZF => ExeZf
	);
	
	FWD1 : FWD port map (
		MemRdM => MemMemRd,
		RegDstM => MemRegDst,
		RegWrM => MemRegWr,
		RegDstW => WbRegDst,
		RegWrW => WbRegWr,
		Reg1 => ExeReg1,
		Reg2 => ExeReg2,
		Op1Src => ExeOp1Src,
		Op2Src => ExeOp2Src,
		Fwd1 => ExeFwd1,
		Fwd2 => ExeFwd2,
		Fwd3 => ExeFwd3
	);
	
	ALU1 : ALU port map (
		Op1 => ExeOp1,
		Op2 => ExeOp2,
		AluOp => ExeAluOp,
		AluRes => ExeAluRes,
		Bool => ExeBool
	);
	
	EXE_MEM1 : EXE_MEM port map (
		RegDstWr => ExeRegDst,
		PcWr => ExePc,
		BoolWr => ExeBool,
		AluResWr => ExeAluRes,
		ZFWr => ExeZf,
		Data2Wr => ExeFData2,
		TWrWr => ExeTWr,
		JcondWr => ExeJcond,
		MemRdWr => ExeMemRd,
		MemWrWr => ExeMemWr,
		RegWrWr => ExeRegWr,
		IfPfWr => ExeIfPf,
		IdInvalWr => ExeInval,
		IdPrivWr => ExePriv,
		IntWr => ExeInt,
		DegradeWr => ExeDegrade,
		RegDstRd => MemRegDst,
		PcRd => MemPc,
		BoolRd => MemBool,
		AluResRd => MemAluRes,
		ZFRd => MemZf,
		Data2Rd => MemData2,
		TWrRd => MemTWr,
		JcondRd => MemJcond,
		MemRdRd => MemMemRd,
		MemWrRd => MemMemWr,
		RegWrRd => MemRegWr,
		IfPfRd => MemIfPf,
		IdInvalRd => MemInval,
		IdPrivRd => MemPriv,
		IntRd => MemInt,
		DegradeRd => MemDegrade,
		Bubble => BubEM,
		Clk => Clk,
		Rst => Rst
	);
	
	TFLAG1 : TFLAG port map (
		TValueWr => MemBool,
		TValueRd => MemTf,
		TWr => MemTWr,
		Clk => Clk,
		Rst => Rst
	);
	
	COND1 : COND port map (
		TF => MemTf,
		ZF => MemZf,
		Jcond => MemJcond,
		Pc => MemPc,
		AluRes => MemAluRes,
		Data2 => MemData2,
		NPc => MemNPc,
		JFlag => MemJFlag
	);
	
	MEM_WB1 : MEM_WB port map (
		AluResWr => MemAluRes,
		MemDataWr => MemMemData,
		RegDstWr => MemRegDst,
		MemRdWr => MemMemRd,
		RegWrWr => MemRegWr,
		AluResRd => WbAluRes,
		MemDataRd => WbMemData,
		RegDstRd => WbRegDst,
		MemRdRd => WbMemRd,
		RegWrRd => WbRegWr,
		Clk => Clk,
		Rst => Rst
	);
	
	MUX_4 : MUX2 port map (
		X0 => WbAluRes,
		X1 => WbMemData,
		Y => WbData,
		Sel => WbMemRd
	);
	
	BRCH1 : BRCH port map (
		Pc => IfPc,
		NPc => IfNPc,
		MemPc => MemPc,
		MemNPc => MemNPc,
		Jcond => MemJcond,
		JFlag => MemJFlag,
		ExcpPrep => ExcpPrep,
		EPc => BrchPc,
		Bubble => BubBr,
		Clk => Clk,
		Rst => Rst
	);
	
	BUBBLE1 : BUBBLE port map (
		BubBr => BubBr,
		BubHz => BubHz,
		BubEx => BubEx,
		BubFD => BubFD,
		BubDE => BubDE,
		BubEM => BubEM
	);
	
	HAZD1 : HAZD port map (
		MemRd => MemMemRd,
		MemWr => MemMemWr,
		RegDst => MemRegDst,
		Reg1 => ExeReg1,
		Reg2 => ExeReg2,
		HoldReg => HoldReg,
		HoldPc => HoldPc,
		Bubble => BubHz
	);
	
	EXCP1 : EXCP port map (
		IfPf => MemIfPf,
		MemPc => MemPc,
		NPc => MemNPc,
		BrchPc => BrchPc,
		IdInval => MemInval,
		IdPriv => MemPriv,
		MemPf => MemMemPf,
		MemVA => MemAluRes,
		MemWr => MemMemWr,
		IntInsn => MemInt,
		IntEn => IntEn,
		IntTimer => IntTimer,
		IntKb => IntKb,
		BubExcp => BubEx,
		ExcpPrep => ExcpPrep,
		Lf => Lf,
		ExcpTr => ExcpTr,
		ExcpInsn => ExcpInsn,
		Clk => Clk,
		Rst => Rst
	);
	
	LFLAG1 : LFLAG port map (
		Degrade => MemDegrade,
		ExcpTr => ExcpTr,
		Lf => Lf,
		Clk => Clk,
		Rst => Rst
	);
	
	-- ΪVMԤ�����ź�
	MemMemPf <= '0';
	IfPf <= '0';
	
	-- DEBUG�ź�
	DbInsnAddr <= IfAddr;
	DbIfPc <= IfPc;
	DbIfNPc <= IfNPc;
	DbMemJcond <= MemJcond;
	DbMemNPc <= MemNPc;
	DbBrchEPc <= BrchPc;
	DbMemPc <= MemPc;

end Behavioral;

