-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\RADIX2FFT_bitNatural.vhd
-- Created: 2024-12-03 00:37:45
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: RADIX2FFT_bitNatural
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Track/2-DCorrelation/2-DIFFT/ColumnIFFT/RADIX2FFT_bitNatural
-- Hierarchy Level: 5
-- Model version: 3.7
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY RADIX2FFT_bitNatural IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        dout_7_re                         :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
        dout_7_im                         :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
        dout_7_vld                        :   IN    std_logic;
        dout_im1                          :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
        dout_vld1                         :   OUT   std_logic
        );
END RADIX2FFT_bitNatural;


ARCHITECTURE rtl OF RADIX2FFT_bitNatural IS

  -- Component Declarations
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

  -- Component Configuration Statements
  FOR ALL : SimpleDualPortRAM_generic_block
    USE ENTITY work.SimpleDualPortRAM_generic_block(rtl);

  -- Functions
  -- HDLCODER_TO_STDLOGIC 
  FUNCTION hdlcoder_to_stdlogic(arg: boolean) RETURN std_logic IS
  BEGIN
    IF arg THEN
      RETURN '1';
    ELSE
      RETURN '0';
    END IF;
  END FUNCTION;


  -- Signals
  SIGNAL wrStateMachineBitNatural_wrState : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL wrStateMachineBitNatural_wrAddrCnt : unsigned(6 DOWNTO 0);  -- ufix7
  SIGNAL wrStateMachineBitNatural_wrState_next : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL wrStateMachineBitNatural_wrAddrCnt_next : unsigned(6 DOWNTO 0);  -- ufix7
  SIGNAL WrEnb                            : std_logic;
  SIGNAL wrAddr                           : unsigned(6 DOWNTO 0);  -- ufix7
  SIGNAL sampleIdx                        : unsigned(6 DOWNTO 0);  -- ufix7
  SIGNAL rdAddr                           : unsigned(6 DOWNTO 0);  -- ufix7
  SIGNAL memOut_im                        : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL memOut_im_signed                 : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL memOut_re                        : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL memOut_re_signed                 : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL rdStateMachineBitNatural_rdState : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL rdStateMachineBitNatural_rdAddrCnt : unsigned(6 DOWNTO 0);  -- ufix7
  SIGNAL rdStateMachineBitNatural_doutVldReg1 : std_logic;
  SIGNAL rdStateMachineBitNatural_doutVldReg2 : std_logic;
  SIGNAL rdStateMachineBitNatural_doutReReg : signed(23 DOWNTO 0);  -- sfix24
  SIGNAL rdStateMachineBitNatural_doutImReg : signed(23 DOWNTO 0);  -- sfix24
  SIGNAL rdStateMachineBitNatural_startOutReg : std_logic;
  SIGNAL rdStateMachineBitNatural_endOutReg1 : std_logic;
  SIGNAL rdStateMachineBitNatural_endOutReg2 : std_logic;
  SIGNAL rdStateMachineBitNatural_rdState_next : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL rdStateMachineBitNatural_rdAddrCnt_next : unsigned(6 DOWNTO 0);  -- ufix7
  SIGNAL rdStateMachineBitNatural_doutVldReg1_next : std_logic;
  SIGNAL rdStateMachineBitNatural_doutVldReg2_next : std_logic;
  SIGNAL rdStateMachineBitNatural_doutReReg_next : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL rdStateMachineBitNatural_doutImReg_next : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL rdStateMachineBitNatural_startOutReg_next : std_logic;
  SIGNAL rdStateMachineBitNatural_endOutReg1_next : std_logic;
  SIGNAL rdStateMachineBitNatural_endOutReg2_next : std_logic;
  SIGNAL dout_re1_tmp                     : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL dout_im1_tmp                     : signed(23 DOWNTO 0);  -- sfix24_En16
  SIGNAL startOutW                        : std_logic;
  SIGNAL endOutW                          : std_logic;

