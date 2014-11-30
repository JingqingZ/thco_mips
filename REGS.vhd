----------------------------------------------------------------------------------
-- 元件名称：REGS寄存器堆
-- 功能描述：通用寄存器和特殊寄存器的存储元件
-- 行为描述：从读取方面看，Data1和Data2分别输出根据Reg1和Reg2所指定的寄存器值。从写入方面看，
-- 	将待写入的数据放入RegDataWr，将所要写入的寄存器编号放入RegDst，将写入控制信号RegWr置为
--		高电平，当时钟上升沿到来时，新的数据即可写入到目的寄存器。但是为了满足中断需要，有如下规定：
-- 	不能通过一般的写入操作来修改中断号寄存器IC和中断PC寄存器EPC。在中断发生时，IntHdl被置为
-- 	高电平，IntCode和EPc分别被赋值为中断号和中断点PC值，在这种情况下，时钟上升沿触发这两个数据
-- 	写入对应的寄存器。寄存器编号规则为，通用寄存器的编号与通用寄存器的名字一致，特殊寄存器的编号为
--		SP=1000(8), IH=1001(9), RA=1010(10), IC=1011(11), EP=1100(12), ZERO=1111(15)
-- 端口描述：
-- 	Reg1		第一个待读取寄存器编号
--		Reg2 		第二个待读取寄存器编号
--		Data1		第一个待读取寄存器的值
--		Data2		第二个待读取寄存器的值
--		RegWr		寄存器写入控制信号（高电平时允许写入操作）
--		RegDataWr待写入数据
--		RegDst	被写入寄存器的编号
--		IntEn		IH的最高位（高电平时允许中断）
--		IntHdl	中断处理控制信号（高电平时修改IC和EP两个中断寄存器）
--		Clk		时钟信号
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REGS is
    Port ( Reg1 : in  STD_LOGIC_VECTOR(3 downto 0);
           Reg2 : in  STD_LOGIC_VECTOR(3 downto 0);
           Data1 : out  STD_LOGIC_VECTOR(15 downto 0);
           Data2 : out  STD_LOGIC_VECTOR(15 downto 0);
           RegWr : in  STD_LOGIC;
           RegDataWr : in  STD_LOGIC_VECTOR(15 downto 0);
           RegDst : in  STD_LOGIC_VECTOR(3 downto 0);
           IntEn : out  STD_LOGIC;
           IntHdl : in  STD_LOGIC;
			  Clk : in  STD_LOGIC;
			  Rst : in  STD_LOGIC);
end REGS;

architecture Behavioral of REGS is
signal R0, R1, R2, R3, R4, R5, R6, R7, SP, IH, RA, ER, KP, UP : STD_LOGIC_VECTOR(15 downto 0);
begin

	-- 读取寄存器的组合电路
	with Reg1 select
		Data1 <= R0 when "0000",
					R1 when "0001",
					R2 when "0010",
					R3 when "0011",
					R4 when "0100",
					R5 when "0101",
					R6 when "0110",
					R7 when "0111",
					SP when "1000",
					IH when "1001",
					RA when "1010",
					ER when "1011",
					KP when "1100",
					UP when "1101",
					"0000000000000000" when others;

	with Reg2 select
		Data2 <= R0 when "0000",
					R1 when "0001",
					R2 when "0010",
					R3 when "0011",
					R4 when "0100",
					R5 when "0101",
					R6 when "0110",
					R7 when "0111",
					SP when "1000",
					IH when "1001",
					RA when "1010",
					ER when "1011",
					KP when "1100",
					UP when "1101",
					"0000000000000000" when others;

	-- IH最高位
	IntEn <= IH(15);

	-- 写入寄存器
	process(Rst, Clk)
	begin
		if Rst = '0' then
			R0 <= "0000000000000000";
			R1 <= "0000000000000000";
			R2 <= "0000000000000000";
			R3 <= "0000000000000000";
			R4 <= "0000000000000000";
			R5 <= "0000000000000000";
			R6 <= "0000000000000000";
			R7 <= "0000000000000000";
			SP <= "0000000000000000"; -- 此处应该为堆栈起始地址
			IH <= "0000000000000000"; -- 默认关闭中断，最高位为0
			RA <= "0000000000000000";
			ER <= "0000000000000000";
			KP <= "0000000000000000";
			UP <= "0000000000000000";
		elsif falling_edge(Clk) then
			case RegWr is
				when '1' => -- 修改除了中断寄存器IC和EP之外的寄存器
					case RegDst is
						when "0000" => R0 <= RegDataWr;
						when "0001" => R1 <= RegDataWr;
						when "0010" => R2 <= RegDataWr;
						when "0011" => R3 <= RegDataWr;
						when "0100" => R4 <= RegDataWr;
						when "0101" => R5 <= RegDataWr;
						when "0110" => R6 <= RegDataWr;
						when "0111" => R7 <= RegDataWr;
						when "1000" => SP <= RegDataWr;
						when "1001" => IH <= RegDataWr;
						when "1010" => RA <= RegDataWr;
						when "1011" => ER <= RegDataWr;
						when "1100" => KP <= RegDataWr;
						when "1101" => UP <= RegDataWr;
						when others => -- 错误的寄存器编号，什么都不做
					end case;
				when others => -- 什么都不做
			end case;
			case IntHdl is
				when '1' =>
					IH(15) <= '0';
				when others => -- 什么都不做
			end case;
		end if;
	end process;

end Behavioral;

