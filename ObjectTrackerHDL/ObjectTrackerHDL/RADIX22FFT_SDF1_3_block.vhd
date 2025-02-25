-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\RADIX22FFT_SDF1_3_block.vhd
-- Created: 2024-12-03 00:37:45
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: RADIX22FFT_SDF1_3_block
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Track/2-DCorrelation/2-DIFFT/RowIFFT/RADIX22FFT_SDF1_3
-- Hierarchy Level: 5
-- Model version: 3.7
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ObjectTrackerHDL_pkg.ALL;

ENTITY RADIX22FFT_SDF1_3_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        din_3_1_re_dly                    :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
        din_3_1_im_dly                    :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
        din_3_vld_dly                     :   IN    std_logic;
        rd_3_Addr                         :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
        rd_3_Enb                          :   IN    std_logic;
        twdl_3_1_re                       :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En22
        twdl_3_1_im                       :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En22
        proc_3_enb                        :   IN    std_logic;
        dout_3_1_re                       :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
        dout_3_1_im                       :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
        dout_3_1_vld                      :   OUT   std_logic;
        dinXTwdl_3_1_vld                  :   OUT   std_logic
        );
END RADIX22FFT_SDF1_3_block;


ARCHITECTURE rtl OF RADIX22FFT_SDF1_3_block IS

  -- Component Declarations
  COMPONENT Complex4Multiply_block2
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          din_3_1_re_dly                  :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          din_3_1_im_dly                  :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          din_3_vld_dly                   :   IN    std_logic;
          twdl_3_1_re                     :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En22
          twdl_3_1_im                     :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En22
          dinXTwdl_re                     :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          dinXTwdl_im                     :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          dinXTwdl_3_1_vld                :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT SimpleDualPortRAM_generic_block
    GENERIC( AddrWidth                    : integer;
             DataWidth                    : integer
             );
    PORT( clk                             :   IN    std_logic;
          enb                             :   IN    std_logic;
          wr_din                          :   IN    std_logic_vector(DataWidth - 1 DOWNTO 0);  -- generic width
          wr_addr                         :   IN    std_logic_vector(AddrWidth - 1 DOWNTO 0);  -- generic width
          wr_en                           :   IN    std_logic;
          rd_addr                         :   IN    std_logic_vector(AddrWidth - 1 DOWNTO 0);  -- generic width
          dout                            :   OUT   std_logic_vector(DataWidth - 1 DOWNTO 0)  -- generic width
          );
  END COMPONENT;

  COMPONENT SDFCommutator3_block
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          din_3_vld_dly                   :   IN    std_logic;
          xf_re                           :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          xf_im                           :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          xf_vld                          :   IN    std_logic;
          dinXTwdlf_re                    :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          dinXTwdlf_im                    :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          dinxTwdlf_vld                   :   IN    std_logic;
          btf1_re                         :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          btf1_im                         :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          btf2_re                         :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          btf2_im                         :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          btf_vld                         :   IN    std_logic;
          wrData_re                       :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          wrData_im                       :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          wrAddr                          :   OUT   std_logic_vector(3 DOWNTO 0);  -- ufix4
          wrEnb                           :   OUT   std_logic;
          dout_3_1_re                     :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          dout_3_1_im                     :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          dout_3_1_vld                    :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : Complex4Multiply_block2
    USE ENTITY work.Complex4Multiply_block2(rtl);

  FOR ALL : SimpleDualPortRAM_generic_block
    USE ENTITY work.SimpleDualPortRAM_generic_block(rtl);

  FOR ALL : SDFCommutator3_block
    USE ENTITY work.SDFCommutator3_block(rtl);

  -- Signals
  SIGNAL dinXTwdl_re                      : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL dinXTwdl_im                      : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL dinXTwdl_3_1_vld_1               : std_logic;
  SIGNAL dinXTwdl_re_signed               : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL dinXTwdl_im_signed               : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL x_vld                            : std_logic;
  SIGNAL btf2_im                          : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL btf2_re                          : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL btf1_im                          : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL btf1_re                          : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL dinXTwdlf_im                     : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL dinXTwdlf_re                     : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL xf_im                            : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL wrData_im                        : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL wrAddr                           : std_logic_vector(3 DOWNTO 0);  -- ufix4
  SIGNAL wrEnb                            : std_logic;
  SIGNAL x_im                             : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL x_im_signed                      : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL wrData_re                        : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL x_re                             : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL x_re_signed                      : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL Radix22ButterflyG1_btf1_re_reg   : signed(24 DOWNTO 0);  -- sfix25
  SIGNAL Radix22ButterflyG1_btf1_im_reg   : signed(24 DOWNTO 0);  -- sfix25
  SIGNAL Radix22ButterflyG1_btf2_re_reg   : signed(24 DOWNTO 0);  -- sfix25
  SIGNAL Radix22ButterflyG1_btf2_im_reg   : signed(24 DOWNTO 0);  -- sfix25
  SIGNAL Radix22ButterflyG1_x_re_dly1     : signed(23 DOWNTO 0);  -- sfix24
  SIGNAL Radix22ButterflyG1_x_im_dly1     : signed(23 DOWNTO 0);  -- sfix24
  SIGNAL Radix22ButterflyG1_x_vld_dly1    : std_logic;
  SIGNAL Radix22ButterflyG1_dinXtwdl_re_dly1 : signed(23 DOWNTO 0);  -- sfix24
  SIGNAL Radix22ButterflyG1_dinXtwdl_im_dly1 : signed(23 DOWNTO 0);  -- sfix24
  SIGNAL Radix22ButterflyG1_dinXtwdl_re_dly2 : signed(23 DOWNTO 0);  -- sfix24
  SIGNAL Radix22ButterflyG1_dinXtwdl_im_dly2 : signed(23 DOWNTO 0);  -- sfix24
  SIGNAL Radix22ButterflyG1_dinXtwdl_vld_dly1 : std_logic;
  SIGNAL Radix22ButterflyG1_dinXtwdl_vld_dly2 : std_logic;
  SIGNAL Radix22ButterflyG1_btf1_re_reg_next : signed(24 DOWNTO 0);  -- sfix25_En16
  SIGNAL Radix22ButterflyG1_btf1_im_reg_next : signed(24 DOWNTO 0);  -- sfix25_En16
  SIGNAL Radix22ButterflyG1_btf2_re_reg_next : signed(24 DOWNTO 0);  -- sfix25_En16
  SIGNAL Radix22ButterflyG1_btf2_im_reg_next : signed(24 DOWNTO 0);  -- sfix25_En16
  SIGNAL Radix22ButterflyG1_add_cast      : signed(24 DOWNTO 0);  -- sfix25_En16
  SIGNAL Radix22ButterflyG1_add_cast_1    : signed(24 DOWNTO 0);  -- sfix25_En16
  SIGNAL Radix22ButterflyG1_sub_cast      : signed(24 DOWNTO 0);  -- sfix25_En16
  SIGNAL Radix22ButterflyG1_sub_cast_1    : signed(24 DOWNTO 0);  -- sfix25_En16
  SIGNAL Radix22ButterflyG1_add_cast_2    : signed(24 DOWNTO 0);  -- sfix25_En16
  SIGNAL Radix22ButterflyG1_add_cast_3    : signed(24 DOWNTO 0);  -- sfix25_En16
  SIGNAL Radix22ButterflyG1_sub_cast_2    : signed(24 DOWNTO 0);  -- sfix25_En16
  SIGNAL Radix22ButterflyG1_sub_cast_3    : signed(24 DOWNTO 0);  -- sfix25_En16
  SIGNAL Radix22ButterflyG1_sra_temp      : signed(24 DOWNTO 0);  -- sfix25_En16
  SIGNAL Radix22ButterflyG1_sra_temp_1    : signed(24 DOWNTO 0);  -- sfix25_En16
  SIGNAL Radix22ButterflyG1_sra_temp_2    : signed(24 DOWNTO 0);  -- sfix25_En16
  SIGNAL Radix22ButterflyG1_sra_temp_3    : signed(24 DOWNTO 0);  -- sfix25_En16
  SIGNAL xf_re                            : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL xf_vld                           : std_logic;
  SIGNAL dinxTwdlf_vld                    : std_logic;
  SIGNAL btf_vld                          : std_logic;
  SIGNAL dout_3_1_re_tmp                  : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL dout_3_1_im_tmp                  : std_logic_vector(23 DOWNTO 0);  -- ufix24

