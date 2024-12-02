-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\Complex4Multiply_block15.vhd
-- Created: 2024-12-03 00:37:46
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: Complex4Multiply_block15
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Track/2-DCorrelation/Prev2-DFFT/RowFFT/RADIX22FFT_SDF1_5/Complex4Multiply
-- Hierarchy Level: 6
-- Model version: 3.7
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Complex4Multiply_block15 IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        din_re                            :   IN    std_logic_vector(36 DOWNTO 0);  -- sfix37_En28
        din_im                            :   IN    std_logic_vector(36 DOWNTO 0);  -- sfix37_En28
        din_5_vld_dly                     :   IN    std_logic;
        twdl_5_1_re                       :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En30
        twdl_5_1_im                       :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En30
        dinXTwdl_re                       :   OUT   std_logic_vector(36 DOWNTO 0);  -- sfix37_En28
        dinXTwdl_im                       :   OUT   std_logic_vector(36 DOWNTO 0);  -- sfix37_En28
        dinXTwdl_5_1_vld                  :   OUT   std_logic
        );
END Complex4Multiply_block15;


ARCHITECTURE rtl OF Complex4Multiply_block15 IS

  -- Signals
  SIGNAL din_re_signed                    : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL din_re_reg                       : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL din_im_signed                    : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL din_im_reg                       : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL twdl_5_1_re_signed               : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL twdl_re_reg                      : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL twdl_5_1_im_signed               : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL twdl_im_reg                      : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL Complex4Multiply_din1_re_pipe1   : signed(36 DOWNTO 0) := to_signed(0, 37);  -- sfix37
  SIGNAL Complex4Multiply_din1_im_pipe1   : signed(36 DOWNTO 0) := to_signed(0, 37);  -- sfix37
  SIGNAL Complex4Multiply_mult1_re_pipe1  : signed(68 DOWNTO 0) := to_signed(0, 69);  -- sfix69
  SIGNAL Complex4Multiply_mult2_re_pipe1  : signed(68 DOWNTO 0) := to_signed(0, 69);  -- sfix69
  SIGNAL Complex4Multiply_mult1_im_pipe1  : signed(68 DOWNTO 0) := to_signed(0, 69);  -- sfix69
  SIGNAL Complex4Multiply_mult2_im_pipe1  : signed(68 DOWNTO 0) := to_signed(0, 69);  -- sfix69
  SIGNAL Complex4Multiply_twiddle_re_pipe1 : signed(31 DOWNTO 0) := to_signed(0, 32);  -- sfix32
  SIGNAL Complex4Multiply_twiddle_im_pipe1 : signed(31 DOWNTO 0) := to_signed(0, 32);  -- sfix32
  SIGNAL prod1_re                         : signed(68 DOWNTO 0) := to_signed(0, 69);  -- sfix69_En58
  SIGNAL prod1_im                         : signed(68 DOWNTO 0) := to_signed(0, 69);  -- sfix69_En58
  SIGNAL prod2_re                         : signed(68 DOWNTO 0) := to_signed(0, 69);  -- sfix69_En58
  SIGNAL prod2_im                         : signed(68 DOWNTO 0) := to_signed(0, 69);  -- sfix69_En58
  SIGNAL din_vld_dly1                     : std_logic;
  SIGNAL din_vld_dly2                     : std_logic;
  SIGNAL din_vld_dly3                     : std_logic;
  SIGNAL prod_vld                         : std_logic;
  SIGNAL Complex4Add_multRes_re_reg       : signed(69 DOWNTO 0);  -- sfix70
  SIGNAL Complex4Add_multRes_im_reg       : signed(69 DOWNTO 0);  -- sfix70
  SIGNAL Complex4Add_prod_vld_reg1        : std_logic;
  SIGNAL Complex4Add_prod1_re_reg         : signed(68 DOWNTO 0);  -- sfix69
  SIGNAL Complex4Add_prod1_im_reg         : signed(68 DOWNTO 0);  -- sfix69
  SIGNAL Complex4Add_prod2_re_reg         : signed(68 DOWNTO 0);  -- sfix69
  SIGNAL Complex4Add_prod2_im_reg         : signed(68 DOWNTO 0);  -- sfix69
  SIGNAL Complex4Add_multRes_re_reg_next  : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL Complex4Add_multRes_im_reg_next  : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL Complex4Add_sub_cast             : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL Complex4Add_sub_cast_1           : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL Complex4Add_add_cast             : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL Complex4Add_add_cast_1           : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL mulResFP_re                      : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL mulResFP_im                      : signed(69 DOWNTO 0);  -- sfix70_En58
  SIGNAL dinXTwdl_5_1_vld_1               : std_logic;
  SIGNAL dinXTwdl_re_tmp                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL dinXTwdl_im_tmp                  : signed(36 DOWNTO 0);  -- sfix37_En28

