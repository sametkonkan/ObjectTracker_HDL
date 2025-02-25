-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\accumulatorBankVar.vhd
-- Created: 2024-12-03 00:37:46
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: accumulatorBankVar
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Preprocess/CurrPreprocess/Image Statistics/calcMean/accumulatorBankVar
-- Hierarchy Level: 5
-- Model version: 3.7
-- 
-- Accumulator Bank - Accumulate over the 64, [64x64], [64x64x64], [64x64x64x64] windows
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ObjectTrackerHDL_pkg.ALL;

ENTITY accumulatorBankVar IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        dataIn                            :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
        normalized                        :   IN    std_logic_vector(39 DOWNTO 0);  -- ufix40_En24
        processPixel                      :   IN    std_logic;
        lvlOneCount                       :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
        lvlTwoEn                          :   IN    std_logic;
        lvlTwoCount                       :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
        lvlThreeEn                        :   IN    std_logic;
        lvlThreeCount                     :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
        lvlFourEn                         :   IN    std_logic;
        lvlFourCount                      :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
        lvlOneAcc                         :   OUT   std_logic_vector(39 DOWNTO 0);  -- ufix40_En18
        lvlTwoAcc                         :   OUT   std_logic_vector(39 DOWNTO 0);  -- ufix40_En18
        lvlThreeAcc                       :   OUT   std_logic_vector(39 DOWNTO 0);  -- ufix40_En18
        lvlFourAcc                        :   OUT   std_logic_vector(39 DOWNTO 0)  -- ufix40_En18
        );
END accumulatorBankVar;


ARCHITECTURE rtl OF accumulatorBankVar IS

  -- Signals
  SIGNAL processPixelD                    : std_logic;
  SIGNAL lvlOneCount_unsigned             : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL lvlOneRST                        : std_logic;
  SIGNAL dataIn_unsigned                  : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL intdelay_reg                     : vector_of_unsigned16(0 TO 2);  -- ufix16 [3]
  SIGNAL dataInD                          : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL dataInCast                       : unsigned(21 DOWNTO 0);  -- ufix22
  SIGNAL lvlOneAdd                        : unsigned(21 DOWNTO 0);  -- ufix22
  SIGNAL lvlOneAdd_1                      : unsigned(21 DOWNTO 0);  -- ufix22
  SIGNAL lvlOneInitMuxOut                 : unsigned(21 DOWNTO 0);  -- ufix22
  SIGNAL lvlOneAcc_tmp                    : unsigned(39 DOWNTO 0);  -- ufix40_En18
  SIGNAL lvlTwoCount_unsigned             : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL lvlTwoRST                        : std_logic;
  SIGNAL normalized_unsigned              : unsigned(39 DOWNTO 0);  -- ufix40_En24
  SIGNAL lvlTwoAccIn                      : unsigned(27 DOWNTO 0);  -- ufix28_En6
  SIGNAL lvlTwoAccDelay                   : unsigned(27 DOWNTO 0);  -- ufix28_En6
  SIGNAL lvlTwoAdd                        : unsigned(27 DOWNTO 0);  -- ufix28_En6
  SIGNAL lvlTwoInitMuxOut                 : unsigned(27 DOWNTO 0);  -- ufix28_En6
  SIGNAL lvlTwoAcc_tmp                    : unsigned(39 DOWNTO 0);  -- ufix40_En18
  SIGNAL lvlThreeCount_unsigned           : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL lvlThreeRST                      : std_logic;
  SIGNAL lvlThreeAccIn                    : unsigned(33 DOWNTO 0);  -- ufix34_En12
  SIGNAL lvlThreeAccDelay                 : unsigned(33 DOWNTO 0);  -- ufix34_En12
  SIGNAL lvlThreeAdd                      : unsigned(33 DOWNTO 0);  -- ufix34_En12
  SIGNAL lvlThreeInitMuxOut               : unsigned(33 DOWNTO 0);  -- ufix34_En12
  SIGNAL lvlThreeAcc_tmp                  : unsigned(39 DOWNTO 0);  -- ufix40_En18
  SIGNAL lvlFourCount_unsigned            : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL lvlFourRST                       : std_logic;
  SIGNAL lvlFourAccIn                     : unsigned(39 DOWNTO 0);  -- ufix40_En18
  SIGNAL lvlFourAccDelay                  : unsigned(39 DOWNTO 0);  -- ufix40_En18
  SIGNAL lvlFourAdd                       : unsigned(39 DOWNTO 0);  -- ufix40_En18
  SIGNAL lvlFourInitMuxOut                : unsigned(39 DOWNTO 0);  -- ufix40_En18

