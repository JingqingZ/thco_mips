----------------------------------------------------------------------------------
-- 元件名称：IF/ID流水线寄存器
-- 行为描述：在Bubble/Hold均为低电平时，时钟上升沿触发寄存器写入操作；当Bubble为1，Hold为0时，
-- 	寄存器Insn值变为NOP指令，NPc为仍然写入的新NPc；当Hold为1，Bubble为0时，寄存器Insn和NPc
-- 	的值不因为时钟上升沿的到来而改变；当Bubble和Hold均为1时，Bubble优先，Insn变为NOP，NPc为
-- 	仍然写入的新NPc。
-- 端口描述：
-- 	InsnWr	Insn寄存器写入端
-- 	InsnRd	Insn寄存器读取端
--		PcWr		Pc寄存器写入端
--		PcRd 		Pc寄存器读取段
--		IfPfWr	IfPf信号写入端
--		IfPfRd	IfPf信号读取端
--		Bubble	气泡（使IF段无效）信号
-- 	Hold 		保持（阻塞该阶段）信号
--		Clk		时钟信号
--		Rst		复位信号
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IF_ID is
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
end IF_ID;

architecture Behavioral of IF_ID is
signal Insn, Pc : std_logic_vector(15 downto 0);
signal IfPf : std_logic;
begin
	InsnRd <= Insn;
	PcRd <= Pc;
	IfPfRd <= IfPf;
	
	process(Rst,Clk)
	begin
		if Rst = '0' then
			Insn <= "0000100000000000"; -- NOP指令
			Pc <= "0000000000000000";
			IfPf <= '0';
		elsif rising_edge(Clk) then
			if Bubble = '1' then -- 气泡操作
				Insn <= "0000100000000000"; -- NOP指令
				Pc <= PcWr;
				IfPf <= '0';
			else
				if Hold = '0' then -- 不保持（阻塞）操作
					Insn <= InsnWr;
					Pc <= PcWr;
					IfPf <= IfPfWr;
				end if;
			end if;
		end if;
	end process;
end Behavioral;

