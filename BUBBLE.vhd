----------------------------------------------------------------------------------
-- 元件名称：气泡控制器
-- 功能描述：接收气泡信号并控制段寄存器
-- 端口描述：
-- 	BubBr BRCH元件的气泡信号
-- 	BubHZ HAZD元件的气泡信号
--		BubFD IF/ID寄存器的控制信号
--		BubDE ID/EXE寄存器的控制信号
--		BubEM EXE/MEM寄存器的控制信号
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BUBBLE is
    Port ( BubBr : in  STD_LOGIC_VECTOR(2 downto 0);
           BubHz : in  STD_LOGIC_VECTOR(2 downto 0);
			  BubEx : in  STD_LOGIC_VECTOR(2 downto 0);
           BubFD : out  STD_LOGIC;
           BubDE : out  STD_LOGIC;
           BubEM : out  STD_LOGIC);
end BUBBLE;

architecture Behavioral of BUBBLE is
begin
	BubFD <= BubBr(2) or BubHz(2) or BubEx(2);
	BubDE <= BubBr(1) or BubHz(1) or BubEx(1);
	BubEM <= BubBr(0) or BubHz(0) or BubEx(0);
end Behavioral;

