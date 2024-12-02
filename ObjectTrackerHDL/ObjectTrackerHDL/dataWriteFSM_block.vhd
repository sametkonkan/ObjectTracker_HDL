-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\dataWriteFSM_block.vhd
-- Created: 2024-12-03 00:37:46
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: dataWriteFSM_block
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Preprocess/PrevPreprocess/Image Statistics/calcMean/dataWriteFSM
-- Hierarchy Level: 5
-- Model version: 3.7
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY dataWriteFSM_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        vEnd                              :   IN    std_logic;
        vEndD                             :   IN    std_logic;
        lvlOneCount                       :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
        lvlTwoCount                       :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
        lvlThreeCount                     :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
        lvlFourCount                      :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
        pipeCount                         :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        vStart                            :   IN    std_logic;
        LUTDepthforMulPix                 :   IN    std_logic_vector(6 DOWNTO 0);  -- ufix7
        LUTDepth                          :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
        lvlTwoEn                          :   OUT   std_logic;
        lvlThreeEn                        :   OUT   std_logic;
        lvlFourEn                         :   OUT   std_logic;
        SEL                               :   OUT   std_logic_vector(1 DOWNTO 0);  -- ufix2
        outEn                             :   OUT   std_logic;
        pipeRst                           :   OUT   std_logic;
        pipeEn                            :   OUT   std_logic;
        endFL                             :   OUT   std_logic;
        normFlag                          :   OUT   std_logic;
        countReset                        :   OUT   std_logic
        );
END dataWriteFSM_block;


ARCHITECTURE rtl OF dataWriteFSM_block IS

  -- Signals
  SIGNAL lvlOneCount_unsigned             : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL lvlTwoCount_unsigned             : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL lvlThreeCount_unsigned           : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL lvlFourCount_unsigned            : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL pipeCount_unsigned               : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL LUTDepthforMulPix_unsigned       : unsigned(6 DOWNTO 0);  -- ufix7
  SIGNAL LUTDepth_unsigned                : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL statsFSM_statState               : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL statsFSM_endFlag                 : std_logic;
  SIGNAL statsFSM_normOneFlag             : std_logic;
  SIGNAL statsFSM_inFrame                 : std_logic;
  SIGNAL statsFSM_statusComplete          : std_logic;
  SIGNAL statsFSM_statState_next          : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL statsFSM_endFlag_next            : std_logic;
  SIGNAL statsFSM_normOneFlag_next        : std_logic;
  SIGNAL statsFSM_inFrame_next            : std_logic;
  SIGNAL statsFSM_statusComplete_next     : std_logic;
  SIGNAL SEL_tmp                          : unsigned(1 DOWNTO 0);  -- ufix2

