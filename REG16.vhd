----------------------------------------------------------------------------------
-- 元件名称：16位通用寄存器
-- 功能描述：通用寄存器，时钟上升沿到来时写入数据。
-- 端口描述：
-- 	DataWr 	数据写入端
-- 	DataRd 	数据读取端
--		Clk		时钟信号
-- 	Rst		复位信号
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REG16 is
    Port ( DataWr : in  STD_LOGIC_VECTOR(15 downto 0);
           DataRd : out  STD_LOGIC_VECTOR(15 downto 0);
			  Wr : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC);
end REG16;

architecture Behavioral of REG16 is
signal Data : std_logic_vector(15 downto 0);
begin
	DataRd <= Data;
	
	process(Rst, Clk)
	begin
		if Rst = '0' then
			Data <= "0000000000000000";
		elsif rising_edge(Clk) then
			if Wr = '1' then
				Data <= DataWr;
			end if;
		end if;
	end process;
end Behavioral;

