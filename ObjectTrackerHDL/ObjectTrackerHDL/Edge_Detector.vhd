-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\Edge_Detector.vhd
-- Created: 2024-12-03 00:37:47
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: Edge_Detector
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Preprocess/Edge Detector
-- Hierarchy Level: 2
-- Model version: 3.7
-- 
-- Edge Detector
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ObjectTrackerHDL_pkg.ALL;

ENTITY Edge_Detector IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        in0                               :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        in1_hStart                        :   IN    std_logic;
        in1_hEnd                          :   IN    std_logic;
        in1_vStart                        :   IN    std_logic;
        in1_vEnd                          :   IN    std_logic;
        in1_valid                         :   IN    std_logic;
        out0                              :   OUT   std_logic;
        out1_hStart                       :   OUT   std_logic;
        out1_hEnd                         :   OUT   std_logic;
        out1_vStart                       :   OUT   std_logic;
        out1_vEnd                         :   OUT   std_logic;
        out1_valid                        :   OUT   std_logic
        );
END Edge_Detector;


ARCHITECTURE rtl OF Edge_Detector IS

  -- Component Declarations
  COMPONENT LineBuffer
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          dataIn                          :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          hStartIn                        :   IN    std_logic;
          hEndIn                          :   IN    std_logic;
          vStartIn                        :   IN    std_logic;
          vEndIn                          :   IN    std_logic;
          validIn                         :   IN    std_logic;
          dataOut                         :   OUT   vector_of_std_logic_vector8(0 TO 2);  -- uint8 [3]
          hStartOut                       :   OUT   std_logic;
          hEndOut                         :   OUT   std_logic;
          vStartOut                       :   OUT   std_logic;
          vEndOut                         :   OUT   std_logic;
          validOut                        :   OUT   std_logic;
          processDataOut                  :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT SobelCore
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          pixelInVec                      :   IN    vector_of_std_logic_vector8(0 TO 2);  -- uint8 [3]
          ShiftEnb                        :   IN    std_logic;
          Gv                              :   OUT   std_logic_vector(10 DOWNTO 0);  -- sfix11_En3
          Gh                              :   OUT   std_logic_vector(10 DOWNTO 0)  -- sfix11_En3
          );
  END COMPONENT;

  COMPONENT GenerateBinaryImage
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          grad1                           :   IN    std_logic_vector(10 DOWNTO 0);  -- sfix11_En3
          grad2                           :   IN    std_logic_vector(10 DOWNTO 0);  -- sfix11_En3
          threshold                       :   IN    std_logic_vector(22 DOWNTO 0);  -- ufix23_En6
          binaryImage                     :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : LineBuffer
    USE ENTITY work.LineBuffer(rtl);

  FOR ALL : SobelCore
    USE ENTITY work.SobelCore(rtl);

  FOR ALL : GenerateBinaryImage
    USE ENTITY work.GenerateBinaryImage(rtl);

  -- Signals
  SIGNAL LMKDataOut                       : vector_of_std_logic_vector8(0 TO 2);  -- ufix8 [3]
  SIGNAL LMKhStartOut                     : std_logic;
  SIGNAL LMKhEndOut                       : std_logic;
  SIGNAL LMKvStartOut                     : std_logic;
  SIGNAL LMKvEndOut                       : std_logic;
  SIGNAL LMKvalidOut                      : std_logic;
  SIGNAL LMKShiftEnb                      : std_logic;
  SIGNAL validOutKernelDelay              : std_logic;
  SIGNAL validOutValidKernelDelay         : std_logic;
  SIGNAL intdelay_reg                     : std_logic_vector(9 DOWNTO 0);  -- ufix1 [10]
  SIGNAL validOutDelay                    : std_logic;
  SIGNAL gradcomp1                        : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL gradcomp2                        : std_logic_vector(10 DOWNTO 0);  -- ufix11
  SIGNAL threshold_const                  : unsigned(22 DOWNTO 0);  -- ufix23_En6
  SIGNAL edge_rsvd                        : std_logic;
  SIGNAL edgeNext                         : std_logic;
  SIGNAL Edge_rsvd_1                      : std_logic;
  SIGNAL hStartOutKernelDelay             : std_logic;
  SIGNAL hStartOutValidKernelDelay        : std_logic;
  SIGNAL intdelay_reg_1                   : std_logic_vector(9 DOWNTO 0);  -- ufix1 [10]
  SIGNAL hStartOutDelay                   : std_logic;
  SIGNAL hsNext                           : std_logic;
  SIGNAL hStartOut                        : std_logic;
  SIGNAL hEndOutKernelDelay               : std_logic;
  SIGNAL hEndOutValidKernelDelay          : std_logic;
  SIGNAL intdelay_reg_2                   : std_logic_vector(9 DOWNTO 0);  -- ufix1 [10]
  SIGNAL hEndOutDelay                     : std_logic;
  SIGNAL heNext                           : std_logic;
  SIGNAL hEndOut                          : std_logic;
  SIGNAL vStartOutKernelDelay             : std_logic;
  SIGNAL vStartOutValidKernelDelay        : std_logic;
  SIGNAL intdelay_reg_3                   : std_logic_vector(9 DOWNTO 0);  -- ufix1 [10]
  SIGNAL vStartOutDelay                   : std_logic;
  SIGNAL vsNext                           : std_logic;
  SIGNAL vStartOut                        : std_logic;
  SIGNAL vEndOutKernelDelay               : std_logic;
  SIGNAL vEndOutValidKernelDelay          : std_logic;
  SIGNAL intdelay_reg_4                   : std_logic_vector(9 DOWNTO 0);  -- ufix1 [10]
  SIGNAL vEndOutDelay                     : std_logic;
  SIGNAL veNext                           : std_logic;
  SIGNAL vEndOut                          : std_logic;
  SIGNAL validOut                         : std_logic;

