----------------------------------------------------------------------------------
-- 元件名称：BRCH分支控制器
-- 功能描述：根据分支预测记录找到合适的下一PC值，控制段寄存器的气泡，相应中断
-- 行为描述：如果Jcond == 0，那么，从分支预测记录中按照OldPc查找到相应的项，
-- 	将该项的值传给NPc；如果Jcond != 0，
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

	-- 分支预测寄存器的写入端口
	signal KeyWr : std_logic_vector(15 downto 0);
	signal ValWr : std_logic_vector(15 downto 0);
	
	-- 分支预测寄存器的读取端口
	signal KeyRd : std_logic_vector(15 downto 0);
	signal ValRd : std_logic_vector(15 downto 0);
	
	-- 分支预测寄存器的写入控制端口
	signal KeyWrEn : std_logic;
	signal ValWrEn : std_logic;
	
	-- 分支预测寄存器
	component REG16 is
		 Port ( DataWr : in  STD_LOGIC_VECTOR(15 downto 0);
				  DataRd : out  STD_LOGIC_VECTOR(15 downto 0);
				  Wr : in  STD_LOGIC;
				  Clk : in  STD_LOGIC;
				  Rst : in  STD_LOGIC);
	end component;
	
begin
	-- 连接寄存器
	Key : REG16 port map (DataWr => KeyWr, DataRd => KeyRd, Wr => KeyWrEn, Clk => Clk, Rst => Rst);
	Val : REG16 port map (DataWr => ValWr, DataRd => ValRd, Wr => ValWrEn, Clk => Clk, Rst => Rst);
	
	
	-- IF阶段中，传入PC+1的值（也就是该元件的Pc端口），返回这个值或者AluRes/Data2（如果在MEM阶段的指令传来跳转信号）
	process(Pc, MemPc, MemNPc, Jcond, JFlag, KeyRd, ValRd, ExcpPrep, EPc)
	begin
		-- 为保证电路的组合逻辑性，这里必须设置好所有输出端口的值,即使我们不需要传递任何信息。
		KeyWrEn <= '0';
		ValWrEn <= '0';
		KeyWr <= "0000000000000000";
		ValWr <= "0000000000000000";
		Bubble <= "000";
		
		if ExcpPrep = '1' then -- 中断到来并且必须被响应
			NPc <= EPc; -- 这应该是中断准备程序入口地址
		else -- 无中断
			if Jcond = "000" then -- MEM阶段指令不是跳转指令
				if Pc = KeyRd then
					NPc <= ValRd;
				else
					NPc <= Pc;
				end if;
			else -- MEM阶段的指令为跳转指令，将这个指令存入分支预测表中，并检测预测是否成功
				-- 是否在分支预测寄存器中
				if MemPc = KeyRd then
					if MemNPc = ValRd then -- 预测成功，不气泡
						NPc <= Pc;
					else -- 预测失败，已经进入流水线的三条后续指令作废
						NPc <= MemNPc;
						ValWr <= MemNPc;
						ValWrEn <= '1';
						Bubble <= "111";
					end if;
				else -- 不在表项里
					if JFlag = '0' then -- 虽然是跳转指令，但是该指令没有执行跳转操作
						NPc <= Pc;
					else -- 必须跳转，已经进入流水线的指令作废
						-- 记录新的分支预测点
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

