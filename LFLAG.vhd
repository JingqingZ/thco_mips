----------------------------------------------------------------------------------
-- 元件名称：LFLAG运行级寄存器
-- 功能描述：CPU运行级
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LFLAG is
    Port ( Degrade : in  STD_LOGIC;
           ExcpTr : in  STD_LOGIC;
           Lf : out  STD_LOGIC;
			  Clk : in  STD_LOGIC;
			  Rst : in  STD_LOGIC);
end LFLAG;

architecture Behavioral of LFLAG is
begin
	process(Clk, Rst)
	begin
		if Rst = '0' then
			Lf <= '0';
		elsif rising_edge(Clk) then
			if ExcpTr = '1' then
				Lf <= '0';
			elsif Degrade = '1' then
				Lf <= '1';
			end if;
		end if;
	end process;
end Behavioral;