BEGIN
  u_MUL4 : Complex4Multiply_block2
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              din_3_1_re_dly => din_3_1_re_dly,  -- sfix24_En16
              din_3_1_im_dly => din_3_1_im_dly,  -- sfix24_En16
              din_3_vld_dly => din_3_vld_dly,
              twdl_3_1_re => twdl_3_1_re,  -- sfix24_En22
              twdl_3_1_im => twdl_3_1_im,  -- sfix24_En22
              dinXTwdl_re => dinXTwdl_re,  -- sfix24_En16
              dinXTwdl_im => dinXTwdl_im,  -- sfix24_En16
              dinXTwdl_3_1_vld => dinXTwdl_3_1_vld_1
              );

  u_dataMEM_im_0_3 : SimpleDualPortRAM_generic_block
    GENERIC MAP( AddrWidth => 4,
                 DataWidth => 24
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => wrData_im,
              wr_addr => wrAddr,
              wr_en => wrEnb,
              rd_addr => rd_3_Addr,
              dout => x_im
              );

  u_dataMEM_re_0_3 : SimpleDualPortRAM_generic_block
    GENERIC MAP( AddrWidth => 4,
                 DataWidth => 24
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => wrData_re,
              wr_addr => wrAddr,
              wr_en => wrEnb,
              rd_addr => rd_3_Addr,
              dout => x_re
              );

  u_SDFCOMMUTATOR_3 : SDFCommutator3_block
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              din_3_vld_dly => din_3_vld_dly,
              xf_re => std_logic_vector(xf_re),  -- sfix24_En16
              xf_im => std_logic_vector(xf_im),  -- sfix24_En16
              xf_vld => xf_vld,
              dinXTwdlf_re => std_logic_vector(dinXTwdlf_re),  -- sfix24_En16
              dinXTwdlf_im => std_logic_vector(dinXTwdlf_im),  -- sfix24_En16
              dinxTwdlf_vld => dinxTwdlf_vld,
              btf1_re => std_logic_vector(btf1_re),  -- sfix24_En16
              btf1_im => std_logic_vector(btf1_im),  -- sfix24_En16
              btf2_re => std_logic_vector(btf2_re),  -- sfix24_En16
              btf2_im => std_logic_vector(btf2_im),  -- sfix24_En16
              btf_vld => btf_vld,
              wrData_re => wrData_re,  -- sfix24_En16
              wrData_im => wrData_im,  -- sfix24_En16
              wrAddr => wrAddr,  -- ufix4
              wrEnb => wrEnb,
              dout_3_1_re => dout_3_1_re_tmp,  -- sfix24_En16
              dout_3_1_im => dout_3_1_im_tmp,  -- sfix24_En16
              dout_3_1_vld => dout_3_1_vld
              );

  dinXTwdl_re_signed <= signed(dinXTwdl_re);

  dinXTwdl_im_signed <= signed(dinXTwdl_im);

  intdelay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      x_vld <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        x_vld <= rd_3_Enb;
      END IF;
    END IF;
  END PROCESS intdelay_process;


  x_im_signed <= signed(x_im);

  x_re_signed <= signed(x_re);

  -- Radix22ButterflyG1
  Radix22ButterflyG1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Radix22ButterflyG1_btf1_re_reg <= to_signed(16#0000000#, 25);
      Radix22ButterflyG1_btf1_im_reg <= to_signed(16#0000000#, 25);
      Radix22ButterflyG1_btf2_re_reg <= to_signed(16#0000000#, 25);
      Radix22ButterflyG1_btf2_im_reg <= to_signed(16#0000000#, 25);
      Radix22ButterflyG1_x_re_dly1 <= to_signed(16#000000#, 24);
      Radix22ButterflyG1_x_im_dly1 <= to_signed(16#000000#, 24);
      Radix22ButterflyG1_x_vld_dly1 <= '0';
      xf_re <= to_signed(16#000000#, 24);
      xf_im <= to_signed(16#000000#, 24);
      xf_vld <= '0';
      Radix22ButterflyG1_dinXtwdl_re_dly1 <= to_signed(16#000000#, 24);
      Radix22ButterflyG1_dinXtwdl_im_dly1 <= to_signed(16#000000#, 24);
      Radix22ButterflyG1_dinXtwdl_re_dly2 <= to_signed(16#000000#, 24);
      Radix22ButterflyG1_dinXtwdl_im_dly2 <= to_signed(16#000000#, 24);
      Radix22ButterflyG1_dinXtwdl_vld_dly1 <= '0';
      Radix22ButterflyG1_dinXtwdl_vld_dly2 <= '0';
      btf_vld <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        Radix22ButterflyG1_btf1_re_reg <= Radix22ButterflyG1_btf1_re_reg_next;
        Radix22ButterflyG1_btf1_im_reg <= Radix22ButterflyG1_btf1_im_reg_next;
        Radix22ButterflyG1_btf2_re_reg <= Radix22ButterflyG1_btf2_re_reg_next;
        Radix22ButterflyG1_btf2_im_reg <= Radix22ButterflyG1_btf2_im_reg_next;
        xf_re <= Radix22ButterflyG1_x_re_dly1;
        xf_im <= Radix22ButterflyG1_x_im_dly1;
        xf_vld <= Radix22ButterflyG1_x_vld_dly1;
        btf_vld <= Radix22ButterflyG1_dinXtwdl_vld_dly2;
        Radix22ButterflyG1_dinXtwdl_vld_dly2 <= Radix22ButterflyG1_dinXtwdl_vld_dly1;
        Radix22ButterflyG1_dinXtwdl_re_dly2 <= Radix22ButterflyG1_dinXtwdl_re_dly1;
        Radix22ButterflyG1_dinXtwdl_im_dly2 <= Radix22ButterflyG1_dinXtwdl_im_dly1;
        Radix22ButterflyG1_dinXtwdl_re_dly1 <= dinXTwdl_re_signed;
        Radix22ButterflyG1_dinXtwdl_im_dly1 <= dinXTwdl_im_signed;
        Radix22ButterflyG1_x_re_dly1 <= x_re_signed;
        Radix22ButterflyG1_x_im_dly1 <= x_im_signed;
        Radix22ButterflyG1_x_vld_dly1 <= x_vld;
        Radix22ButterflyG1_dinXtwdl_vld_dly1 <= proc_3_enb AND dinXTwdl_3_1_vld_1;
      END IF;
    END IF;
  END PROCESS Radix22ButterflyG1_process;

  dinxTwdlf_vld <= ( NOT proc_3_enb) AND dinXTwdl_3_1_vld_1;
  Radix22ButterflyG1_add_cast <= resize(Radix22ButterflyG1_x_re_dly1, 25);
  Radix22ButterflyG1_add_cast_1 <= resize(Radix22ButterflyG1_dinXtwdl_re_dly2, 25);
  Radix22ButterflyG1_btf1_re_reg_next <= Radix22ButterflyG1_add_cast + Radix22ButterflyG1_add_cast_1;
  Radix22ButterflyG1_sub_cast <= resize(Radix22ButterflyG1_x_re_dly1, 25);
  Radix22ButterflyG1_sub_cast_1 <= resize(Radix22ButterflyG1_dinXtwdl_re_dly2, 25);
  Radix22ButterflyG1_btf2_re_reg_next <= Radix22ButterflyG1_sub_cast - Radix22ButterflyG1_sub_cast_1;
  Radix22ButterflyG1_add_cast_2 <= resize(Radix22ButterflyG1_x_im_dly1, 25);
  Radix22ButterflyG1_add_cast_3 <= resize(Radix22ButterflyG1_dinXtwdl_im_dly2, 25);
  Radix22ButterflyG1_btf1_im_reg_next <= Radix22ButterflyG1_add_cast_2 + Radix22ButterflyG1_add_cast_3;
  Radix22ButterflyG1_sub_cast_2 <= resize(Radix22ButterflyG1_x_im_dly1, 25);
  Radix22ButterflyG1_sub_cast_3 <= resize(Radix22ButterflyG1_dinXtwdl_im_dly2, 25);
  Radix22ButterflyG1_btf2_im_reg_next <= Radix22ButterflyG1_sub_cast_2 - Radix22ButterflyG1_sub_cast_3;
  dinXTwdlf_re <= dinXTwdl_re_signed;
  dinXTwdlf_im <= dinXTwdl_im_signed;
  Radix22ButterflyG1_sra_temp <= SHIFT_RIGHT(Radix22ButterflyG1_btf1_re_reg, 1);
  btf1_re <= Radix22ButterflyG1_sra_temp(23 DOWNTO 0);
  Radix22ButterflyG1_sra_temp_1 <= SHIFT_RIGHT(Radix22ButterflyG1_btf1_im_reg, 1);
  btf1_im <= Radix22ButterflyG1_sra_temp_1(23 DOWNTO 0);
  Radix22ButterflyG1_sra_temp_2 <= SHIFT_RIGHT(Radix22ButterflyG1_btf2_re_reg, 1);
  btf2_re <= Radix22ButterflyG1_sra_temp_2(23 DOWNTO 0);
  Radix22ButterflyG1_sra_temp_3 <= SHIFT_RIGHT(Radix22ButterflyG1_btf2_im_reg, 1);
  btf2_im <= Radix22ButterflyG1_sra_temp_3(23 DOWNTO 0);

  dout_3_1_re <= dout_3_1_re_tmp;

  dout_3_1_im <= dout_3_1_im_tmp;

  dinXTwdl_3_1_vld <= dinXTwdl_3_1_vld_1;

END rtl;

