----------------------------------------------------------------------------------
-- 元件名称：EXE/MEM段流水线寄存器
-- 行为描述：Bubble为0时，在Clk上升沿写入寄存器；Bubble = 1时，产生气泡
-- 端口描述：
--		XXXWr为各个寄存器的写入端，XXXRd为各个寄存器的读取端
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EXE_MEM is
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
end EXE_MEM;

architecture Behavioral of EXE_MEM is
signal RegDst : STD_LOGIC_VECTOR(3 downto 0);
signal Pc : STD_LOGIC_VECTOR(15 downto 0);
signal Bool : STD_LOGIC;
signal AluRes : STD_LOGIC_VECTOR(15 downto 0);
signal ZF : STD_LOGIC;
signal Data2 : STD_LOGIC_VECTOR(15 downto 0);
signal TWr : STD_LOGIC;
signal Jcond : STD_LOGIC_VECTOR(2 downto 0);
signal MemRd : STD_LOGIC;
signal MemWr : STD_LOGIC;
signal RegWr :  STD_LOGIC; 
signal IfPf : STD_LOGIC;
signal IdInval : STD_LOGIC;
signal IdPriv : STD_LOGIC;
signal Int : STD_LOGIC;
signal Degrade : STD_LOGIC;
begin
	RegDstRd <= RegDst;
	PcRd <= Pc;
	BoolRd <= Bool;
	AluResRd <= AluRes;
	ZFRd <= ZF;
	Data2Rd <= Data2;
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
	
	-- 写入操作
	process(Rst,Clk)
	begin
		if Rst = '0' then
			RegDst <= "1111";
			Pc <= "0000000000000000";
			Bool <= '0';
			AluRes <= "0000000000000000";
			ZF <= '0';
			Data2 <= "0000000000000000";
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
			if Bubble = '1' then -- 气泡
				RegDst <= "1111";
				Pc <= "0000000000000000";
				Bool <= '0';
				AluRes <= "0000000000000000";
				ZF <= '0';
				Data2 <= "0000000000000000";
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
				RegDst <= RegDstWr;
				Pc <= PcWr;
				Bool <= BoolWr;
				AluRes <= AluResWr;
				ZF <= ZFWr;
				Data2 <= Data2Wr;
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
	end process;
end Behavioral;

