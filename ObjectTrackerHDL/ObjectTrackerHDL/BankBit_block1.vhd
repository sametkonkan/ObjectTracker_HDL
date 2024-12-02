-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\BankBit_block1.vhd
-- Created: 2024-12-03 00:37:46
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: BankBit_block1
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Track/2-DCorrelation/Prev2-DFFT/CornerTurnMemory/BankBit
-- Hierarchy Level: 5
-- Model version: 3.7
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY BankBit_block1 IS
  PORT( addrIn                            :   IN    std_logic_vector(14 DOWNTO 0);  -- ufix15
        bankWr                            :   OUT   std_logic
        );
END BankBit_block1;


ARCHITECTURE rtl OF BankBit_block1 IS

  -- Signals
  SIGNAL addrIn_unsigned                  : unsigned(14 DOWNTO 0);  -- ufix15
  SIGNAL Bit_Slice1_out1                  : std_logic;  -- ufix1
  SIGNAL Logical_Operator3_out1           : std_logic;

BEGIN
  addrIn_unsigned <= unsigned(addrIn);

  Bit_Slice1_out1 <= addrIn_unsigned(14);

  Logical_Operator3_out1 <=  NOT Bit_Slice1_out1;

  bankWr <= Logical_Operator3_out1;

END rtl;