BEGIN
  u_LineBuffer : LineBuffer
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              dataIn => in0,  -- uint8
              hStartIn => in1_hStart,
              hEndIn => in1_hEnd,
              vStartIn => in1_vStart,
              vEndIn => in1_vEnd,
              validIn => in1_valid,
              dataOut => LMKDataOut,  -- uint8 [3]
              hStartOut => LMKhStartOut,
              hEndOut => LMKhEndOut,
              vStartOut => LMKvStartOut,
              vEndOut => LMKvEndOut,
              validOut => LMKvalidOut,
              processDataOut => LMKShiftEnb
              );

  u_SobelCoreNet_inst : SobelCore
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              pixelInVec => LMKDataOut,  -- uint8 [3]
              ShiftEnb => LMKShiftEnb,
              Gv => gradcomp1,  -- sfix11_En3
              Gh => gradcomp2  -- sfix11_En3
              );

  u_BinaryImageNet_inst : GenerateBinaryImage
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              grad1 => gradcomp1,  -- sfix11_En3
              grad2 => gradcomp2,  -- sfix11_En3
              threshold => std_logic_vector(threshold_const),  -- ufix23_En6
              binaryImage => edge_rsvd
              );

  intdelay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      validOutKernelDelay <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' AND LMKShiftEnb = '1' THEN
        validOutKernelDelay <= LMKvalidOut;
      END IF;
    END IF;
  END PROCESS intdelay_process;


  validOutValidKernelDelay <= validOutKernelDelay AND LMKShiftEnb;

  intdelay_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      intdelay_reg <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        intdelay_reg(0) <= validOutValidKernelDelay;
        intdelay_reg(9 DOWNTO 1) <= intdelay_reg(8 DOWNTO 0);
      END IF;
    END IF;
  END PROCESS intdelay_1_process;

  validOutDelay <= intdelay_reg(9);

  threshold_const <= to_unsigned(16#009C40#, 23);

  edgeNext <= validOutDelay AND edge_rsvd;

  reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Edge_rsvd_1 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        Edge_rsvd_1 <= edgeNext;
      END IF;
    END IF;
  END PROCESS reg_process;


  intdelay_2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      hStartOutKernelDelay <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' AND LMKShiftEnb = '1' THEN
        hStartOutKernelDelay <= LMKhStartOut;
      END IF;
    END IF;
  END PROCESS intdelay_2_process;


  hStartOutValidKernelDelay <= hStartOutKernelDelay AND LMKShiftEnb;

  intdelay_3_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      intdelay_reg_1 <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        intdelay_reg_1(0) <= hStartOutValidKernelDelay;
        intdelay_reg_1(9 DOWNTO 1) <= intdelay_reg_1(8 DOWNTO 0);
      END IF;
    END IF;
  END PROCESS intdelay_3_process;

  hStartOutDelay <= intdelay_reg_1(9);

  hsNext <= validOutDelay AND hStartOutDelay;

  reg_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      hStartOut <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        hStartOut <= hsNext;
      END IF;
    END IF;
  END PROCESS reg_1_process;


  out1_hStart <= hStartOut;

  intdelay_4_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      hEndOutKernelDelay <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' AND LMKShiftEnb = '1' THEN
        hEndOutKernelDelay <= LMKhEndOut;
      END IF;
    END IF;
  END PROCESS intdelay_4_process;


  hEndOutValidKernelDelay <= hEndOutKernelDelay AND LMKShiftEnb;

  intdelay_5_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      intdelay_reg_2 <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        intdelay_reg_2(0) <= hEndOutValidKernelDelay;
        intdelay_reg_2(9 DOWNTO 1) <= intdelay_reg_2(8 DOWNTO 0);
      END IF;
    END IF;
  END PROCESS intdelay_5_process;

  hEndOutDelay <= intdelay_reg_2(9);

  heNext <= validOutDelay AND hEndOutDelay;

  reg_2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      hEndOut <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        hEndOut <= heNext;
      END IF;
    END IF;
  END PROCESS reg_2_process;


  out1_hEnd <= hEndOut;

  intdelay_6_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      vStartOutKernelDelay <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' AND LMKShiftEnb = '1' THEN
        vStartOutKernelDelay <= LMKvStartOut;
      END IF;
    END IF;
  END PROCESS intdelay_6_process;


  vStartOutValidKernelDelay <= vStartOutKernelDelay AND LMKShiftEnb;

  intdelay_7_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      intdelay_reg_3 <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        intdelay_reg_3(0) <= vStartOutValidKernelDelay;
        intdelay_reg_3(9 DOWNTO 1) <= intdelay_reg_3(8 DOWNTO 0);
      END IF;
    END IF;
  END PROCESS intdelay_7_process;

  vStartOutDelay <= intdelay_reg_3(9);

  vsNext <= validOutDelay AND vStartOutDelay;

  reg_3_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      vStartOut <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        vStartOut <= vsNext;
      END IF;
    END IF;
  END PROCESS reg_3_process;


  out1_vStart <= vStartOut;

  intdelay_8_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      vEndOutKernelDelay <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' AND LMKShiftEnb = '1' THEN
        vEndOutKernelDelay <= LMKvEndOut;
      END IF;
    END IF;
  END PROCESS intdelay_8_process;


  vEndOutValidKernelDelay <= vEndOutKernelDelay AND LMKShiftEnb;

  intdelay_9_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      intdelay_reg_4 <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        intdelay_reg_4(0) <= vEndOutValidKernelDelay;
        intdelay_reg_4(9 DOWNTO 1) <= intdelay_reg_4(8 DOWNTO 0);
      END IF;
    END IF;
  END PROCESS intdelay_9_process;

  vEndOutDelay <= intdelay_reg_4(9);

  veNext <= validOutDelay AND vEndOutDelay;

  reg_4_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      vEndOut <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        vEndOut <= veNext;
      END IF;
    END IF;
  END PROCESS reg_4_process;


  out1_vEnd <= vEndOut;

  reg_5_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      validOut <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        validOut <= validOutDelay;
      END IF;
    END IF;
  END PROCESS reg_5_process;


  out1_valid <= validOut;

  out0 <= Edge_rsvd_1;

END rtl;