BEGIN
  reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      processPixelD <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        processPixelD <= processPixel;
      END IF;
    END IF;
  END PROCESS reg_process;


  lvlOneCount_unsigned <= unsigned(lvlOneCount);

  -- Reset at 64 Pixels Accumulated
  
  lvlOneRST <= '1' WHEN lvlOneCount_unsigned = to_unsigned(16#00#, 6) ELSE
      '0';

  dataIn_unsigned <= unsigned(dataIn);

  -- Delay Balancing
  intdelay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      intdelay_reg <= (OTHERS => to_unsigned(16#0000#, 16));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        intdelay_reg(0) <= dataIn_unsigned;
        intdelay_reg(1 TO 2) <= intdelay_reg(0 TO 1);
      END IF;
    END IF;
  END PROCESS intdelay_process;

  dataInD <= intdelay_reg(2);

  dataInCast <= resize(dataInD, 22);

  -- lvlOne Accumulation
  lvlOneAdd_1 <= dataInCast + lvlOneAdd;

  -- Reset lvlOne Accumulator REG to Current Input
  
  lvlOneInitMuxOut <= lvlOneAdd_1 WHEN lvlOneRST = '0' ELSE
      dataInCast;

  -- Enabled by dataReadFSM
  reg_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      lvlOneAdd <= to_unsigned(16#000000#, 22);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' AND processPixelD = '1' THEN
        lvlOneAdd <= lvlOneInitMuxOut;
      END IF;
    END IF;
  END PROCESS reg_1_process;


  lvlOneAcc_tmp <= lvlOneAdd & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0';

  lvlOneAcc <= std_logic_vector(lvlOneAcc_tmp);

  lvlTwoCount_unsigned <= unsigned(lvlTwoCount);

  -- Reset at 64 Pixels Accumulated
  
  lvlTwoRST <= '1' WHEN lvlTwoCount_unsigned = to_unsigned(16#00#, 6) ELSE
      '0';

  normalized_unsigned <= unsigned(normalized);

  lvlTwoAccIn <= resize(normalized_unsigned(39 DOWNTO 18), 28);

  -- lvlTwo Accumulation
  lvlTwoAdd <= lvlTwoAccIn + lvlTwoAccDelay;

  -- Reset lvlTwo Accumulator REG to Current Input
  
  lvlTwoInitMuxOut <= lvlTwoAdd WHEN lvlTwoRST = '0' ELSE
      lvlTwoAccIn;

  -- Enabled by dataWriteFSM
  reg_2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      lvlTwoAccDelay <= to_unsigned(16#0000000#, 28);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' AND lvlTwoEn = '1' THEN
        lvlTwoAccDelay <= lvlTwoInitMuxOut;
      END IF;
    END IF;
  END PROCESS reg_2_process;


  lvlTwoAcc_tmp <= lvlTwoAccDelay & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0';

  lvlTwoAcc <= std_logic_vector(lvlTwoAcc_tmp);

  lvlThreeCount_unsigned <= unsigned(lvlThreeCount);

  -- Reset at 64 Pixels Accumulated
  
  lvlThreeRST <= '1' WHEN lvlThreeCount_unsigned = to_unsigned(16#00#, 6) ELSE
      '0';

  lvlThreeAccIn <= resize(normalized_unsigned(39 DOWNTO 12), 34);

  -- lvlThree Accumulation
  lvlThreeAdd <= lvlThreeAccIn + lvlThreeAccDelay;

  -- Reset lvlThree Accumulator REG to Current Input
  
  lvlThreeInitMuxOut <= lvlThreeAdd WHEN lvlThreeRST = '0' ELSE
      lvlThreeAccIn;

  -- Enabled by dataWriteFSM
  reg_3_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      lvlThreeAccDelay <= to_unsigned(0, 34);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' AND lvlThreeEn = '1' THEN
        lvlThreeAccDelay <= lvlThreeInitMuxOut;
      END IF;
    END IF;
  END PROCESS reg_3_process;


  lvlThreeAcc_tmp <= lvlThreeAccDelay & '0' & '0' & '0' & '0' & '0' & '0';

  lvlThreeAcc <= std_logic_vector(lvlThreeAcc_tmp);

  lvlFourCount_unsigned <= unsigned(lvlFourCount);

  -- Reset at 64 Pixels Accumulated
  
  lvlFourRST <= '1' WHEN lvlFourCount_unsigned = to_unsigned(16#00#, 6) ELSE
      '0';

  lvlFourAccIn <= resize(normalized_unsigned(39 DOWNTO 6), 40);

  -- lvlFour Accumulation
  lvlFourAdd <= lvlFourAccIn + lvlFourAccDelay;

  -- Reset lvlFour Accumulator REG to Current Input
  
  lvlFourInitMuxOut <= lvlFourAdd WHEN lvlFourRST = '0' ELSE
      lvlFourAccIn;

  -- Enabled by dataWriteFSM
  reg_4_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      lvlFourAccDelay <= to_unsigned(0, 40);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' AND lvlFourEn = '1' THEN
        lvlFourAccDelay <= lvlFourInitMuxOut;
      END IF;
    END IF;
  END PROCESS reg_4_process;


  lvlFourAcc <= std_logic_vector(lvlFourAccDelay);

END rtl;

