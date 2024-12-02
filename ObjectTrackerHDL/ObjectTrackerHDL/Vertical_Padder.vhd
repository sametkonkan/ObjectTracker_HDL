-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\Vertical_Padder.vhd
-- Created: 2024-12-03 00:37:47
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: Vertical_Padder
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Preprocess/Edge Detector/LineBuffer/Vertical Padder
-- Hierarchy Level: 4
-- Model version: 3.7
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ObjectTrackerHDL_pkg.ALL;

ENTITY Vertical_Padder IS
  PORT( dataVectorIn                      :   IN    vector_of_std_logic_vector8(0 TO 2);  -- uint8 [3]
        verPadCount                       :   IN    std_logic_vector(10 DOWNTO 0);  -- ufix11
        dataVectorOut                     :   OUT   vector_of_std_logic_vector8(0 TO 2)  -- uint8 [3]
        );
END Vertical_Padder;


ARCHITECTURE rtl OF Vertical_Padder IS

  -- Signals
  SIGNAL verPadCount_unsigned             : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL dataVectorIn_0                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut1                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorIn_2                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataLineOut3                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL dataVectorOut_tmp                : vector_of_unsigned8(0 TO 2);  -- uint8 [3]

BEGIN
  verPadCount_unsigned <= unsigned(verPadCount);

  dataVectorIn_0 <= unsigned(dataVectorIn(0));

  dataVectorIn_1 <= unsigned(dataVectorIn(1));

  
  DataLineOut1 <= dataVectorIn_0 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_0 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_1;

  dataVectorIn_2 <= unsigned(dataVectorIn(2));

  
  DataLineOut3 <= dataVectorIn_1 WHEN verPadCount_unsigned = to_unsigned(16#000#, 11) ELSE
      dataVectorIn_2 WHEN verPadCount_unsigned = to_unsigned(16#001#, 11) ELSE
      dataVectorIn_2;

  dataVectorOut_tmp(0) <= DataLineOut1;
  dataVectorOut_tmp(1) <= unsigned(dataVectorIn(1));
  dataVectorOut_tmp(2) <= DataLineOut3;

  outputgen: FOR k IN 0 TO 2 GENERATE
    dataVectorOut(k) <= std_logic_vector(dataVectorOut_tmp(k));
  END GENERATE;

END rtl;
