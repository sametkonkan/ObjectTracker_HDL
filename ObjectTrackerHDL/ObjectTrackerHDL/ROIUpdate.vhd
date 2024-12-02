-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\ROIUpdate.vhd
-- Created: 2024-12-03 00:37:46
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: ROIUpdate
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Track/ROIUpdate/ROIUpdate
-- Hierarchy Level: 3
-- Model version: 3.7
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ROIUpdate IS
  PORT( maxRow                            :   IN    std_logic_vector(15 DOWNTO 0);  -- uint16
        maxCol                            :   IN    std_logic_vector(15 DOWNTO 0);  -- uint16
        yROIIn                            :   IN    std_logic_vector(15 DOWNTO 0);  -- uint16
        xROIIn                            :   IN    std_logic_vector(15 DOWNTO 0);  -- uint16
        yROIOut                           :   OUT   std_logic_vector(16 DOWNTO 0);  -- sfix17
        xROIOut                           :   OUT   std_logic_vector(16 DOWNTO 0)  -- sfix17
        );
END ROIUpdate;


ARCHITECTURE rtl OF ROIUpdate IS

  -- Signals
  SIGNAL maxCol_unsigned                  : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL height_2_out1                    : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Subtract4_sub_cast               : signed(16 DOWNTO 0);  -- sfix17
  SIGNAL Subtract4_sub_cast_1             : signed(16 DOWNTO 0);  -- sfix17
  SIGNAL Subtract4_out1                   : signed(16 DOWNTO 0);  -- sfix17
  SIGNAL yROIIn_unsigned                  : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Add4_add_cast                    : signed(17 DOWNTO 0);  -- sfix18
  SIGNAL Add4_add_temp                    : signed(17 DOWNTO 0);  -- sfix18
  SIGNAL Add4_out1                        : signed(16 DOWNTO 0);  -- sfix17
  SIGNAL Constant_out1                    : signed(16 DOWNTO 0);  -- sfix17
  SIGNAL Relational_Operator1_out1        : std_logic;
  SIGNAL Switch1_out1                     : signed(16 DOWNTO 0);  -- sfix17
  SIGNAL Constant3_out1                   : signed(16 DOWNTO 0);  -- sfix17
  SIGNAL Relational_Operator3_out1        : std_logic;
  SIGNAL Switch3_out1                     : signed(16 DOWNTO 0);  -- sfix17
  SIGNAL maxRow_unsigned                  : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL width_2_out1                     : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Subtract3_sub_cast               : signed(16 DOWNTO 0);  -- sfix17
  SIGNAL Subtract3_sub_cast_1             : signed(16 DOWNTO 0);  -- sfix17
  SIGNAL Subtract3_out1                   : signed(16 DOWNTO 0);  -- sfix17
  SIGNAL xROIIn_unsigned                  : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Add5_add_cast                    : signed(17 DOWNTO 0);  -- sfix18
  SIGNAL Add5_add_temp                    : signed(17 DOWNTO 0);  -- sfix18
  SIGNAL Add5_out1                        : signed(16 DOWNTO 0);  -- sfix17
  SIGNAL Constant1_out1                   : signed(16 DOWNTO 0);  -- sfix17
  SIGNAL Relational_Operator_out1         : std_logic;
  SIGNAL Switch_out1                      : signed(16 DOWNTO 0);  -- sfix17
  SIGNAL Constant2_out1                   : signed(16 DOWNTO 0);  -- sfix17
  SIGNAL Relational_Operator2_out1        : std_logic;
  SIGNAL Switch2_out1                     : signed(16 DOWNTO 0);  -- sfix17

BEGIN
  maxCol_unsigned <= unsigned(maxCol);

  height_2_out1 <= to_unsigned(16#0040#, 16);

  Subtract4_sub_cast <= signed(resize(maxCol_unsigned, 17));
  Subtract4_sub_cast_1 <= signed(resize(height_2_out1, 17));
  Subtract4_out1 <= Subtract4_sub_cast - Subtract4_sub_cast_1;

  yROIIn_unsigned <= unsigned(yROIIn);

  Add4_add_cast <= signed(resize(yROIIn_unsigned, 18));
  Add4_add_temp <= resize(Subtract4_out1, 18) + Add4_add_cast;
  Add4_out1 <= Add4_add_temp(16 DOWNTO 0);

  Constant_out1 <= to_signed(16#00160#, 17);

  
  Relational_Operator1_out1 <= '1' WHEN Add4_out1 < Constant_out1 ELSE
      '0';

  
  Switch1_out1 <= Constant_out1 WHEN Relational_Operator1_out1 = '0' ELSE
      Add4_out1;

  Constant3_out1 <= to_signed(16#00000#, 17);

  
  Relational_Operator3_out1 <= '1' WHEN Switch1_out1 > Constant3_out1 ELSE
      '0';

  
  Switch3_out1 <= Constant3_out1 WHEN Relational_Operator3_out1 = '0' ELSE
      Switch1_out1;

  yROIOut <= std_logic_vector(Switch3_out1);

  maxRow_unsigned <= unsigned(maxRow);

  width_2_out1 <= to_unsigned(16#0040#, 16);

  Subtract3_sub_cast <= signed(resize(maxRow_unsigned, 17));
  Subtract3_sub_cast_1 <= signed(resize(width_2_out1, 17));
  Subtract3_out1 <= Subtract3_sub_cast - Subtract3_sub_cast_1;

  xROIIn_unsigned <= unsigned(xROIIn);

  Add5_add_cast <= signed(resize(xROIIn_unsigned, 18));
  Add5_add_temp <= resize(Subtract3_out1, 18) + Add5_add_cast;
  Add5_out1 <= Add5_add_temp(16 DOWNTO 0);

  Constant1_out1 <= to_signed(16#00200#, 17);

  
  Relational_Operator_out1 <= '1' WHEN Add5_out1 < Constant1_out1 ELSE
      '0';

  
  Switch_out1 <= Constant1_out1 WHEN Relational_Operator_out1 = '0' ELSE
      Add5_out1;

  Constant2_out1 <= to_signed(16#00000#, 17);

  
  Relational_Operator2_out1 <= '1' WHEN Switch_out1 > Constant2_out1 ELSE
      '0';

  
  Switch2_out1 <= Constant2_out1 WHEN Relational_Operator2_out1 = '0' ELSE
      Switch_out1;

  xROIOut <= std_logic_vector(Switch2_out1);

END rtl;
