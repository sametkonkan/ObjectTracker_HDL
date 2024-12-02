-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\calcMean.vhd
-- Created: 2024-12-03 00:37:46
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: calcMean
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Preprocess/CurrPreprocess/Image Statistics/calcMean
-- Hierarchy Level: 4
-- Model version: 3.7
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY calcMean IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        dataIn                            :   IN    std_logic_vector(7 DOWNTO 0);  -- ufix8
        hStart                            :   IN    std_logic;
        hEnd                              :   IN    std_logic;
        vStart                            :   IN    std_logic;
        vEnd                              :   IN    std_logic;
        validIn                           :   IN    std_logic;
        mean                              :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32_En24
        meanSq                            :   OUT   std_logic_vector(39 DOWNTO 0);  -- ufix40_En24
        validOut                          :   OUT   std_logic
        );
END calcMean;


ARCHITECTURE rtl OF calcMean IS

  -- Component Declarations
  COMPONENT dataReadFSM
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          hStart                          :   IN    std_logic;
          hEnd                            :   IN    std_logic;
          vStart                          :   IN    std_logic;
          vEnd                            :   IN    std_logic;
          dataValid                       :   IN    std_logic;
          processPixel                    :   OUT   std_logic;
          lineReset                       :   OUT   std_logic;
          frameStart                      :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT counterBank
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          lineReset                       :   IN    std_logic;
          frameStart                      :   IN    std_logic;
          processPixel                    :   IN    std_logic;
          lvlTwoEn                        :   IN    std_logic;
          lvlThreeEn                      :   IN    std_logic;
          lvlFourEn                       :   IN    std_logic;
          endFlag                         :   IN    std_logic;
          lvlOneCount                     :   OUT   std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlTwoCount                     :   OUT   std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlThreeCount                   :   OUT   std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlFourCount                    :   OUT   std_logic_vector(5 DOWNTO 0)  -- ufix6
          );
  END COMPONENT;

  COMPONENT dataWriteFSM
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          vEnd                            :   IN    std_logic;
          vEndD                           :   IN    std_logic;
          lvlOneCount                     :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlTwoCount                     :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlThreeCount                   :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlFourCount                    :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          pipeCount                       :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
          vStart                          :   IN    std_logic;
          LUTDepthforMulPix               :   IN    std_logic_vector(6 DOWNTO 0);  -- ufix7
          LUTDepth                        :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlTwoEn                        :   OUT   std_logic;
          lvlThreeEn                      :   OUT   std_logic;
          lvlFourEn                       :   OUT   std_logic;
          SEL                             :   OUT   std_logic_vector(1 DOWNTO 0);  -- ufix2
          outEn                           :   OUT   std_logic;
          pipeRst                         :   OUT   std_logic;
          pipeEn                          :   OUT   std_logic;
          endFL                           :   OUT   std_logic;
          normFlag                        :   OUT   std_logic;
          countReset                      :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT accumulatorBank
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          dataIn                          :   IN    std_logic_vector(7 DOWNTO 0);  -- ufix8
          normalized                      :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En24
          processPixel                    :   IN    std_logic;
          lvlOneCount                     :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlTwoEn                        :   IN    std_logic;
          lvlTwoCount                     :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlThreeEn                      :   IN    std_logic;
          lvlThreeCount                   :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlFourEn                       :   IN    std_logic;
          lvlFourCount                    :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlOneAcc                       :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32_En18
          lvlTwoAcc                       :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32_En18
          lvlThreeAcc                     :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32_En18
          lvlFourAcc                      :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32_En18
          );
  END COMPONENT;

  COMPONENT Normalization
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          lvlOneCount                     :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlTwoCount                     :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlThreeCount                   :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlFourCount                    :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          SEL                             :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
          lvlOneAcc                       :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En18
          lvlTwoAcc                       :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En18
          lvlThreeAcc                     :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En18
          lvlFourAcc                      :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En18
          normFlag                        :   IN    std_logic;
          Normalized                      :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32_En24
          );
  END COMPONENT;

  COMPONENT accumulatorBankVar
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          dataIn                          :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
          normalized                      :   IN    std_logic_vector(39 DOWNTO 0);  -- ufix40_En24
          processPixel                    :   IN    std_logic;
          lvlOneCount                     :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlTwoEn                        :   IN    std_logic;
          lvlTwoCount                     :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlThreeEn                      :   IN    std_logic;
          lvlThreeCount                   :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlFourEn                       :   IN    std_logic;
          lvlFourCount                    :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlOneAcc                       :   OUT   std_logic_vector(39 DOWNTO 0);  -- ufix40_En18
          lvlTwoAcc                       :   OUT   std_logic_vector(39 DOWNTO 0);  -- ufix40_En18
          lvlThreeAcc                     :   OUT   std_logic_vector(39 DOWNTO 0);  -- ufix40_En18
          lvlFourAcc                      :   OUT   std_logic_vector(39 DOWNTO 0)  -- ufix40_En18
          );
  END COMPONENT;

  COMPONENT Normalization_Var
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          lvlOneCount                     :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlTwoCount                     :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlThreeCount                   :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          lvlFourCount                    :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          SEL                             :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
          lvlOneAcc                       :   IN    std_logic_vector(39 DOWNTO 0);  -- ufix40_En18
          lvlTwoAcc                       :   IN    std_logic_vector(39 DOWNTO 0);  -- ufix40_En18
          lvlThreeAcc                     :   IN    std_logic_vector(39 DOWNTO 0);  -- ufix40_En18
          lvlFourAcc                      :   IN    std_logic_vector(39 DOWNTO 0);  -- ufix40_En18
          normFlag                        :   IN    std_logic;
          Normalized                      :   OUT   std_logic_vector(39 DOWNTO 0)  -- ufix40_En24
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : dataReadFSM
    USE ENTITY work.dataReadFSM(rtl);

  FOR ALL : counterBank
    USE ENTITY work.counterBank(rtl);

  FOR ALL : dataWriteFSM
    USE ENTITY work.dataWriteFSM(rtl);

  FOR ALL : accumulatorBank
    USE ENTITY work.accumulatorBank(rtl);

  FOR ALL : Normalization
    USE ENTITY work.Normalization(rtl);

  FOR ALL : accumulatorBankVar
    USE ENTITY work.accumulatorBankVar(rtl);

  FOR ALL : Normalization_Var
    USE ENTITY work.Normalization_Var(rtl);

  -- Signals
  SIGNAL vEndIn                           : std_logic;
  SIGNAL intdelay_reg                     : std_logic_vector(1 DOWNTO 0);  -- ufix1 [2]
  SIGNAL vEndOut                          : std_logic;
  SIGNAL vEndOut_1                        : std_logic;
  SIGNAL hStartIn                         : std_logic;
  SIGNAL hEndIn                           : std_logic;
  SIGNAL vStartIn                         : std_logic;
  SIGNAL dataValid                        : std_logic;
  SIGNAL processPixel                     : std_logic;
  SIGNAL lineReset                        : std_logic;
  SIGNAL frameStart                       : std_logic;
  SIGNAL lineResetD                       : std_logic;
  SIGNAL processPixelD                    : std_logic;
  SIGNAL LUTDepthforMulPix                : unsigned(6 DOWNTO 0);  -- ufix7
  SIGNAL LUTDepth                         : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL pipeRst                          : std_logic;
  SIGNAL pipeEn                           : std_logic;
  SIGNAL pipelineCount                    : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL endFlag                          : std_logic;
  SIGNAL endFlagD                         : std_logic;
  SIGNAL countReset                       : std_logic;
  SIGNAL frameStartD                      : std_logic;
  SIGNAL lvlTwoEn                         : std_logic;
  SIGNAL lvlThreeEn                       : std_logic;
  SIGNAL lvlFourEn                        : std_logic;
  SIGNAL lvlOneCount                      : std_logic_vector(5 DOWNTO 0);  -- ufix6
  SIGNAL lvlTwoCount                      : std_logic_vector(5 DOWNTO 0);  -- ufix6
  SIGNAL lvlThreeCount                    : std_logic_vector(5 DOWNTO 0);  -- ufix6
  SIGNAL lvlFourCount                     : std_logic_vector(5 DOWNTO 0);  -- ufix6
  SIGNAL SEL                              : std_logic_vector(1 DOWNTO 0);  -- ufix2
  SIGNAL outEn                            : std_logic;
  SIGNAL normFlag                         : std_logic;
  SIGNAL Normalized                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL lvlOneAcc                        : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL lvlTwoAcc                        : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL lvlThreeAcc                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL lvlFourAcc                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Normalized_unsigned              : unsigned(31 DOWNTO 0);  -- ufix32_En24
  SIGNAL mean_tmp                         : unsigned(31 DOWNTO 0);  -- ufix32_En24
  SIGNAL dataIn_unsigned                  : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL dataInSquare                     : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL normalizedVar                    : std_logic_vector(39 DOWNTO 0);  -- ufix40
  SIGNAL lvlOneAccVar                     : std_logic_vector(39 DOWNTO 0);  -- ufix40
  SIGNAL lvlTwoAccVar                     : std_logic_vector(39 DOWNTO 0);  -- ufix40
  SIGNAL lvlThreeAccVar                   : std_logic_vector(39 DOWNTO 0);  -- ufix40
  SIGNAL lvlFourAccVar                    : std_logic_vector(39 DOWNTO 0);  -- ufix40
  SIGNAL normalizedVar_unsigned           : unsigned(39 DOWNTO 0);  -- ufix40_En24
  SIGNAL meanSq_tmp                       : unsigned(39 DOWNTO 0);  -- ufix40_En24

