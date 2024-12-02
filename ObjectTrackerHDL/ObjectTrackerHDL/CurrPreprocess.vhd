-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\CurrPreprocess.vhd
-- Created: 2024-12-03 00:37:46
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: CurrPreprocess
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Preprocess/CurrPreprocess
-- Hierarchy Level: 2
-- Model version: 3.7
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ObjectTrackerHDL_pkg.ALL;

ENTITY CurrPreprocess IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        pixelIn                           :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        pixelWindow                       :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16_En16
        ctrlIn_hStart                     :   IN    std_logic;
        ctrlIn_hEnd                       :   IN    std_logic;
        ctrlIn_vStart                     :   IN    std_logic;
        ctrlIn_vEnd                       :   IN    std_logic;
        ctrlIn_valid                      :   IN    std_logic;
        frameCtrl_vEnd                    :   IN    std_logic;
        pixelOut                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        ctrlOut_valid                     :   OUT   std_logic
        );
END CurrPreprocess;


ARCHITECTURE rtl OF CurrPreprocess IS

  -- Component Declarations
  COMPONENT Gamma_Corrector
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          in0                             :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          in1_hStart                      :   IN    std_logic;
          in1_hEnd                        :   IN    std_logic;
          in1_vStart                      :   IN    std_logic;
          in1_vEnd                        :   IN    std_logic;
          in1_valid                       :   IN    std_logic;
          out0                            :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
          out1_hStart                     :   OUT   std_logic;
          out1_hEnd                       :   OUT   std_logic;
          out1_vStart                     :   OUT   std_logic;
          out1_vEnd                       :   OUT   std_logic;
          out1_valid                      :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT Image_Statistics
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          in0                             :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          in1_hStart                      :   IN    std_logic;
          in1_hEnd                        :   IN    std_logic;
          in1_vStart                      :   IN    std_logic;
          in1_vEnd                        :   IN    std_logic;
          in1_valid                       :   IN    std_logic;
          out0                            :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
          out1                            :   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
          );
  END COMPONENT;

  COMPONENT Divide1
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          dividend_in                     :   IN    std_logic_vector(27 DOWNTO 0);  -- sfix28_En12
          divisor_in                      :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          quotient                        :   OUT   std_logic_vector(15 DOWNTO 0)  -- sfix16_En12
          );
  END COMPONENT;

  COMPONENT Product
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          mulIn1                          :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16_En16
          mulIn2                          :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En12
          mulOut                          :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : Gamma_Corrector
    USE ENTITY work.Gamma_Corrector(rtl);

  FOR ALL : Image_Statistics
    USE ENTITY work.Image_Statistics(rtl);

  FOR ALL : Divide1
    USE ENTITY work.Divide1(rtl);

  FOR ALL : Product
    USE ENTITY work.Product(rtl);

  -- Signals
  SIGNAL pixelWindow_unsigned             : unsigned(15 DOWNTO 0);  -- ufix16_En16
  SIGNAL Delay_reg                        : vector_of_unsigned16(0 TO 33);  -- ufix16 [34]
  SIGNAL Delay_out1                       : unsigned(15 DOWNTO 0);  -- ufix16_En16
  SIGNAL Gamma_Corrector_out1             : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL Gamma_Corrector_out2_hStart      : std_logic;
  SIGNAL Gamma_Corrector_out2_hEnd        : std_logic;
  SIGNAL Gamma_Corrector_out2_vStart      : std_logic;
  SIGNAL Gamma_Corrector_out2_vEnd        : std_logic;
  SIGNAL Gamma_Corrector_out2_valid       : std_logic;
  SIGNAL Gamma_Corrector_out1_unsigned    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL vEnd                             : std_logic;
  SIGNAL count_step                       : unsigned(11 DOWNTO 0);  -- ufix12
  SIGNAL count_from                       : unsigned(11 DOWNTO 0);  -- ufix12
  SIGNAL HDL_Counter2_out1                : unsigned(11 DOWNTO 0);  -- ufix12
  SIGNAL count                            : unsigned(11 DOWNTO 0);  -- ufix12
  SIGNAL need_to_wrap                     : std_logic;
  SIGNAL count_value                      : unsigned(11 DOWNTO 0);  -- ufix12
  SIGNAL count_1                          : unsigned(11 DOWNTO 0);  -- ufix12
  SIGNAL Compare_To_Constant1_out1        : std_logic;
  SIGNAL mean_out1                        : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Image_Statistics_out1            : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL Image_Statistics_out2            : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL Image_Statistics_out1_unsigned   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL stdDev_out1                      : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Image_Statistics_out2_unsigned   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Switch_out1                      : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Subtract2_sub_cast               : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL Subtract2_sub_cast_1             : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL Subtract2_out1                   : signed(15 DOWNTO 0);  -- int16
  SIGNAL Data_Type_Conversion_out1        : signed(27 DOWNTO 0);  -- sfix28_En12
  SIGNAL Switch1_out1                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Delay1_out1                      : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL Product_out1                     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Product_out1_signed              : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Delay2_reg                       : vector_of_signed32(0 TO 29);  -- sfix32 [30]
  SIGNAL Delay2_out1                      : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL alpha_reg_4                      : std_logic_vector(67 DOWNTO 0);  -- ufix1 [68]
  SIGNAL Delay3_out1_valid                : std_logic;

