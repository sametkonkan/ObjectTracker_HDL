-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ObjectTrackerHDL\CounterDelay_block.vhd
-- Created: 2024-12-03 00:37:46
-- 
-- Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: CounterDelay_block
-- Source Path: ObjectTrackerHDL/ObjectTrackerHDL/Track/2-DCorrelation/Curr2-DFFT/CornerTurnMemory/CounterDelay
-- Hierarchy Level: 5
-- Model version: 3.7
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY CounterDelay_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        vld_in                            :   IN    std_logic;
        vld_out                           :   OUT   std_logic
        );
END CounterDelay_block;


ARCHITECTURE rtl OF CounterDelay_block IS

  -- Signals
  SIGNAL wr_cntr                          : unsigned(14 DOWNTO 0);  -- ufix15
  SIGNAL rd_cntr                          : unsigned(14 DOWNTO 0);  -- ufix15
  SIGNAL rdrw_cntr                        : unsigned(14 DOWNTO 0);  -- ufix15
  SIGNAL rdbl_cntr                        : unsigned(14 DOWNTO 0);  -- ufix15
  SIGNAL flush_cntr                       : unsigned(13 DOWNTO 0);  -- ufix14
  SIGNAL state                            : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL wr_cntr_next                     : unsigned(14 DOWNTO 0);  -- ufix15
  SIGNAL rd_cntr_next                     : unsigned(14 DOWNTO 0);  -- ufix15
  SIGNAL rdrw_cntr_next                   : unsigned(14 DOWNTO 0);  -- ufix15
  SIGNAL rdbl_cntr_next                   : unsigned(14 DOWNTO 0);  -- ufix15
  SIGNAL flush_cntr_next                  : unsigned(13 DOWNTO 0);  -- ufix14
  SIGNAL state_next                       : unsigned(1 DOWNTO 0);  -- ufix2

BEGIN
  CounterDelay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      wr_cntr <= to_unsigned(16#0000#, 15);
      rd_cntr <= to_unsigned(16#0000#, 15);
      rdrw_cntr <= to_unsigned(16#0000#, 15);
      rdbl_cntr <= to_unsigned(16#0000#, 15);
      flush_cntr <= to_unsigned(16#0000#, 14);
      state <= to_unsigned(16#0#, 2);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        wr_cntr <= wr_cntr_next;
        rd_cntr <= rd_cntr_next;
        rdrw_cntr <= rdrw_cntr_next;
        rdbl_cntr <= rdbl_cntr_next;
        flush_cntr <= flush_cntr_next;
        state <= state_next;
      END IF;
    END IF;
  END PROCESS CounterDelay_process;

  CounterDelay_output : PROCESS (flush_cntr, rd_cntr, rdbl_cntr, rdrw_cntr, state, vld_in, wr_cntr)
    VARIABLE wr_cntr_temp : unsigned(14 DOWNTO 0);
    VARIABLE rdbl_cntr_temp : unsigned(14 DOWNTO 0);
  BEGIN
    wr_cntr_temp := wr_cntr;
    rdbl_cntr_temp := rdbl_cntr;
    rd_cntr_next <= rd_cntr;
    rdrw_cntr_next <= rdrw_cntr;
    flush_cntr_next <= flush_cntr;
    state_next <= state;
    --dcount = fi(wr_cntr-rd_cntr,CNTR_NT, FM);
    vld_out <= '0';
    CASE state IS
      WHEN "00" =>
        IF wr_cntr = to_unsigned(16#4000#, 15) THEN 
          vld_out <= '1';
          state_next <= to_unsigned(16#1#, 2);
          flush_cntr_next <= to_unsigned(16#3FFF#, 14);
          rd_cntr_next <= rd_cntr + to_unsigned(16#0001#, 15);
          rdrw_cntr_next <= rdrw_cntr + to_unsigned(16#0001#, 15);
          wr_cntr_temp := to_unsigned(16#0000#, 15);
        END IF;
      WHEN "01" =>
        IF flush_cntr = to_unsigned(16#0001#, 14) THEN 
          state_next <= to_unsigned(16#3#, 2);
        END IF;
        IF rdrw_cntr < to_unsigned(16#0080#, 15) THEN 
          rd_cntr_next <= rd_cntr + to_unsigned(16#0001#, 15);
          rdrw_cntr_next <= rdrw_cntr + to_unsigned(16#0001#, 15);
          flush_cntr_next <= flush_cntr - to_unsigned(16#0001#, 14);
          vld_out <= '1';
        ELSE 
          rdbl_cntr_temp := rdbl_cntr + to_unsigned(16#0001#, 15);
        END IF;
        IF rdbl_cntr_temp >= to_unsigned(16#002C#, 15) THEN 
          rdrw_cntr_next <= to_unsigned(16#0000#, 15);
          rdbl_cntr_temp := to_unsigned(16#0000#, 15);
        END IF;
      WHEN "11" =>
        IF wr_cntr = to_unsigned(16#4000#, 15) THEN 
          --* 2 -1 
          state_next <= to_unsigned(16#0#, 2);
          --          if rd_cntr ~= DELAY
          --              disp(rd_cntr);
          --             error('Out of sync Counter (RD)');
          --          end
          rd_cntr_next <= to_unsigned(16#0000#, 15);
          --          if wr_cntr ~= DELAY
          --              disp(wr_cntr);
          --             error('Out of sync Counter (WR)');
          --          end
          --wr_cntr(:) = 0;
          flush_cntr_next <= to_unsigned(16#3FFF#, 14);
        ELSE 
          state_next <= to_unsigned(16#3#, 2);
        END IF;
      WHEN OTHERS => 
        NULL;
    END CASE;
    IF vld_in = '1' THEN 
      wr_cntr_temp := wr_cntr_temp + to_unsigned(16#0001#, 15);
    END IF;
    wr_cntr_next <= wr_cntr_temp;
    rdbl_cntr_next <= rdbl_cntr_temp;
  END PROCESS CounterDelay_output;


END rtl;