BEGIN
  u_dataReadFSM : dataReadFSM
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              hStart => hStartIn,
              hEnd => hEndIn,
              vStart => vStartIn,
              vEnd => vEndIn,
              dataValid => dataValid,
              processPixel => processPixel,
              lineReset => lineReset,
              frameStart => frameStart
              );

  u_counterBank : counterBank
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              lineReset => lineResetD,
              frameStart => frameStartD,
              processPixel => processPixelD,
              lvlTwoEn => lvlTwoEn,
              lvlThreeEn => lvlThreeEn,
              lvlFourEn => lvlFourEn,
              endFlag => endFlagD,
              lvlOneCount => lvlOneCount,  -- ufix6
              lvlTwoCount => lvlTwoCount,  -- ufix6
              lvlThreeCount => lvlThreeCount,  -- ufix6
              lvlFourCount => lvlFourCount  -- ufix6
              );

  u_dataWriteFSM : dataWriteFSM
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              vEnd => vEndOut,
              vEndD => vEndOut_1,
              lvlOneCount => lvlOneCount,  -- ufix6
              lvlTwoCount => lvlTwoCount,  -- ufix6
              lvlThreeCount => lvlThreeCount,  -- ufix6
              lvlFourCount => lvlFourCount,  -- ufix6
              pipeCount => std_logic_vector(pipelineCount),  -- ufix2
              vStart => vStartIn,
              LUTDepthforMulPix => std_logic_vector(LUTDepthforMulPix),  -- ufix7
              LUTDepth => std_logic_vector(LUTDepth),  -- ufix6
              lvlTwoEn => lvlTwoEn,
              lvlThreeEn => lvlThreeEn,
              lvlFourEn => lvlFourEn,
              SEL => SEL,  -- ufix2
              outEn => outEn,
              pipeRst => pipeRst,
              pipeEn => pipeEn,
              endFL => endFlag,
              normFlag => normFlag,
              countReset => countReset
              );

  u_accumulatorBank : accumulatorBank
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              dataIn => dataIn,  -- ufix8
              normalized => Normalized,  -- ufix32_En24
              processPixel => processPixelD,
              lvlOneCount => lvlOneCount,  -- ufix6
              lvlTwoEn => lvlTwoEn,
              lvlTwoCount => lvlTwoCount,  -- ufix6
              lvlThreeEn => lvlThreeEn,
              lvlThreeCount => lvlThreeCount,  -- ufix6
              lvlFourEn => lvlFourEn,
              lvlFourCount => lvlFourCount,  -- ufix6
              lvlOneAcc => lvlOneAcc,  -- ufix32_En18
              lvlTwoAcc => lvlTwoAcc,  -- ufix32_En18
              lvlThreeAcc => lvlThreeAcc,  -- ufix32_En18
              lvlFourAcc => lvlFourAcc  -- ufix32_En18
              );

  u_normalization : Normalization
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              lvlOneCount => lvlOneCount,  -- ufix6
              lvlTwoCount => lvlTwoCount,  -- ufix6
              lvlThreeCount => lvlThreeCount,  -- ufix6
              lvlFourCount => lvlFourCount,  -- ufix6
              SEL => SEL,  -- ufix2
              lvlOneAcc => lvlOneAcc,  -- ufix32_En18
              lvlTwoAcc => lvlTwoAcc,  -- ufix32_En18
              lvlThreeAcc => lvlThreeAcc,  -- ufix32_En18
              lvlFourAcc => lvlFourAcc,  -- ufix32_En18
              normFlag => normFlag,
              Normalized => Normalized  -- ufix32_En24
              );

  u_accumulatorBankVar : accumulatorBankVar
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              dataIn => std_logic_vector(dataInSquare),  -- ufix16
              normalized => normalizedVar,  -- ufix40_En24
              processPixel => processPixelD,
              lvlOneCount => lvlOneCount,  -- ufix6
              lvlTwoEn => lvlTwoEn,
              lvlTwoCount => lvlTwoCount,  -- ufix6
              lvlThreeEn => lvlThreeEn,
              lvlThreeCount => lvlThreeCount,  -- ufix6
              lvlFourEn => lvlFourEn,
              lvlFourCount => lvlFourCount,  -- ufix6
              lvlOneAcc => lvlOneAccVar,  -- ufix40_En18
              lvlTwoAcc => lvlTwoAccVar,  -- ufix40_En18
              lvlThreeAcc => lvlThreeAccVar,  -- ufix40_En18
              lvlFourAcc => lvlFourAccVar  -- ufix40_En18
              );

  u_normalizationVar : Normalization_Var
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              lvlOneCount => lvlOneCount,  -- ufix6
              lvlTwoCount => lvlTwoCount,  -- ufix6
              lvlThreeCount => lvlThreeCount,  -- ufix6
              lvlFourCount => lvlFourCount,  -- ufix6
              SEL => SEL,  -- ufix2
              lvlOneAcc => lvlOneAccVar,  -- ufix40_En18
              lvlTwoAcc => lvlTwoAccVar,  -- ufix40_En18
              lvlThreeAcc => lvlThreeAccVar,  -- ufix40_En18
              lvlFourAcc => lvlFourAccVar,  -- ufix40_En18
              normFlag => normFlag,
              Normalized => normalizedVar  -- ufix40_En24
              );

  reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      vEndIn <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        vEndIn <= vEnd;
      END IF;
    END IF;
  END PROCESS reg_process;


  intdelay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      intdelay_reg <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        intdelay_reg(0) <= vEndIn;
        intdelay_reg(1) <= intdelay_reg(0);
      END IF;
    END IF;
  END PROCESS intdelay_process;

  vEndOut <= intdelay_reg(1);

  reg_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      vEndOut_1 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        vEndOut_1 <= vEndOut;
      END IF;
    END IF;
  END PROCESS reg_1_process;


  reg_2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      hStartIn <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        hStartIn <= hStart;
      END IF;
    END IF;
  END PROCESS reg_2_process;


  reg_3_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      hEndIn <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        hEndIn <= hEnd;
      END IF;
    END IF;
  END PROCESS reg_3_process;


  reg_4_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      vStartIn <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        vStartIn <= vStart;
      END IF;
    END IF;
  END PROCESS reg_4_process;


  reg_5_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      dataValid <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        dataValid <= validIn;
      END IF;
    END IF;
  END PROCESS reg_5_process;


  reg_6_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      lineResetD <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        lineResetD <= lineReset;
      END IF;
    END IF;
  END PROCESS reg_6_process;


  reg_7_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      processPixelD <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        processPixelD <= processPixel;
      END IF;
    END IF;
  END PROCESS reg_7_process;


  LUTDepthforMulPix <= to_unsigned(16#3F#, 7);

  LUTDepth <= to_unsigned(16#3F#, 6);

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 3
  -- Normalization Pipeline Counter
  PipelineCounter_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      pipelineCount <= to_unsigned(16#0#, 2);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        IF pipeRst = '1' THEN 
          pipelineCount <= to_unsigned(16#0#, 2);
        ELSIF pipeEn = '1' THEN 
          pipelineCount <= pipelineCount + to_unsigned(16#1#, 2);
        END IF;
      END IF;
    END IF;
  END PROCESS PipelineCounter_process;


  reg_8_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      endFlagD <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        endFlagD <= endFlag;
      END IF;
    END IF;
  END PROCESS reg_8_process;


  frameStartD <= frameStart OR countReset;

  Normalized_unsigned <= unsigned(Normalized);

  reg_9_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      mean_tmp <= to_unsigned(0, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' AND outEn = '1' THEN
        mean_tmp <= Normalized_unsigned;
      END IF;
    END IF;
  END PROCESS reg_9_process;


  mean <= std_logic_vector(mean_tmp);

  dataIn_unsigned <= unsigned(dataIn);

  dataInSquare <= dataIn_unsigned * dataIn_unsigned;

  normalizedVar_unsigned <= unsigned(normalizedVar);

  reg_10_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      meanSq_tmp <= to_unsigned(0, 40);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' AND outEn = '1' THEN
        meanSq_tmp <= normalizedVar_unsigned;
      END IF;
    END IF;
  END PROCESS reg_10_process;


  meanSq <= std_logic_vector(meanSq_tmp);

  reg_11_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      validOut <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        validOut <= outEn;
      END IF;
    END IF;
  END PROCESS reg_11_process;


END rtl;

