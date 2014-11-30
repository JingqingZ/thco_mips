----------------------------------------------------------------------------------
-- 元件名称：COND跳转条件判断器
-- 功能描述：在跳转模式Jcond下，根据当前的输入TF/ZF来决定是否跳转（或者说新PC值的来源）
-- 行为描述：当Jcond=0时，不跳转，此时忽略TF/ZF的值；
-- 	Jcond=1时，必须跳转，新PC值为ALU计算结果，此时忽略TF/ZF的值；
-- 	Jcond=2时，如果TF为0，就跳转，新PC值为ALU计算结果，否则，不跳转；
-- 	Jcond=3时，如果TF为1，就跳转，新PC值为ALU计算结果，否则，不跳转；
--		Jcond=4时，如果ZF为0，就跳转，新PC值为ALU计算结果，否则，不跳转；
-- 	Jcond=5时，如果ZF为1，就跳转，新PC值为ALU计算结果，否则，不跳转；
-- 	Jcond=6时，必须跳转，新PC值为寄存器堆Data2。
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COND is
    Port ( TF : in  STD_LOGIC;
           ZF : in  STD_LOGIC;
           Jcond : in  STD_LOGIC_VECTOR(2 downto 0);
			  Pc : in  STD_LOGIC_VECTOR(15 downto 0);
			  AluRes : in  STD_LOGIC_VECTOR(15 downto 0);
			  Data2 : in  STD_LOGIC_VECTOR(15 downto 0);
           NPc : out  STD_LOGIC_VECTOR(15 downto 0);
			  JFlag : out  STD_LOGIC);
end COND;

architecture Behavioral of COND is
begin
	process(TF,ZF,Jcond,Pc,AluRes,Data2)
	begin
		JFlag <= '0';
		case Jcond is
			when "000" => -- No
				NPc <= Pc;
			when "001" => -- 无条件跳转
				NPc <= AluRes;
				JFlag <= '1';
			when "010" => -- TF=0跳转
				if TF = '0' then
					NPc <= AluRes;
					JFlag <= '1';
				else
					NPc <= Pc;
				end if;
			when "011" => -- TF=1跳转
				if TF = '1' then
					NPc <= AluRes;
					JFlag <= '1';
				else
					NPc <= Pc;
				end if;
			when "100" => -- ZF=0跳转
				if ZF = '0' then
					NPc <= AluRes;
					JFlag <= '1';
				else
					NPc <= Pc;
				end if;
			when "101" => -- ZF=1跳转
				if ZF = '1' then
					NPc <= AluRes;
					JFlag <= '1';
				else
					NPc <= Pc;
				end if;
			when "110" => -- 无条件跳转，来源为Data2
				NPc <= Data2;
				JFlag <= '1';
			when others => -- 错误输入，不跳转
				NPc <= Pc;
		end case;
	end process;
end Behavioral;