BEGIN
  lvlOneCount_unsigned <= unsigned(lvlOneCount);

  lvlTwoCount_unsigned <= unsigned(lvlTwoCount);

  lvlThreeCount_unsigned <= unsigned(lvlThreeCount);

  lvlFourCount_unsigned <= unsigned(lvlFourCount);

  pipeCount_unsigned <= unsigned(pipeCount);

  LUTDepthforMulPix_unsigned <= unsigned(LUTDepthforMulPix);

  LUTDepth_unsigned <= unsigned(LUTDepth);

  -- dataWriteFSM
  statsFSM_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      statsFSM_statState <= to_unsigned(16#0#, 4);
      statsFSM_endFlag <= '0';
      statsFSM_normOneFlag <= '0';
      statsFSM_inFrame <= '0';
      statsFSM_statusComplete <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        statsFSM_statState <= statsFSM_statState_next;
        statsFSM_endFlag <= statsFSM_endFlag_next;
        statsFSM_normOneFlag <= statsFSM_normOneFlag_next;
        statsFSM_inFrame <= statsFSM_inFrame_next;
        statsFSM_statusComplete <= statsFSM_statusComplete_next;
      END IF;
    END IF;
  END PROCESS statsFSM_process;

  statsFSM_output : PROCESS (LUTDepth_unsigned, LUTDepthforMulPix_unsigned, lvlFourCount_unsigned,
       lvlOneCount_unsigned, lvlThreeCount_unsigned, lvlTwoCount_unsigned,
       pipeCount_unsigned, statsFSM_endFlag, statsFSM_inFrame,
       statsFSM_normOneFlag, statsFSM_statState, statsFSM_statusComplete, vEnd,
       vStart)
    VARIABLE endFlag_temp : std_logic;
    VARIABLE normOneFlag_temp : std_logic;
  BEGIN
    endFlag_temp := statsFSM_endFlag;
    normOneFlag_temp := statsFSM_normOneFlag;
    statsFSM_statState_next <= statsFSM_statState;
    statsFSM_inFrame_next <= statsFSM_inFrame;
    statsFSM_statusComplete_next <= statsFSM_statusComplete;
    CASE statsFSM_statState IS
      WHEN "0000" =>
        lvlTwoEn <= '0';
        lvlThreeEn <= '0';
        lvlFourEn <= '0';
        outEn <= '0';
        pipeEn <= '0';
        pipeRst <= '1';
        SEL_tmp <= to_unsigned(16#0#, 2);
        countReset <= '0';
        IF ((resize(lvlOneCount_unsigned, 7) = LUTDepthforMulPix_unsigned) OR (vEnd = '1')) AND statsFSM_inFrame = '1' THEN 
          statsFSM_statState_next <= to_unsigned(16#5#, 4);
        ELSE 
          statsFSM_statState_next <= to_unsigned(16#0#, 4);
        END IF;
      WHEN "0001" =>
        lvlTwoEn <= '1';
        lvlThreeEn <= '0';
        lvlFourEn <= '0';
        outEn <= '0';
        pipeEn <= '0';
        pipeRst <= '1';
        SEL_tmp <= to_unsigned(16#0#, 2);
        countReset <= '0';
        IF lvlTwoCount_unsigned = LUTDepth_unsigned THEN 
          statsFSM_statState_next <= to_unsigned(16#6#, 4);
        ELSIF statsFSM_normOneFlag = '1' THEN 
          statsFSM_statState_next <= to_unsigned(16#9#, 4);
        ELSIF statsFSM_endFlag = '1' THEN 
          statsFSM_statState_next <= to_unsigned(16#6#, 4);
        ELSIF vEnd = '1' THEN 
          statsFSM_statState_next <= to_unsigned(16#5#, 4);
        ELSIF resize(lvlOneCount_unsigned, 7) /= LUTDepthforMulPix_unsigned THEN 
          statsFSM_statState_next <= to_unsigned(16#0#, 4);
        ELSE 
          statsFSM_statState_next <= to_unsigned(16#A#, 4);
        END IF;
        IF (vEnd = '1') AND (lvlTwoCount_unsigned = LUTDepth_unsigned) THEN 
          normOneFlag_temp := '1';
        END IF;
      WHEN "0010" =>
        lvlTwoEn <= '0';
        lvlThreeEn <= '1';
        lvlFourEn <= '0';
        outEn <= '0';
        pipeEn <= '0';
        pipeRst <= '1';
        SEL_tmp <= to_unsigned(16#0#, 2);
        countReset <= '0';
        IF statsFSM_normOneFlag = '1' THEN 
          statsFSM_statState_next <= to_unsigned(16#9#, 4);
        ELSIF statsFSM_endFlag = '1' OR (lvlThreeCount_unsigned = LUTDepth_unsigned) THEN 
          statsFSM_statState_next <= to_unsigned(16#7#, 4);
        ELSIF vEnd = '1' THEN 
          statsFSM_statState_next <= to_unsigned(16#5#, 4);
        ELSIF resize(lvlOneCount_unsigned, 7) /= LUTDepthforMulPix_unsigned THEN 
          statsFSM_statState_next <= to_unsigned(16#0#, 4);
        ELSE 
          statsFSM_statState_next <= to_unsigned(16#A#, 4);
        END IF;
        IF (vEnd = '1') AND ( NOT statsFSM_endFlag) = '1' THEN 
          normOneFlag_temp := '1';
        END IF;
      WHEN "0011" =>
        lvlTwoEn <= '0';
        lvlThreeEn <= '0';
        lvlFourEn <= '1';
        outEn <= '0';
        countReset <= '0';
        pipeEn <= '0';
        pipeRst <= '1';
        SEL_tmp <= to_unsigned(16#0#, 2);
        IF statsFSM_endFlag = '1' OR (lvlFourCount_unsigned = LUTDepth_unsigned) THEN 
          statsFSM_statState_next <= to_unsigned(16#8#, 4);
        ELSE 
          statsFSM_statState_next <= to_unsigned(16#0#, 4);
        END IF;
        statsFSM_statusComplete_next <= '0';
      WHEN "0100" =>
        lvlTwoEn <= '0';
        lvlThreeEn <= '0';
        lvlFourEn <= '0';
        outEn <=  NOT statsFSM_statusComplete;
        countReset <= '1';
        pipeEn <= '0';
        pipeRst <= '1';
        SEL_tmp <= to_unsigned(16#0#, 2);
        endFlag_temp := '0';
        statsFSM_statState_next <= to_unsigned(16#0#, 4);
        statsFSM_statusComplete_next <= '1';
      WHEN "0101" =>
        lvlTwoEn <= '0';
        lvlThreeEn <= '0';
        lvlFourEn <= '0';
        outEn <= '0';
        pipeEn <= '1';
        pipeRst <= '0';
        SEL_tmp <= to_unsigned(16#0#, 2);
        countReset <= '0';
        IF pipeCount_unsigned = to_unsigned(16#3#, 2) THEN 
          statsFSM_statState_next <= to_unsigned(16#1#, 4);
        ELSE 
          statsFSM_statState_next <= to_unsigned(16#5#, 4);
        END IF;
        IF vEnd = '1' THEN 
          normOneFlag_temp := '1';
        END IF;
      WHEN "0110" =>
        lvlTwoEn <= '0';
        lvlThreeEn <= '0';
        lvlFourEn <= '0';
        outEn <= '0';
        pipeEn <= '1';
        pipeRst <= '0';
        SEL_tmp <= to_unsigned(16#1#, 2);
        countReset <= '0';
        IF pipeCount_unsigned = to_unsigned(16#3#, 2) THEN 
          statsFSM_statState_next <= to_unsigned(16#2#, 4);
        ELSE 
          statsFSM_statState_next <= to_unsigned(16#6#, 4);
        END IF;
        IF (vEnd = '1') AND ( NOT statsFSM_endFlag) = '1' THEN 
          normOneFlag_temp := '1';
        END IF;
      WHEN "0111" =>
        lvlTwoEn <= '0';
        lvlThreeEn <= '0';
        lvlFourEn <= '0';
        outEn <= '0';
        pipeEn <= '1';
        pipeRst <= '0';
        SEL_tmp <= to_unsigned(16#2#, 2);
        countReset <= '0';
        IF pipeCount_unsigned = to_unsigned(16#3#, 2) THEN 
          statsFSM_statState_next <= to_unsigned(16#3#, 4);
        ELSE 
          statsFSM_statState_next <= to_unsigned(16#7#, 4);
        END IF;
      WHEN "1000" =>
        lvlTwoEn <= '0';
        lvlThreeEn <= '0';
        lvlFourEn <= '0';
        outEn <= '0';
        pipeEn <= '1';
        pipeRst <= '0';
        SEL_tmp <= to_unsigned(16#3#, 2);
        countReset <= '0';
        IF pipeCount_unsigned = to_unsigned(16#3#, 2) THEN 
          statsFSM_statState_next <= to_unsigned(16#4#, 4);
        ELSE 
          statsFSM_statState_next <= to_unsigned(16#8#, 4);
        END IF;
      WHEN "1001" =>
        lvlTwoEn <= '0';
        lvlThreeEn <= '0';
        lvlFourEn <= '0';
        outEn <= '0';
        pipeEn <= '1';
        pipeRst <= '0';
        SEL_tmp <= to_unsigned(16#0#, 2);
        countReset <= '0';
        IF pipeCount_unsigned = to_unsigned(16#3#, 2) THEN 
          statsFSM_statState_next <= to_unsigned(16#1#, 4);
          normOneFlag_temp := '0';
        ELSE 
          statsFSM_statState_next <= to_unsigned(16#9#, 4);
        END IF;
      WHEN "1010" =>
        lvlTwoEn <= '0';
        lvlThreeEn <= '0';
        lvlFourEn <= '0';
        outEn <= '0';
        pipeEn <= '0';
        pipeRst <= '1';
        SEL_tmp <= to_unsigned(16#0#, 2);
        countReset <= '0';
        IF resize(lvlOneCount_unsigned, 7) /= LUTDepthforMulPix_unsigned THEN 
          statsFSM_statState_next <= to_unsigned(16#0#, 4);
        ELSE 
          statsFSM_statState_next <= to_unsigned(16#A#, 4);
        END IF;
      WHEN OTHERS => 
        lvlTwoEn <= '0';
        lvlThreeEn <= '0';
        lvlFourEn <= '0';
        outEn <= '0';
        pipeEn <= '0';
        pipeRst <= '1';
        SEL_tmp <= to_unsigned(16#0#, 2);
        countReset <= '0';
    END CASE;
    IF (vEnd = '1') AND statsFSM_inFrame = '1' THEN 
      endFlag_temp := '1';
      statsFSM_inFrame_next <= '0';
    END IF;
    IF vStart /= '0' THEN 
      statsFSM_inFrame_next <= '1';
      statsFSM_statusComplete_next <= '0';
    END IF;
    endFL <= endFlag_temp;
    normFlag <= normOneFlag_temp;
    statsFSM_endFlag_next <= endFlag_temp;
    statsFSM_normOneFlag_next <= normOneFlag_temp;
  END PROCESS statsFSM_output;


  SEL <= std_logic_vector(SEL_tmp);

END rtl;