BEGIN
  u_Gamma_Corrector : Gamma_Corrector
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              in0 => pixelIn,  -- uint8
              in1_hStart => ctrlIn_hStart,
              in1_hEnd => ctrlIn_hEnd,
              in1_vStart => ctrlIn_vStart,
              in1_vEnd => ctrlIn_vEnd,
              in1_valid => ctrlIn_valid,
              out0 => Gamma_Corrector_out1,  -- uint8
              out1_hStart => Gamma_Corrector_out2_hStart,
              out1_hEnd => Gamma_Corrector_out2_hEnd,
              out1_vStart => Gamma_Corrector_out2_vStart,
              out1_vEnd => Gamma_Corrector_out2_vEnd,
              out1_valid => Gamma_Corrector_out2_valid
              );

  u_Image_Statistics : Image_Statistics
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              in0 => Gamma_Corrector_out1,  -- uint8
              in1_hStart => Gamma_Corrector_out2_hStart,
              in1_hEnd => Gamma_Corrector_out2_hEnd,
              in1_vStart => Gamma_Corrector_out2_vStart,
              in1_vEnd => Gamma_Corrector_out2_vEnd,
              in1_valid => Gamma_Corrector_out2_valid,
              out0 => Image_Statistics_out1,  -- uint8
              out1 => Image_Statistics_out2  -- uint8
              );

  u_Divide1 : Divide1
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              dividend_in => std_logic_vector(Data_Type_Conversion_out1),  -- sfix28_En12
              divisor_in => std_logic_vector(Switch1_out1),  -- uint8
              quotient => Delay1_out1  -- sfix16_En12
              );

  u_Multiply_ShiftAdd_inst : Product
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              mulIn1 => std_logic_vector(Delay_out1),  -- ufix16_En16
              mulIn2 => Delay1_out1,  -- sfix16_En12
              mulOut => Product_out1  -- sfix32_En28
              );

  pixelWindow_unsigned <= unsigned(pixelWindow);

  Delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay_reg <= (OTHERS => to_unsigned(16#0000#, 16));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        Delay_reg(0) <= pixelWindow_unsigned;
        Delay_reg(1 TO 33) <= Delay_reg(0 TO 32);
      END IF;
    END IF;
  END PROCESS Delay_process;

  Delay_out1 <= Delay_reg(33);

  Gamma_Corrector_out1_unsigned <= unsigned(Gamma_Corrector_out1);

  vEnd <= frameCtrl_vEnd;

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 4095
  count_step <= to_unsigned(16#001#, 12);

  count_from <= to_unsigned(16#000#, 12);

  count <= HDL_Counter2_out1 + count_step;

  
  need_to_wrap <= '1' WHEN HDL_Counter2_out1 = to_unsigned(16#FFF#, 12) ELSE
      '0';

  
  count_value <= count WHEN need_to_wrap = '0' ELSE
      count_from;

  
  count_1 <= HDL_Counter2_out1 WHEN vEnd = '0' ELSE
      count_value;

  HDL_Counter2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      HDL_Counter2_out1 <= to_unsigned(16#000#, 12);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        HDL_Counter2_out1 <= count_1;
      END IF;
    END IF;
  END PROCESS HDL_Counter2_process;


  
  Compare_To_Constant1_out1 <= '1' WHEN HDL_Counter2_out1 >= to_unsigned(16#001#, 12) ELSE
      '0';

  mean_out1 <= to_unsigned(16#33#, 8);

  Image_Statistics_out1_unsigned <= unsigned(Image_Statistics_out1);

  stdDev_out1 <= to_unsigned(16#1B#, 8);

  Image_Statistics_out2_unsigned <= unsigned(Image_Statistics_out2);

  
  Switch_out1 <= mean_out1 WHEN Compare_To_Constant1_out1 = '0' ELSE
      Image_Statistics_out1_unsigned;

  Subtract2_sub_cast <= signed(resize(Gamma_Corrector_out1_unsigned, 9));
  Subtract2_sub_cast_1 <= signed(resize(Switch_out1, 9));
  Subtract2_out1 <= resize(Subtract2_sub_cast - Subtract2_sub_cast_1, 16);

  Data_Type_Conversion_out1 <= Subtract2_out1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0';

  
  Switch1_out1 <= stdDev_out1 WHEN Compare_To_Constant1_out1 = '0' ELSE
      Image_Statistics_out2_unsigned;

  Product_out1_signed <= signed(Product_out1);

  Delay2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay2_reg <= (OTHERS => to_signed(0, 32));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        Delay2_reg(0) <= Product_out1_signed;
        Delay2_reg(1 TO 29) <= Delay2_reg(0 TO 28);
      END IF;
    END IF;
  END PROCESS Delay2_process;

  Delay2_out1 <= Delay2_reg(29);

  pixelOut <= std_logic_vector(Delay2_out1);

  c_4_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      alpha_reg_4 <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        alpha_reg_4(0) <= Gamma_Corrector_out2_valid;
        alpha_reg_4(67 DOWNTO 1) <= alpha_reg_4(66 DOWNTO 0);
      END IF;
    END IF;
  END PROCESS c_4_process;

  Delay3_out1_valid <= alpha_reg_4(67);

  ctrlOut_valid <= Delay3_out1_valid;

END rtl;

