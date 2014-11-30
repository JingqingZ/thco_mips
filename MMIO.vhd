----------------------------------------------------------------------------------
-- 元件名称：MMIO内存与端口访问模块
-- 功能描述：读取/修改内存单元/访问串口
-- 行为描述：前半个周期元件不工作，等待输入信号；时钟下降沿触发操作。如果有MEM阶段访存操作，就忽略
--		IF阶段的取指令操作（直接返回NOP指令），并完成读写操作（给出对应的信号）。否则，就取指令。
-- 端口描述：
-- 	IfAddr 		取指令的指令地址
-- 	Insn			取出的指令内容
--		MemAddr 		MEM阶段访问的内存地址
--		MemDataWr 	待写入内存数据
--		MemDataRd	从内存中读出的数据
--		MemRd			MEM阶段的MemRd信号
--		MemWr			MEM阶段的MemWr信号
--		Ram2Addr		连接RAM2的A信号
--		Ram2Data		连接RAM2的D信号
--		Ram2WE		RAM2的写使能信号
--		Ram2OE		RAM2的输出使能信号
--		Clk			时钟信号		
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MMIO is
    Port ( IfAddr : in  STD_LOGIC_VECTOR(15 downto 0);
           Insn : out  STD_LOGIC_VECTOR(15 downto 0);
           MemAddr : in  STD_LOGIC_VECTOR(15 downto 0);
           MemDataWr : in  STD_LOGIC_VECTOR(15 downto 0);
           MemDataRd : out  STD_LOGIC_VECTOR(15 downto 0);
           MemRd : in  STD_LOGIC;
           MemWr : in  STD_LOGIC;
			  Ram2Addr : out  STD_LOGIC_VECTOR(15 downto 0);
			  Ram2Data : inout  STD_LOGIC_VECTOR(15 downto 0);
			  Ram2WE :  out STD_LOGIC;
			  Ram2OE :  out STD_LOGIC;
			  Clk :  in STD_LOGIC);
end MMIO;

architecture Behavioral of MMIO is
begin
	Ram2Addr <= IfAddr when MemRd = '0' and MemWr = '0' else MemAddr;
	Ram2Data <= MemDataWr when MemWr = '1' else "ZZZZZZZZZZZZZZZZ";
	Insn <= Ram2Data when MemRd = '0' and MemWr = '0' else "0000100000000000"; -- NOP
	MemDataRd <= Ram2Data when MemRd = '1' else "0000000000000000";
	Ram2OE <= '0' when MemWr = '0' and Clk = '0' else '1';
	Ram2WE <= (not MemWr) or Clk;
end Behavioral;

