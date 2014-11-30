----------------------------------------------------------------------------------
-- 元件名称：Mux2二选一多路选择器
-- 功能描述：根据Sel选择值从两个输入中选择一个线路传输到Y
-- 端口描述：
-- 	X0,X1	输入
--		Sel 	选择子
--		Y		输出
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux2 is
    Port ( X0 : in  STD_LOGIC_VECTOR(15 downto 0);
           X1 : in  STD_LOGIC_VECTOR(15 downto 0);
           Y : out  STD_LOGIC_VECTOR(15 downto 0);
           Sel : in  STD_LOGIC);
end Mux2;

architecture Behavioral of Mux2 is
begin
	with Sel select
		Y <=  X0 when '0',
				X1 when '1',
				"0000000000000000" when others;
end Behavioral;

