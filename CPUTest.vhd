--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY CPUTest IS
END CPUTest;
 
ARCHITECTURE behavior OF CPUTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CPU
    PORT(
         Clk : IN  std_logic;
         Rst : IN  std_logic;
         Ram2Data : INOUT  std_logic_vector(15 downto 0);
         Ram2Addr : OUT  std_logic_vector(15 downto 0);
         Ram2OE : OUT  std_logic;
         Ram2WE : OUT  std_logic;
         IntTimer : in  STD_LOGIC;
			IntKb : in  STD_LOGIC;
			DbInsnAddr : out STD_LOGIC_VECTOR(15 downto 0);
			DbIfPc : out  STD_LOGIC_VECTOR(15 downto 0);
			DbIfNPc : out  STD_LOGIC_VECTOR(15 downto 0);
			DbMemJcond : out  STD_LOGIC_VECTOR(2 downto 0);
			DbMemNPc : out  STD_LOGIC_VECTOR(15 downto 0);
			DbBrchEPc : out  STD_LOGIC_VECTOR(15 downto 0);
			DbMemPc : out  STD_LOGIC_VECTOR(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal IntTimer : std_logic := '0';
   signal IntKb : std_logic := '0';

	--BiDirs
   signal Ram2Data : std_logic_vector(15 downto 0);

 	--Outputs
   signal Ram2Addr : std_logic_vector(15 downto 0);
   signal Ram2OE : std_logic;
   signal Ram2WE : std_logic;
	signal DbInsnAddr : STD_LOGIC_VECTOR(15 downto 0);
	signal DbIfPc : STD_LOGIC_VECTOR(15 downto 0);
	signal DbIfNPc : STD_LOGIC_VECTOR(15 downto 0);
	signal DbMemJcond : STD_LOGIC_VECTOR(2 downto 0);
	signal DbMemNPc : STD_LOGIC_VECTOR(15 downto 0);
	signal DbBrchEPc : STD_LOGIC_VECTOR(15 downto 0);
	signal DbMemPc : STD_LOGIC_VECTOR(15 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CPU PORT MAP (
          Clk => Clk,
          Rst => Rst,
          Ram2Data => Ram2Data,
          Ram2Addr => Ram2Addr,
          Ram2OE => Ram2OE,
          Ram2WE => Ram2WE,
          IntTimer => IntTimer,
          IntKb => IntKb,
			 DbInsnAddr => DbInsnAddr,
			 DbIfPc => DbIfPc,
			 DbIfNPc => DbIfNPc,
			 DbMemJcond => DbMemJcond,
			 DbMemNPc => DbMemNPc,
			 DbBrchEPc => DbBrchEPc,
			 DbMemPc => DbMemPc
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '1';
		wait for Clk_period/2;
		Clk <= '0';
		wait for Clk_period/2;
   end process;
	
	ram2stim: process(Ram2Addr, Ram2OE)
	begin
		if Ram2OE = '0' then
			case Ram2Addr is
				when "0000000000000000" => Ram2Data <= "0110110100000001" ; 
				when "0000000000000001" => Ram2Data <= "0110110000000010" ;
				when "0000000000000010" => Ram2Data <= "0110111010000000" ; 
				when "0000000000000011" => Ram2Data <= "1001111001100010" ; 
				
				when "0000000000000100" => Ram2Data <= "1110001110001111" ; 
				when "0000000000000101" => Ram2Data <= "0110100100000001" ;
				when "0000000000000110" => Ram2Data <= "0110101000000001" ; 
				when "0000000000000111" => Ram2Data <= "1110000101010001" ; 
				
				when "0000000000001000" => Ram2Data <= "0100001000100000" ; 
				when "0000000000001001" => Ram2Data <= "0100010001000000" ;
				when "0000000000001010" => Ram2Data <= "1110001110101111" ; 
				when "0000000000001011" => Ram2Data <= "0010001100000001" ; 
				
				when "0000000000001100" => Ram2Data <= "0001011111111010" ;	 
				when "0000000000001101" => Ram2Data <= "1101111010000011" ;
				
				when "0000000010000010" => Ram2Data <= "0000000000001010" ;
				
				when others => Ram2Data <= "0000100000000000"; -- NOP
			end case;
		else
			Ram2Data <= "ZZZZZZZZZZZZZZZZ";
		end if;
	end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
	
      Rst <= '0';
      wait for 130 ns;
		Rst <= '1';

      wait;
   end process;

END;
