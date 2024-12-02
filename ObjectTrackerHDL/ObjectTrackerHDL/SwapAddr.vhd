-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\SwapAddr.vhd
-- Created: 2024-12-03 00:37:45
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: SwapAddr
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Track/2-DCorrelation/2-DIFFT/CornerTurnMemory/SwapAddr
-- Hierarchy Level: 5
-- Model version: 3.7
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY SwapAddr IS
  PORT( addrIn                            :   IN    std_logic_vector(14 DOWNTO 0);  -- ufix15
        bankRd                            :   OUT   std_logic;
        addrRd                            :   OUT   std_logic_vector(13 DOWNTO 0)  -- ufix14
        );
END SwapAddr;


ARCHITECTURE rtl OF SwapAddr IS

  -- Signals
  SIGNAL addrIn_unsigned                  : unsigned(14 DOWNTO 0);  -- ufix15
  SIGNAL bankBit_out1                     : std_logic;  -- ufix1
  SIGNAL Logical_Operator3_out1           : std_logic;
  SIGNAL Bit_Shift_out1                   : unsigned(14 DOWNTO 0);  -- ufix15
  SIGNAL Bit_Slice_out1                   : unsigned(6 DOWNTO 0);  -- ufix7
  SIGNAL upperBits_out1                   : unsigned(6 DOWNTO 0);  -- ufix7
  SIGNAL Bit_Concat_out1                  : unsigned(13 DOWNTO 0);  -- ufix14

BEGIN
  addrIn_unsigned <= unsigned(addrIn);

  bankBit_out1 <= addrIn_unsigned(14);

  Logical_Operator3_out1 <=  NOT bankBit_out1;

  Bit_Shift_out1 <= addrIn_unsigned sll 7;

  Bit_Slice_out1 <= Bit_Shift_out1(13 DOWNTO 7);

  upperBits_out1 <= addrIn_unsigned(13 DOWNTO 7);

  Bit_Concat_out1 <= Bit_Slice_out1 & upperBits_out1;

  addrRd <= std_logic_vector(Bit_Concat_out1);

  bankRd <= Logical_Operator3_out1;

END rtl;