BEGIN
  din_re_signed <= signed(din_re);

  intdelay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      din_re_reg <= to_signed(0, 37);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        din_re_reg <= din_re_signed;
      END IF;
    END IF;
  END PROCESS intdelay_process;


  din_im_signed <= signed(din_im);

  intdelay_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      din_im_reg <= to_signed(0, 37);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        din_im_reg <= din_im_signed;
      END IF;
    END IF;
  END PROCESS intdelay_1_process;


  twdl_5_1_re_signed <= signed(twdl_5_1_re);

  intdelay_2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      twdl_re_reg <= to_signed(0, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        twdl_re_reg <= twdl_5_1_re_signed;
      END IF;
    END IF;
  END PROCESS intdelay_2_process;


  twdl_5_1_im_signed <= signed(twdl_5_1_im);

  intdelay_3_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      twdl_im_reg <= to_signed(0, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        twdl_im_reg <= twdl_5_1_im_signed;
      END IF;
    END IF;
  END PROCESS intdelay_3_process;


  -- Complex4Multiply
  Complex4Multiply_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        prod1_re <= Complex4Multiply_mult1_re_pipe1;
        prod2_re <= Complex4Multiply_mult2_re_pipe1;
        prod1_im <= Complex4Multiply_mult1_im_pipe1;
        prod2_im <= Complex4Multiply_mult2_im_pipe1;
        Complex4Multiply_mult1_re_pipe1 <= Complex4Multiply_din1_re_pipe1 * Complex4Multiply_twiddle_re_pipe1;
        Complex4Multiply_mult2_re_pipe1 <= Complex4Multiply_din1_im_pipe1 * Complex4Multiply_twiddle_im_pipe1;
        Complex4Multiply_mult1_im_pipe1 <= Complex4Multiply_din1_re_pipe1 * Complex4Multiply_twiddle_im_pipe1;
        Complex4Multiply_mult2_im_pipe1 <= Complex4Multiply_din1_im_pipe1 * Complex4Multiply_twiddle_re_pipe1;
        Complex4Multiply_twiddle_re_pipe1 <= twdl_re_reg;
        Complex4Multiply_twiddle_im_pipe1 <= twdl_im_reg;
        Complex4Multiply_din1_re_pipe1 <= din_re_reg;
        Complex4Multiply_din1_im_pipe1 <= din_im_reg;
      END IF;
    END IF;
  END PROCESS Complex4Multiply_process;


  intdelay_4_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      din_vld_dly1 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        din_vld_dly1 <= din_5_vld_dly;
      END IF;
    END IF;
  END PROCESS intdelay_4_process;


  intdelay_5_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      din_vld_dly2 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        din_vld_dly2 <= din_vld_dly1;
      END IF;
    END IF;
  END PROCESS intdelay_5_process;


  intdelay_6_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      din_vld_dly3 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        din_vld_dly3 <= din_vld_dly2;
      END IF;
    END IF;
  END PROCESS intdelay_6_process;


  intdelay_7_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      prod_vld <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        prod_vld <= din_vld_dly3;
      END IF;
    END IF;
  END PROCESS intdelay_7_process;


  -- Complex4Add
  Complex4Add_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Complex4Add_multRes_re_reg <= to_signed(0, 70);
      Complex4Add_multRes_im_reg <= to_signed(0, 70);
      Complex4Add_prod1_re_reg <= to_signed(0, 69);
      Complex4Add_prod1_im_reg <= to_signed(0, 69);
      Complex4Add_prod2_re_reg <= to_signed(0, 69);
      Complex4Add_prod2_im_reg <= to_signed(0, 69);
      Complex4Add_prod_vld_reg1 <= '0';
      dinXTwdl_5_1_vld_1 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        Complex4Add_multRes_re_reg <= Complex4Add_multRes_re_reg_next;
        Complex4Add_multRes_im_reg <= Complex4Add_multRes_im_reg_next;
        Complex4Add_prod1_re_reg <= prod1_re;
        Complex4Add_prod1_im_reg <= prod1_im;
        Complex4Add_prod2_re_reg <= prod2_re;
        Complex4Add_prod2_im_reg <= prod2_im;
        dinXTwdl_5_1_vld_1 <= Complex4Add_prod_vld_reg1;
        Complex4Add_prod_vld_reg1 <= prod_vld;
      END IF;
    END IF;
  END PROCESS Complex4Add_process;

  Complex4Add_sub_cast <= resize(Complex4Add_prod1_re_reg, 70);
  Complex4Add_sub_cast_1 <= resize(Complex4Add_prod2_re_reg, 70);
  Complex4Add_multRes_re_reg_next <= Complex4Add_sub_cast - Complex4Add_sub_cast_1;
  Complex4Add_add_cast <= resize(Complex4Add_prod1_im_reg, 70);
  Complex4Add_add_cast_1 <= resize(Complex4Add_prod2_im_reg, 70);
  Complex4Add_multRes_im_reg_next <= Complex4Add_add_cast + Complex4Add_add_cast_1;
  mulResFP_re <= Complex4Add_multRes_re_reg;
  mulResFP_im <= Complex4Add_multRes_im_reg;

  dinXTwdl_re_tmp <= mulResFP_re(66 DOWNTO 30);

  dinXTwdl_re <= std_logic_vector(dinXTwdl_re_tmp);

  dinXTwdl_im_tmp <= mulResFP_im(66 DOWNTO 30);

  dinXTwdl_im <= std_logic_vector(dinXTwdl_im_tmp);

  dinXTwdl_5_1_vld <= dinXTwdl_5_1_vld_1;

END rtl;

