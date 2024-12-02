-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\GenerateBinaryImage.vhd
-- Created: 2024-12-03 00:37:47
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: GenerateBinaryImage
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Preprocess/Edge Detector/GenerateBinaryImage
-- Hierarchy Level: 3
-- Model version: 3.7
-- 
-- Generate Binary Image
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ObjectTrackerHDL_pkg.ALL;

ENTITY GenerateBinaryImage IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        grad1                             :   IN    std_logic_vector(10 DOWNTO 0);  -- sfix11_En3
        grad2                             :   IN    std_logic_vector(10 DOWNTO 0);  -- sfix11_En3
        threshold                         :   IN    std_logic_vector(22 DOWNTO 0);  -- ufix23_En6
        binaryImage                       :   OUT   std_logic
        );
END GenerateBinaryImage;


ARCHITECTURE rtl OF GenerateBinaryImage IS

  -- Signals
  SIGNAL grad1_signed                     : signed(10 DOWNTO 0);  -- sfix11_En3
  SIGNAL intdelay_reg                     : vector_of_signed11(0 TO 1);  -- sfix11 [2]
  SIGNAL grad1PreMul                      : signed(10 DOWNTO 0);  -- sfix11_En3
  SIGNAL multiplier_mul_temp              : signed(21 DOWNTO 0);  -- sfix22_En6
  SIGNAL g1Square                         : unsigned(21 DOWNTO 0);  -- ufix22_En6
  SIGNAL intdelay_reg_1                   : vector_of_unsigned22(0 TO 1);  -- ufix22 [2]
  SIGNAL g1SquarePostMul                  : unsigned(21 DOWNTO 0);  -- ufix22_En6
  SIGNAL grad2_signed                     : signed(10 DOWNTO 0);  -- sfix11_En3
  SIGNAL intdelay_reg_2                   : vector_of_signed11(0 TO 1);  -- sfix11 [2]
  SIGNAL grad2PreMul                      : signed(10 DOWNTO 0);  -- sfix11_En3
  SIGNAL multiplier_mul_temp_1            : signed(21 DOWNTO 0);  -- sfix22_En6
  SIGNAL g2Square                         : unsigned(21 DOWNTO 0);  -- ufix22_En6
  SIGNAL intdelay_reg_3                   : vector_of_unsigned22(0 TO 1);  -- ufix22 [2]
  SIGNAL g2SquarePostMul                  : unsigned(21 DOWNTO 0);  -- ufix22_En6
  SIGNAL adder_add_cast                   : unsigned(22 DOWNTO 0);  -- ufix23_En6
  SIGNAL adder_add_cast_1                 : unsigned(22 DOWNTO 0);  -- ufix23_En6
  SIGNAL gSquareSum                       : unsigned(22 DOWNTO 0);  -- ufix23_En6
  SIGNAL SquareSumDelay                   : unsigned(22 DOWNTO 0);  -- ufix23_En6
  SIGNAL threshold_unsigned               : unsigned(22 DOWNTO 0);  -- ufix23_En6
  SIGNAL bImageNext                       : std_logic;

BEGIN
  grad1_signed <= signed(grad1);

  intdelay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      intdelay_reg <= (OTHERS => to_signed(16#000#, 11));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        intdelay_reg(0) <= grad1_signed;
        intdelay_reg(1) <= intdelay_reg(0);
      END IF;
    END IF;
  END PROCESS intdelay_process;

  grad1PreMul <= intdelay_reg(1);

  multiplier_mul_temp <= grad1PreMul * grad1PreMul;
  
  g1Square <= "0000000000000000000000" WHEN multiplier_mul_temp(21) = '1' ELSE
      unsigned(multiplier_mul_temp);

  intdelay_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      intdelay_reg_1 <= (OTHERS => to_unsigned(16#000000#, 22));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        intdelay_reg_1(0) <= g1Square;
        intdelay_reg_1(1) <= intdelay_reg_1(0);
      END IF;
    END IF;
  END PROCESS intdelay_1_process;

  g1SquarePostMul <= intdelay_reg_1(1);

  grad2_signed <= signed(grad2);

  intdelay_2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      intdelay_reg_2 <= (OTHERS => to_signed(16#000#, 11));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        intdelay_reg_2(0) <= grad2_signed;
        intdelay_reg_2(1) <= intdelay_reg_2(0);
      END IF;
    END IF;
  END PROCESS intdelay_2_process;

  grad2PreMul <= intdelay_reg_2(1);

  multiplier_mul_temp_1 <= grad2PreMul * grad2PreMul;
  
  g2Square <= "0000000000000000000000" WHEN multiplier_mul_temp_1(21) = '1' ELSE
      unsigned(multiplier_mul_temp_1);

  intdelay_3_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      intdelay_reg_3 <= (OTHERS => to_unsigned(16#000000#, 22));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        intdelay_reg_3(0) <= g2Square;
        intdelay_reg_3(1) <= intdelay_reg_3(0);
      END IF;
    END IF;
  END PROCESS intdelay_3_process;

  g2SquarePostMul <= intdelay_reg_3(1);

  adder_add_cast <= resize(g1SquarePostMul, 23);
  adder_add_cast_1 <= resize(g2SquarePostMul, 23);
  gSquareSum <= adder_add_cast + adder_add_cast_1;

  reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      SquareSumDelay <= to_unsigned(16#000000#, 23);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        SquareSumDelay <= gSquareSum;
      END IF;
    END IF;
  END PROCESS reg_process;


  threshold_unsigned <= unsigned(threshold);

  
  bImageNext <= '1' WHEN SquareSumDelay > threshold_unsigned ELSE
      '0';

  reg_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      binaryImage <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        binaryImage <= bImageNext;
      END IF;
    END IF;
  END PROCESS reg_1_process;


END rtl;

