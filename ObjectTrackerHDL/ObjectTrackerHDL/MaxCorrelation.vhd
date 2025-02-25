-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\MaxCorrelation.vhd
-- Created: 2024-12-03 00:37:46
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: MaxCorrelation
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Track/MaxCorrelation
-- Hierarchy Level: 2
-- Model version: 3.7
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ObjectTrackerHDL_pkg.ALL;

ENTITY MaxCorrelation IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        pixelIn                           :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
        ctrlIn_hStart                     :   IN    std_logic;
        ctrlIn_hEnd                       :   IN    std_logic;
        ctrlIn_vStart                     :   IN    std_logic;
        ctrlIn_vEnd                       :   IN    std_logic;
        ctrlIn_valid                      :   IN    std_logic;
        frameCtrl_vEnd                    :   IN    std_logic;
        maxCol                            :   OUT   std_logic_vector(15 DOWNTO 0);  -- uint16
        maxRow                            :   OUT   std_logic_vector(15 DOWNTO 0)  -- uint16
        );
END MaxCorrelation;


ARCHITECTURE rtl OF MaxCorrelation IS

  -- Component Declarations
  COMPONENT MaxCtrl
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          pixelIn                         :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
          reset_1                         :   IN    std_logic;
          newMaxCtrl                      :   OUT   std_logic;
          sameMaxCtrl                     :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT HV_Counter
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          in0_hStart                      :   IN    std_logic;
          in0_hEnd                        :   IN    std_logic;
          in0_vStart                      :   IN    std_logic;
          in0_vEnd                        :   IN    std_logic;
          in0_valid                       :   IN    std_logic;
          out0                            :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
          out1                            :   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
          );
  END COMPONENT;

  COMPONENT Divide3_block
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          dividend_in                     :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          divisor_in                      :   IN    std_logic_vector(15 DOWNTO 0);  -- uint16
          quotient                        :   OUT   std_logic_vector(15 DOWNTO 0)  -- uint16
          );
  END COMPONENT;

  COMPONENT Divide2
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          dividend_in                     :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          divisor_in                      :   IN    std_logic_vector(15 DOWNTO 0);  -- uint16
          quotient                        :   OUT   std_logic_vector(15 DOWNTO 0)  -- uint16
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : MaxCtrl
    USE ENTITY work.MaxCtrl(rtl);

  FOR ALL : HV_Counter
    USE ENTITY work.HV_Counter(rtl);

  FOR ALL : Divide3_block
    USE ENTITY work.Divide3_block(rtl);

  FOR ALL : Divide2
    USE ENTITY work.Divide2(rtl);

  -- Signals
  SIGNAL vEnd                             : std_logic;
  SIGNAL Delay4_reg                       : std_logic_vector(19 DOWNTO 0);  -- ufix1 [20]
  SIGNAL Delay4_out1                      : std_logic;
  SIGNAL MaxCtrl_out1                     : std_logic;
  SIGNAL MaxCtrl_out2                     : std_logic;
  SIGNAL Constant_out1                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Constant_out1_dtc                : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL HV_Counter_out1                  : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL HV_Counter_out2                  : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL HV_Counter_out2_unsigned         : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Data_Type_Conversion1_out1       : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Switch14_out1                    : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Switch14_out1_dtc                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Switch2_out1                     : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Delay3_out1                      : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Switch2_out1_dtc                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Switch16_out1                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Add3_out1                        : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Delay12_out1                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Switch13_out1                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL HDL_Counter1_ctrl_const_out      : std_logic;
  SIGNAL HDL_Counter1_ctrl_delay_out      : std_logic;
  SIGNAL HDL_Counter1_Initial_Val_out     : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL OR_out1                          : std_logic;
  SIGNAL count_step                       : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL count_reset                      : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL HDL_Counter1_out1                : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL count                            : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL count_1                          : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL count_2                          : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL HDL_Counter1_out                 : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Delay6_out1                      : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL Delay6_out1_unsigned             : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Switch15_out1                    : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Delay7_reg                       : vector_of_unsigned16(0 TO 20);  -- ufix16 [21]
  SIGNAL Delay7_out1                      : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Constant_out1_dtc_1              : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL HV_Counter_out1_unsigned         : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Data_Type_Conversion_out1        : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Switch11_out1                    : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Switch11_out1_dtc                : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Switch1_out1                     : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Delay2_out1                      : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Switch1_out1_dtc                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Switch9_out1                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Add2_out1                        : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Delay9_out1                      : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Switch10_out1                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Delay5_out1                      : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL Delay5_out1_unsigned             : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Switch12_out1                    : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Delay8_reg                       : vector_of_unsigned16(0 TO 20);  -- ufix16 [21]
  SIGNAL Delay8_out1                      : unsigned(15 DOWNTO 0);  -- uint16

