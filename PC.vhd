----------------------------------------------------------------------------------
-- 元件名称：PC寄存器
-- 功能描述：PC寄存器存储将要取指令的指令地址。
-- 行为描述：在任何状态下，可以从PcValueRd端口读出当前PC值。当需要修改PC寄存器时，将新PC值输入PcValueWr
--		端口，等待时钟上升沿到来时完成写入操作。例外情况是Hold为高电平时，不执行写入操作。
-- 端口描述：
-- 	Clk			时钟信号（时钟上升沿触发写入操作）
-- 	PcValueRd	读取当前PC寄存器值的端口
--		PcValueWr	写入新PC值的端口（时钟上升沿到达时触发写入操作）
--		Hold			保持PC值不变的控制信号（Hold为高电平时拒绝写入新PC值）
--		Rst			复位信号 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity PC is
    Port ( Rst: in  STD_LOGIC;
           Clk: in  STD_LOGIC;
           PcValueRd : out  STD_LOGIC_VECTOR(15 downto 0);
			  PcPlus1 : out  STD_LOGIC_VECTOR(15 downto 0);
           PcValueWr : in  STD_LOGIC_VECTOR(15 downto 0);
			  Hold : in STD_LOGIC);
end PC;

architecture Behavioral of PC is
signal PcValue : STD_LOGIC_VECTOR(15 downto 0);
begin
	PcValueRd <= PcValue;
	PcPlus1 <= PcValue + 1;
	
	-- 写入操作Process
	process(Rst,Clk)
	begin
		if Rst = '0' then
			PcValue <= "0000000000000000"; -- 此处应该为初始PC值，也就是系统程序的入口地址
		elsif rising_edge(Clk) then
			case Hold is
				when '0' => PcValue <= PcValueWr;
				when others => -- 什么都不做
			end case;
		end if;
	end process;
end Behavioral;

