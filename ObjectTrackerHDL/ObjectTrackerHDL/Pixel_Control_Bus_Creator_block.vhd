-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\Pixel_Control_Bus_Creator_block.vhd
-- Created: 2024-12-03 00:37:46
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: Pixel_Control_Bus_Creator_block
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Track/2-DCorrelation/Curr2-DFFT/pixelBusGenerator/Pixel Control 
-- Bus Creato
-- Hierarchy Level: 5
-- Model version: 3.7
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Pixel_Control_Bus_Creator_block IS
  PORT( In1                               :   IN    std_logic;
        In2                               :   IN    std_logic;
        In3                               :   IN    std_logic;
        In4                               :   IN    std_logic;
        In5                               :   IN    std_logic;
        Out1_hStart                       :   OUT   std_logic;
        Out1_hEnd                         :   OUT   std_logic;
        Out1_vStart                       :   OUT   std_logic;
        Out1_vEnd                         :   OUT   std_logic;
        Out1_valid                        :   OUT   std_logic
        );
END Pixel_Control_Bus_Creator_block;


ARCHITECTURE rtl OF Pixel_Control_Bus_Creator_block IS

BEGIN
  Out1_hStart <= In1;

  Out1_hEnd <= In2;

  Out1_vStart <= In3;

  Out1_vEnd <= In4;

  Out1_valid <= In5;

END rtl;