BEGIN
  u_MaxCtrl : MaxCtrl
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              pixelIn => pixelIn,  -- sfix24_En16
              reset_1 => frameCtrl_vEnd,
              newMaxCtrl => MaxCtrl_out1,
              sameMaxCtrl => MaxCtrl_out2
              );

  u_HV_Counter : HV_Counter
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              in0_hStart => ctrlIn_hStart,
              in0_hEnd => ctrlIn_hEnd,
              in0_vStart => ctrlIn_vStart,
              in0_vEnd => ctrlIn_vEnd,
              in0_valid => ctrlIn_valid,
              out0 => HV_Counter_out1,  -- uint8
              out1 => HV_Counter_out2  -- uint8
              );

  u_Divide3 : Divide3_block
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              dividend_in => std_logic_vector(Add3_out1),  -- uint8
              divisor_in => std_logic_vector(HDL_Counter1_out1),  -- uint16
              quotient => Delay6_out1  -- uint16
              );

  u_Divide2 : Divide2
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              dividend_in => std_logic_vector(Add2_out1),  -- uint8
              divisor_in => std_logic_vector(HDL_Counter1_out1),  -- uint16
              quotient => Delay5_out1  -- uint16
              );

  vEnd <= frameCtrl_vEnd;

  Delay4_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay4_reg <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        Delay4_reg(0) <= vEnd;
        Delay4_reg(19 DOWNTO 1) <= Delay4_reg(18 DOWNTO 0);
      END IF;
    END IF;
  END PROCESS Delay4_process;

  Delay4_out1 <= Delay4_reg(19);

  Constant_out1 <= to_unsigned(16#00#, 8);

  Constant_out1_dtc <= resize(Constant_out1, 16);

  HV_Counter_out2_unsigned <= unsigned(HV_Counter_out2);

  Data_Type_Conversion1_out1 <= resize(HV_Counter_out2_unsigned, 16);

  
  Switch14_out1 <= Constant_out1_dtc WHEN MaxCtrl_out2 = '0' ELSE
      Data_Type_Conversion1_out1;

  Switch14_out1_dtc <= Switch14_out1(7 DOWNTO 0);

  Delay3_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay3_out1 <= to_unsigned(16#0000#, 16);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        Delay3_out1 <= Switch2_out1;
      END IF;
    END IF;
  END PROCESS Delay3_process;


  
  Switch2_out1 <= Delay3_out1 WHEN MaxCtrl_out1 = '0' ELSE
      Data_Type_Conversion1_out1;

  Switch2_out1_dtc <= Switch2_out1(7 DOWNTO 0);

  
  Switch16_out1 <= Switch14_out1_dtc WHEN MaxCtrl_out1 = '0' ELSE
      Switch2_out1_dtc;

  Delay12_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay12_out1 <= to_unsigned(16#00#, 8);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        Delay12_out1 <= Add3_out1;
      END IF;
    END IF;
  END PROCESS Delay12_process;


  
  Switch13_out1 <= Delay12_out1 WHEN MaxCtrl_out1 = '0' ELSE
      Constant_out1;

  Add3_out1 <= Switch16_out1 + Switch13_out1;

  HDL_Counter1_ctrl_const_out <= '1';

  HDL_Counter1_ctrl_delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      HDL_Counter1_ctrl_delay_out <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        HDL_Counter1_ctrl_delay_out <= HDL_Counter1_ctrl_const_out;
      END IF;
    END IF;
  END PROCESS HDL_Counter1_ctrl_delay_process;


  HDL_Counter1_Initial_Val_out <= to_unsigned(16#0001#, 16);

  OR_out1 <= vEnd OR MaxCtrl_out1;

  -- Free running, Unsigned Counter
  --  initial value   = 1
  --  step value      = 1
  count_step <= to_unsigned(16#0001#, 16);

  count_reset <= to_unsigned(16#0001#, 16);

  count <= HDL_Counter1_out1 + count_step;

  
  count_1 <= HDL_Counter1_out1 WHEN MaxCtrl_out2 = '0' ELSE
      count;

  
  count_2 <= count_1 WHEN OR_out1 = '0' ELSE
      count_reset;

  HDL_Counter1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      HDL_Counter1_out <= to_unsigned(16#0000#, 16);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        HDL_Counter1_out <= count_2;
      END IF;
    END IF;
  END PROCESS HDL_Counter1_process;


  
  HDL_Counter1_out1 <= HDL_Counter1_Initial_Val_out WHEN HDL_Counter1_ctrl_delay_out = '0' ELSE
      HDL_Counter1_out;

  Delay6_out1_unsigned <= unsigned(Delay6_out1);

  Delay7_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay7_reg <= (OTHERS => to_unsigned(16#0000#, 16));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        Delay7_reg(0) <= Switch15_out1;
        Delay7_reg(1 TO 20) <= Delay7_reg(0 TO 19);
      END IF;
    END IF;
  END PROCESS Delay7_process;

  Delay7_out1 <= Delay7_reg(20);

  
  Switch15_out1 <= Delay7_out1 WHEN Delay4_out1 = '0' ELSE
      Delay6_out1_unsigned;

  maxCol <= std_logic_vector(Switch15_out1);

  Constant_out1_dtc_1 <= resize(Constant_out1, 16);

  HV_Counter_out1_unsigned <= unsigned(HV_Counter_out1);

  Data_Type_Conversion_out1 <= resize(HV_Counter_out1_unsigned, 16);

  
  Switch11_out1 <= Constant_out1_dtc_1 WHEN MaxCtrl_out2 = '0' ELSE
      Data_Type_Conversion_out1;

  Switch11_out1_dtc <= Switch11_out1(7 DOWNTO 0);

  Delay2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay2_out1 <= to_unsigned(16#0000#, 16);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        Delay2_out1 <= Switch1_out1;
      END IF;
    END IF;
  END PROCESS Delay2_process;


  
  Switch1_out1 <= Delay2_out1 WHEN MaxCtrl_out1 = '0' ELSE
      Data_Type_Conversion_out1;

  Switch1_out1_dtc <= Switch1_out1(7 DOWNTO 0);

  
  Switch9_out1 <= Switch11_out1_dtc WHEN MaxCtrl_out1 = '0' ELSE
      Switch1_out1_dtc;

  Delay9_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay9_out1 <= to_unsigned(16#00#, 8);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        Delay9_out1 <= Add2_out1;
      END IF;
    END IF;
  END PROCESS Delay9_process;


  
  Switch10_out1 <= Delay9_out1 WHEN MaxCtrl_out1 = '0' ELSE
      Constant_out1;

  Add2_out1 <= Switch9_out1 + Switch10_out1;

  Delay5_out1_unsigned <= unsigned(Delay5_out1);

  Delay8_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay8_reg <= (OTHERS => to_unsigned(16#0000#, 16));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        Delay8_reg(0) <= Switch12_out1;
        Delay8_reg(1 TO 20) <= Delay8_reg(0 TO 19);
      END IF;
    END IF;
  END PROCESS Delay8_process;

  Delay8_out1 <= Delay8_reg(20);

  
  Switch12_out1 <= Delay8_out1 WHEN Delay4_out1 = '0' ELSE
      Delay5_out1_unsigned;

  maxRow <= std_logic_vector(Switch12_out1);

END rtl;

