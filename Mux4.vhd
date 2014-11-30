----------------------------------------------------------------------------------
-- 元件名称：Mux4四选一多路选择器
-- 功能描述：根据Sel选择值从四个输入中选择一个线路传输到Y
-- 端口描述：
-- 	X0,X1,X2,X3	输入
--		Sel 			选择子
--		Y				输出
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux4 is
    Port ( X0 : in  STD_LOGIC_VECTOR(15 downto 0);
           X1 : in  STD_LOGIC_VECTOR(15 downto 0);
           X2 : in  STD_LOGIC_VECTOR(15 downto 0);
           X3 : in  STD_LOGIC_VECTOR(15 downto 0);
           Y : out  STD_LOGIC_VECTOR(15 downto 0);
           Sel : in  STD_LOGIC_VECTOR(1 downto 0));
end Mux4;

architecture Behavioral of Mux4 is
begin
	with Sel select
		Y <=  X0 when "00",
				X1 when "01",
				X2 when "10",
				X3 when "11",
				"0000000000000000" when others;
end Behavioral;

