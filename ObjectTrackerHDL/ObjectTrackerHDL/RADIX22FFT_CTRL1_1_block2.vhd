-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\RADIX22FFT_CTRL1_1_block2.vhd
-- Created: 2024-12-03 00:37:46
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: RADIX22FFT_CTRL1_1_block2
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Track/2-DCorrelation/2-DIFFT/RowIFFT/RADIX22FFT_CTRL1_1
-- Hierarchy Level: 5
-- Model version: 3.7
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY RADIX22FFT_CTRL1_1_block2 IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        dinXTwdl_7_vld                    :   IN    std_logic;
        dinXTwdl_7_vld_1                  :   IN    std_logic;
        rd_7_Addr                         :   OUT   std_logic;
        rd_7_Enb                          :   OUT   std_logic;
        proc_7_enb                        :   OUT   std_logic
        );
END RADIX22FFT_CTRL1_1_block2;


ARCHITECTURE rtl OF RADIX22FFT_CTRL1_1_block2 IS

  -- Signals
  SIGNAL SDFController_wrState            : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL SDFController_rdState            : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL SDFController_rdAddr_reg         : std_logic;  -- ufix1
  SIGNAL SDFController_multjState         : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL SDFController_wrState_next       : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL SDFController_rdState_next       : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL SDFController_rdAddr_reg_next    : std_logic;  -- ufix1
  SIGNAL SDFController_multjState_next    : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL multiply_7_J                     : std_logic;

BEGIN
  -- SDFController
  SDFController_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      SDFController_rdAddr_reg <= '0';
      SDFController_wrState <= to_unsigned(16#0#, 2);
      SDFController_rdState <= to_unsigned(16#0#, 2);
      SDFController_multjState <= to_unsigned(16#0#, 2);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        SDFController_wrState <= SDFController_wrState_next;
        SDFController_rdState <= SDFController_rdState_next;
        SDFController_rdAddr_reg <= SDFController_rdAddr_reg_next;
        SDFController_multjState <= SDFController_multjState_next;
      END IF;
    END IF;
  END PROCESS SDFController_process;

  SDFController_output : PROCESS (SDFController_multjState, SDFController_rdAddr_reg, SDFController_rdState,
       SDFController_wrState, dinXTwdl_7_vld, dinXTwdl_7_vld_1)
  BEGIN
    SDFController_rdState_next <= SDFController_rdState;
    SDFController_rdAddr_reg_next <= SDFController_rdAddr_reg;
    SDFController_multjState_next <= SDFController_multjState;
    CASE SDFController_multjState IS
      WHEN "00" =>
        SDFController_multjState_next <= to_unsigned(16#0#, 2);
        multiply_7_J <= '0';
        IF SDFController_rdState = to_unsigned(16#1#, 2) THEN 
          SDFController_multjState_next <= to_unsigned(16#1#, 2);
        END IF;
      WHEN "01" =>
        multiply_7_J <= '0';
        IF SDFController_rdState = to_unsigned(16#0#, 2) THEN 
          SDFController_multjState_next <= to_unsigned(16#2#, 2);
        END IF;
      WHEN "10" =>
        multiply_7_J <= '0';
        SDFController_multjState_next <= to_unsigned(16#3#, 2);
      WHEN "11" =>
        multiply_7_J <= '1';
        SDFController_multjState_next <= to_unsigned(16#0#, 2);
      WHEN OTHERS => 
        SDFController_multjState_next <= to_unsigned(16#0#, 2);
        multiply_7_J <= '0';
    END CASE;
    CASE SDFController_rdState IS
      WHEN "00" =>
        SDFController_rdState_next <= to_unsigned(16#0#, 2);
        SDFController_rdAddr_reg_next <= '0';
        rd_7_Enb <= '0';
        IF (SDFController_wrState = to_unsigned(16#3#, 2)) AND dinXTwdl_7_vld = '1' THEN 
          SDFController_rdState_next <= to_unsigned(16#1#, 2);
          rd_7_Enb <= dinXTwdl_7_vld_1;
        END IF;
      WHEN "01" =>
        rd_7_Enb <= dinXTwdl_7_vld_1;
        IF dinXTwdl_7_vld_1 = '1' THEN 
          SDFController_rdState_next <= to_unsigned(16#0#, 2);
        END IF;
      WHEN OTHERS => 
        SDFController_rdState_next <= to_unsigned(16#0#, 2);
        SDFController_rdAddr_reg_next <= '0';
        rd_7_Enb <= '0';
    END CASE;
    CASE SDFController_wrState IS
      WHEN "00" =>
        SDFController_wrState_next <= to_unsigned(16#0#, 2);
        proc_7_enb <= '0';
        IF dinXTwdl_7_vld = '1' THEN 
          SDFController_wrState_next <= to_unsigned(16#3#, 2);
        END IF;
      WHEN "11" =>
        SDFController_wrState_next <= to_unsigned(16#3#, 2);
        proc_7_enb <= '0';
        IF dinXTwdl_7_vld = '1' THEN 
          SDFController_wrState_next <= to_unsigned(16#2#, 2);
          proc_7_enb <= '1';
        END IF;
      WHEN "10" =>
        proc_7_enb <= '0';
        SDFController_wrState_next <= to_unsigned(16#2#, 2);
        IF dinXTwdl_7_vld = '1' THEN 
          SDFController_wrState_next <= to_unsigned(16#3#, 2);
        END IF;
      WHEN OTHERS => 
        SDFController_wrState_next <= to_unsigned(16#0#, 2);
        proc_7_enb <= '0';
    END CASE;
    rd_7_Addr <= SDFController_rdAddr_reg;
  END PROCESS SDFController_output;


END rtl;

