----------------------------------------------------------------------------------
-- 元件名称：ZCMP零比较器
-- 功能描述：判断输入的16位数据是否为0
-- 行为描述：当输入为0时，输出为1；当输入非零时，输出为0
-- 端口描述：
-- 	Data	输入的16位数
--		ZF		表明输入是否为0的标志位
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ZCMP is
    Port ( Data : in  STD_LOGIC_VECTOR(15 downto 0);
           ZF : out  STD_LOGIC);
end ZCMP;

architecture Behavioral of ZCMP is
begin
	with Data select
		ZF <= '1' when "0000000000000000",
				'0' when others;
end Behavioral;
