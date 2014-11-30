----------------------------------------------------------------------------------
-- 元件名称：EXCP中断异常处理器
-- 功能描述：对中断与异常进行相应，准备并调用中断服务程序
-- 行为描述：EXCP对MEM阶段指令进行监控，如果该阶段的指令产生异常（或者该指令在之前的阶段已经产生异常，
--		但是直到这个阶段才进行处理），那么就将异常触发信号ExcpTr置为1（该操作导致CPU进入内核态，
--		也就是LFLAG在下一个时钟上升沿被置为0，也导致IH最高位清零），通过BubExcp信号将前三个阶段作废。在时钟上升沿到来时，
--		检测是否有异常发生，如果有，就从状态0进入状态3（Lf为0时）或者状态1(Lf为1时)，并将ExcpPrep置为1。这时，异常
-- 	处理器进入异常准备状态机。
--		状态0：无异常状态。ExcpPrep置0。如果有异常信号，就起泡化前三个阶段，并进入异常状态1或3。否则，维持无异常状态。
--		状态1：ExcpPrep置1，气泡化IF/ID寄存器，传送指令SVUP
--		状态2：ExcpPrep置1，气泡化IF/ID寄存器，传送指令LDKP
--		状态3：ExcpPrep置1，气泡化IF/ID寄存器，传送指令LI_ER EPc
--		状态4：ExcpPrep置1，气泡化IF/ID寄存器，传送指令SW_ER -1
--		状态5：ExcpPrep置1，气泡化IF/ID寄存器，传送指令LI_ER ENo
--		状态6：ExcpPrep置1，气泡化IF/ID寄存器，传送指令SW_ER -2
--		状态7：ExcpPrep置1，气泡化IF/ID寄存器，传送指令LI_ER Reason
--		状态8：ExcpPrep置1，气泡化IF/ID寄存器，传送指令SW_ER -3 
--		状态9：ExcpPrep置1，气泡化IF/ID寄存器，传送指令LI_ER Addr
--		状态10：ExcpPrep置1，气泡化IF/ID寄存器，传送指令SW_ER -4
-- 	状态11：ExcpPrep置1，气泡化IF/ID寄存器，传送指令SUBU SP 4 ==> 0
--		
--		对于外部中断，处理方法与异常类似。只有当外部中断存在且IntEn标志位1时，才进入状态0或者3.
--
-- 端口描述：
--		IfPf		从IF阶段一直传递而来的PageFault信号
--		MemPc		MEM阶段的PC值
--		NPc		MEM阶段得知的下一个指令地址
--		IdInval	从ID阶段一直传递而来的非法指令信号
--		IdPriv	在用户级执行内核级指令
--		Insn     异常指令内容
--		MemPf		MEM阶段产生的PageFault信号
--		MemVA		MEM阶段所访问的虚拟内存地址
--		MemWr		MEM阶段是否为写内存
--		IntInsn	运行到INT指令
--		IntEn		中断允许标志位
--		IntTimer	外部时钟中断管脚
--		IntKb		外部键盘中断管脚
--		BubExcp	气泡化段寄存器的信号
--		ExcpPrep	异常处理准备阶段信号
--		ExcpInsn	异常处理器传递出的指令
-- 	ExcpTr	异常产生时的信号，表明进入异常处理过程
--		Lf			CPU运行级
--		Clk		时钟信号
--
--	异常与中断号与指令处理方法：
--		0 		非法指令，重新执行 II = Invalid Instruction
-- 	1		页异常，重新执行 PF = Page Fault
--		2		特权指令，重新执行 PI = Privileged Instruction
--		3		中断指令，从下一条指令执行 INT = Interrupt Instruction
--		16		计数器中断，从下一条指令执行
--		17		键盘中断，从下一条指令执行
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
	
	-- 组合逻辑位，有异常状态的标志
	signal ExcpFlag : std_logic;
	
	-- 寄存器，异常号
	signal ENo : std_logic_vector(15 downto 0);
	
	-- 寄存器，EPc，可能为触发异常的指令，也可能为下一条指令。总之，就是从异常中恢复后应该执行的指令
	signal EPc : std_logic_vector(15 downto 0);
	
	-- 寄存器，Reason，对于错误指令和非法指令存储该指令，对于页异常存储异常状态（0位为运行级，1位为写入操作）
	signal Reason : std_logic_vector(15 downto 0);
	
	-- 寄存器，Addr，对于页异常存储访问的内存单元地址
	signal Addr : std_logic_vector(15 downto 0);
	
	-- 寄存器，状态机的下一状态
	signal NextState : std_logic_vector(3 downto 0);
	
	-- 组合逻辑，状态机的当前状态
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
			BrchPc <= "0000000000000011"; -- 中断服务程序入口
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