BEGIN
  u_dataMEM_im_1 : SimpleDualPortRAM_generic_block
    GENERIC MAP( AddrWidth => 7,
                 DataWidth => 24
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => dout_7_im,
              wr_addr => std_logic_vector(wrAddr),
              wr_en => WrEnb,
              rd_addr => std_logic_vector(rdAddr),
              dout => memOut_im
              );

  u_dataMEM_re_1 : SimpleDualPortRAM_generic_block
    GENERIC MAP( AddrWidth => 7,
                 DataWidth => 24
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => dout_7_re,
              wr_addr => std_logic_vector(wrAddr),
              wr_en => WrEnb,
              rd_addr => std_logic_vector(rdAddr),
              dout => memOut_re
              );

  -- wrStateMachineBitNatural
  wrStateMachineBitNatural_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      wrStateMachineBitNatural_wrState <= to_unsigned(16#0#, 2);
      wrStateMachineBitNatural_wrAddrCnt <= to_unsigned(16#00#, 7);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        wrStateMachineBitNatural_wrState <= wrStateMachineBitNatural_wrState_next;
        wrStateMachineBitNatural_wrAddrCnt <= wrStateMachineBitNatural_wrAddrCnt_next;
      END IF;
    END IF;
  END PROCESS wrStateMachineBitNatural_process;

  wrStateMachineBitNatural_output : PROCESS (dout_7_vld, wrStateMachineBitNatural_wrAddrCnt,
       wrStateMachineBitNatural_wrState)
  BEGIN
    wrStateMachineBitNatural_wrState_next <= wrStateMachineBitNatural_wrState;
    wrStateMachineBitNatural_wrAddrCnt_next <= wrStateMachineBitNatural_wrAddrCnt;
    IF wrStateMachineBitNatural_wrState = to_unsigned(16#2#, 2) THEN 
      wrAddr <= unsigned'(wrStateMachineBitNatural_wrAddrCnt(0) & wrStateMachineBitNatural_wrAddrCnt(1) & wrStateMachineBitNatural_wrAddrCnt(2) & wrStateMachineBitNatural_wrAddrCnt(3) & wrStateMachineBitNatural_wrAddrCnt(4) & wrStateMachineBitNatural_wrAddrCnt(5) & wrStateMachineBitNatural_wrAddrCnt(6));
    ELSE 
      wrAddr <= wrStateMachineBitNatural_wrAddrCnt;
    END IF;
    CASE wrStateMachineBitNatural_wrState IS
      WHEN "00" =>
        IF dout_7_vld = '1' THEN 
          wrStateMachineBitNatural_wrState_next <= to_unsigned(16#1#, 2);
          wrStateMachineBitNatural_wrAddrCnt_next <= to_unsigned(16#01#, 7);
        ELSE 
          wrStateMachineBitNatural_wrState_next <= to_unsigned(16#0#, 2);
          wrStateMachineBitNatural_wrAddrCnt_next <= to_unsigned(16#00#, 7);
        END IF;
      WHEN "01" =>
        IF dout_7_vld = '1' THEN 
          IF wrStateMachineBitNatural_wrAddrCnt = to_unsigned(16#7F#, 7) THEN 
            wrStateMachineBitNatural_wrAddrCnt_next <= to_unsigned(16#00#, 7);
            wrStateMachineBitNatural_wrState_next <= to_unsigned(16#2#, 2);
          ELSE 
            wrStateMachineBitNatural_wrAddrCnt_next <= wrStateMachineBitNatural_wrAddrCnt + to_unsigned(16#01#, 7);
            wrStateMachineBitNatural_wrState_next <= to_unsigned(16#1#, 2);
          END IF;
        END IF;
      WHEN "10" =>
        IF dout_7_vld = '1' THEN 
          IF wrStateMachineBitNatural_wrAddrCnt = to_unsigned(16#7F#, 7) THEN 
            wrStateMachineBitNatural_wrAddrCnt_next <= to_unsigned(16#00#, 7);
            wrStateMachineBitNatural_wrState_next <= to_unsigned(16#1#, 2);
          ELSE 
            wrStateMachineBitNatural_wrAddrCnt_next <= wrStateMachineBitNatural_wrAddrCnt + to_unsigned(16#01#, 7);
            wrStateMachineBitNatural_wrState_next <= to_unsigned(16#2#, 2);
          END IF;
        END IF;
      WHEN OTHERS => 
        wrStateMachineBitNatural_wrState_next <= to_unsigned(16#0#, 2);
        wrStateMachineBitNatural_wrAddrCnt_next <= to_unsigned(16#00#, 7);
    END CASE;
    WrEnb <= dout_7_vld;
    sampleIdx <= wrStateMachineBitNatural_wrAddrCnt;
  END PROCESS wrStateMachineBitNatural_output;


  memOut_im_signed <= signed(memOut_im);

  memOut_re_signed <= signed(memOut_re);

  -- rdStateMachineBitNatural
  rdStateMachineBitNatural_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      rdStateMachineBitNatural_rdState <= to_unsigned(16#0#, 2);
      rdStateMachineBitNatural_rdAddrCnt <= to_unsigned(16#00#, 7);
      rdStateMachineBitNatural_doutVldReg1 <= '0';
      rdStateMachineBitNatural_doutVldReg2 <= '0';
      rdStateMachineBitNatural_doutReReg <= to_signed(16#000000#, 24);
      rdStateMachineBitNatural_doutImReg <= to_signed(16#000000#, 24);
      rdStateMachineBitNatural_startOutReg <= '0';
      rdStateMachineBitNatural_endOutReg1 <= '0';
      rdStateMachineBitNatural_endOutReg2 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        rdStateMachineBitNatural_rdState <= rdStateMachineBitNatural_rdState_next;
        rdStateMachineBitNatural_rdAddrCnt <= rdStateMachineBitNatural_rdAddrCnt_next;
        rdStateMachineBitNatural_doutVldReg1 <= rdStateMachineBitNatural_doutVldReg1_next;
        rdStateMachineBitNatural_doutVldReg2 <= rdStateMachineBitNatural_doutVldReg2_next;
        rdStateMachineBitNatural_doutReReg <= rdStateMachineBitNatural_doutReReg_next;
        rdStateMachineBitNatural_doutImReg <= rdStateMachineBitNatural_doutImReg_next;
        rdStateMachineBitNatural_startOutReg <= rdStateMachineBitNatural_startOutReg_next;
        rdStateMachineBitNatural_endOutReg1 <= rdStateMachineBitNatural_endOutReg1_next;
        rdStateMachineBitNatural_endOutReg2 <= rdStateMachineBitNatural_endOutReg2_next;
      END IF;
    END IF;
  END PROCESS rdStateMachineBitNatural_process;

  rdStateMachineBitNatural_output : PROCESS (memOut_im_signed, memOut_re_signed, rdStateMachineBitNatural_doutImReg,
       rdStateMachineBitNatural_doutReReg, rdStateMachineBitNatural_doutVldReg1,
       rdStateMachineBitNatural_doutVldReg2,
       rdStateMachineBitNatural_endOutReg1, rdStateMachineBitNatural_endOutReg2,
       rdStateMachineBitNatural_rdAddrCnt, rdStateMachineBitNatural_rdState,
       rdStateMachineBitNatural_startOutReg, sampleIdx)
  BEGIN
    rdStateMachineBitNatural_doutReReg_next <= rdStateMachineBitNatural_doutReReg;
    rdStateMachineBitNatural_doutImReg_next <= rdStateMachineBitNatural_doutImReg;
    IF rdStateMachineBitNatural_rdState = to_unsigned(16#1#, 2) THEN 
      rdAddr <= unsigned'(rdStateMachineBitNatural_rdAddrCnt(0) & rdStateMachineBitNatural_rdAddrCnt(1) & rdStateMachineBitNatural_rdAddrCnt(2) & rdStateMachineBitNatural_rdAddrCnt(3) & rdStateMachineBitNatural_rdAddrCnt(4) & rdStateMachineBitNatural_rdAddrCnt(5) & rdStateMachineBitNatural_rdAddrCnt(6));
    ELSE 
      rdAddr <= rdStateMachineBitNatural_rdAddrCnt;
    END IF;
    rdStateMachineBitNatural_endOutReg2_next <= rdStateMachineBitNatural_endOutReg1;
    rdStateMachineBitNatural_startOutReg_next <= hdlcoder_to_stdlogic(rdStateMachineBitNatural_rdAddrCnt = to_unsigned(16#01#, 7));
    CASE rdStateMachineBitNatural_rdState IS
      WHEN "00" =>
        rdStateMachineBitNatural_doutVldReg1_next <= '0';
        IF sampleIdx >= to_unsigned(16#6D#, 7) THEN 
          rdStateMachineBitNatural_rdAddrCnt_next <= to_unsigned(16#01#, 7);
          rdStateMachineBitNatural_doutVldReg1_next <= '1';
          rdStateMachineBitNatural_rdState_next <= to_unsigned(16#1#, 2);
          rdStateMachineBitNatural_endOutReg1_next <= '0';
        ELSE 
          rdStateMachineBitNatural_rdAddrCnt_next <= to_unsigned(16#00#, 7);
          rdStateMachineBitNatural_rdState_next <= to_unsigned(16#0#, 2);
          rdStateMachineBitNatural_endOutReg1_next <= '0';
        END IF;
      WHEN "01" =>
        rdStateMachineBitNatural_doutVldReg1_next <= '1';
        IF rdStateMachineBitNatural_rdAddrCnt = to_unsigned(16#7F#, 7) THEN 
          rdStateMachineBitNatural_rdAddrCnt_next <= to_unsigned(16#00#, 7);
          rdStateMachineBitNatural_rdState_next <= to_unsigned(16#2#, 2);
          rdStateMachineBitNatural_endOutReg1_next <= '1';
        ELSE 
          rdStateMachineBitNatural_rdAddrCnt_next <= rdStateMachineBitNatural_rdAddrCnt + to_unsigned(16#01#, 7);
          rdStateMachineBitNatural_rdState_next <= to_unsigned(16#1#, 2);
          rdStateMachineBitNatural_endOutReg1_next <= '0';
        END IF;
      WHEN "10" =>
        rdStateMachineBitNatural_doutVldReg1_next <= '0';
        IF sampleIdx >= to_unsigned(16#6D#, 7) THEN 
          rdStateMachineBitNatural_rdAddrCnt_next <= to_unsigned(16#01#, 7);
          rdStateMachineBitNatural_doutVldReg1_next <= '1';
          rdStateMachineBitNatural_rdState_next <= to_unsigned(16#3#, 2);
          rdStateMachineBitNatural_endOutReg1_next <= '0';
        ELSE 
          rdStateMachineBitNatural_rdAddrCnt_next <= to_unsigned(16#00#, 7);
          rdStateMachineBitNatural_rdState_next <= to_unsigned(16#2#, 2);
          rdStateMachineBitNatural_endOutReg1_next <= '0';
        END IF;
      WHEN "11" =>
        rdStateMachineBitNatural_doutVldReg1_next <= '1';
        IF rdStateMachineBitNatural_rdAddrCnt = to_unsigned(16#7F#, 7) THEN 
          rdStateMachineBitNatural_rdAddrCnt_next <= to_unsigned(16#00#, 7);
          rdStateMachineBitNatural_rdState_next <= to_unsigned(16#0#, 2);
          rdStateMachineBitNatural_endOutReg1_next <= '1';
        ELSE 
          rdStateMachineBitNatural_rdAddrCnt_next <= rdStateMachineBitNatural_rdAddrCnt + to_unsigned(16#01#, 7);
          rdStateMachineBitNatural_rdState_next <= to_unsigned(16#3#, 2);
          rdStateMachineBitNatural_endOutReg1_next <= '0';
        END IF;
      WHEN OTHERS => 
        rdStateMachineBitNatural_rdState_next <= to_unsigned(16#0#, 2);
        rdStateMachineBitNatural_rdAddrCnt_next <= to_unsigned(16#00#, 7);
        rdStateMachineBitNatural_doutVldReg1_next <= '0';
        rdStateMachineBitNatural_endOutReg1_next <= '0';
    END CASE;
    IF rdStateMachineBitNatural_doutVldReg1 = '1' THEN 
      rdStateMachineBitNatural_doutReReg_next <= memOut_re_signed;
      rdStateMachineBitNatural_doutImReg_next <= memOut_im_signed;
    END IF;
    rdStateMachineBitNatural_doutVldReg2_next <= rdStateMachineBitNatural_doutVldReg1;
    dout_re1_tmp <= rdStateMachineBitNatural_doutReReg;
    dout_im1_tmp <= rdStateMachineBitNatural_doutImReg;
    dout_vld1 <= rdStateMachineBitNatural_doutVldReg2;
    startOutW <= rdStateMachineBitNatural_startOutReg;
    endOutW <= rdStateMachineBitNatural_endOutReg2;
  END PROCESS rdStateMachineBitNatural_output;


  dout_im1 <= std_logic_vector(dout_im1_tmp);


END rtl;

