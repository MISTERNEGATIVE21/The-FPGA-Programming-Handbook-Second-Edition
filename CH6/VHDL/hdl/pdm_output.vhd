-- pdm_output.vhd
-- ------------------------------------
-- PDM output generator
-- ------------------------------------
-- Author : Frank Bruno, Guy Eschemann
-- This is used by tb_pdm to create a PDM testbench for testing.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pdm_output is
  port(
    clk      : in  std_logic;           -- 100 MHz
    data_in  : in  unsigned(6 downto 0);
    data_out : out std_logic := '0'
  );
end entity pdm_output;

architecture rtl of pdm_output is

  signal error : unsigned(6 downto 0) := (others => '0');

begin

  process(clk)
  begin
    if rising_edge(clk) then
      if data_in >= error then
        data_out <= '1';
        error    <= error + 127 - data_in;
      else
        data_out <= '0';
        error    <= error - data_in;
      end if;
    end if;
  end process;
end architecture;
