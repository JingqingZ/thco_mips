----------------------------------------------------------------------------------
-- 元件名称：TFLAG寄存器
-- 功能描述：读取T标志位或者修改T标志位
-- 行为描述：随时可以从TValueRd端口读取当前T标志位；当时钟上升沿到来时，如果TWr为高电平，则在
-- 	TvalueWr的值写入寄存器
-- 端口描述：
-- 	TValueWr 	新T标志值
-- 	TValueRd 	当前T标志
-- 	TWr 			允许修改T值
-- 	Clk			时钟信号
-- 	Rst 			复位信号
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TFLAG is
    Port ( TValueWr : in  STD_LOGIC;
           TValueRd : out  STD_LOGIC;
           TWr : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC);
end TFLAG;

architecture Behavioral of TFLAG is
signal T : std_logic;
begin
	TValueRd <= T;
	
	process(Rst,Clk)
	begin
		if Rst = '0' then
			T <= '0';
		elsif rising_edge(Clk) then
			case TWr is
				when '1' => T <= TValueWr;
				when others => -- 什么都不做
			end case;
		end if;
	end process;
end Behavioral;

