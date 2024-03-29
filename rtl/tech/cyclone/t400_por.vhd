-------------------------------------------------------------------------------
--
-- T400 Core
--
-- $Id: t400_por.vhd,v 1.1.1.1 2006-05-06 01:56:44 arniml Exp $
--
-- Wrapper for technology dependent power-on reset circuitry.
--
-- Altera Cyclone flavor.
--
-- Generate a reset upon power-on for specified number of clocks.
--
-------------------------------------------------------------------------------
--
-- Copyright (c) 2006, Arnim Laeuger (arnim.laeuger@gmx.net)
--
-- All rights reserved
--
-- Redistribution and use in source and synthezised forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- Redistributions of source code must retain the above copyright notice,
-- this list of conditions and the following disclaimer.
--
-- Redistributions in synthesized form must reproduce the above copyright
-- notice, this list of conditions and the following disclaimer in the
-- documentation and/or other materials provided with the distribution.
--
-- Neither the name of the author nor the names of other contributors may
-- be used to endorse or promote products derived from this software without
-- specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
--
-- Please report bugs to the author, but before you do so, please
-- make sure that this is not a derivative work and that
-- you have the latest version of this file.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity t400_por is

  generic (
    delay_g     : integer := 4;
    cnt_width_g : integer := 2
  );
  port (
    clk_i   : in  std_logic;
    por_n_o : out std_logic
  );

end t400_por;


library ieee;
use ieee.numeric_std.all;

architecture cyclone of t400_por is

  signal por_cnt_q : unsigned(cnt_width_g-1 downto 0)
    -- pragma translate_off
    -- initialize for simulation only
    := (others => '0')
    -- pragma translate_on
    ;
  signal por_n_q   : std_logic
    -- pragma translate_off
    -- initialize for simulation only
    := '0'
    -- pragma translate_on
    ;

  -- Specify power-up level of por counter and por source.
  -- Refer to "Quartus II Integrated Synthesis", section "Altera Attribute".
  attribute altera_attribute : string;
  attribute altera_attribute of por_cnt_q : signal is "-name POWER_UP_LEVEL LOW";
  attribute altera_attribute of por_n_q   : signal is "-name POWER_UP_LEVEL LOW";

begin

  -----------------------------------------------------------------------------
  -- Process por_cnt
  --
  -- Purpose:
  --   Generate a power-on reset for the specifiec number of clocks.
  --
  por_cnt: process (clk_i)
  begin
    if clk_i'event and clk_i = '1' then
      if por_cnt_q = delay_g-1 then
        por_n_q   <= '1';
      else
        por_cnt_q <= por_cnt_q + 1;
      end if;
    end if;
  end process por_cnt;
  --
  -----------------------------------------------------------------------------

  por_n_o <= por_n_q;

end cyclone;


-------------------------------------------------------------------------------
-- File History:
--
-- $Log: not supported by cvs2svn $
-------------------------------------------------------------------------------
