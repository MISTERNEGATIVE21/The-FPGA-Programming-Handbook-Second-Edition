LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;
use IEEE.math_real.all;
use WORK.calculator_pkg.all;

entity calculator_moore is
  generic (BITS : integer := 32);
  port (clk     : in std_logic;
        reset   : in std_logic;
        start   : in std_logic;
        buttons : in std_logic_vector(4 downto 0);
        switch  : in std_logic_vector(15 downto 0);

        accum   : out std_logic_vector(BITS-1 downto 0));
end entity calculator_moore;

architecture rtl of calculator_moore is

  attribute MARK_DEBUG : string;
  constant BC : natural := natural(log2(real(BITS)));
  signal op_store, last_op : std_logic_vector(4 downto 0);
  signal accumulator : std_logic_vector(BITS-1 downto 0) := (others => '0');
  attribute MARK_DEBUG of op_store    : signal is "TRUE";
  attribute MARK_DEBUG of last_op     : signal is "TRUE";
  attribute MARK_DEBUG of accumulator : signal is "TRUE";
  type state_t is (IDLE, WAIT4BUTTON, ADD, SUB, MULT);
  signal state : state_t := IDLE;
  attribute MARK_DEBUG of state       : signal is "TRUE";
begin

  process (clk)
    variable multiply : integer;
    variable switch_int : integer;
    variable accum_int : integer;
  begin
    switch_int := to_integer(unsigned(switch));
    accum_int  := to_integer(unsigned(accumulator));
    if rising_edge(clk) then
      case state is
        when IDLE =>
          -- Wait for data to be operated on to be entered. Then the user presses
          -- The operation, add, sub, multiply, clear or equal
          last_op     <= buttons; -- operation to perform
          if start then
            state <= WAIT4BUTTON;
          end if;
        when WAIT4BUTTON =>
          -- wait for second data to be entered, then user presses next operation.
          -- In this case, if we get an =, we perform the operation and we're
          -- done. The user can also put in another operation to perform with
          -- a new value on the accumulator.
          if last_op(UP) then
            state <= MULT;
          elsif last_op(DOWN) then
            state <= IDLE;
          elsif last_op(LEFT) then
            state <= ADD;
          elsif last_op(RIGHT) then
            state <= SUB;
          else
            state <= IDLE;
          end if;
        when MULT =>
          multiply    := to_integer(unsigned(accumulator)) * switch_int;
          accumulator <= std_logic_vector(to_unsigned(multiply, accumulator'length));
          state       <= IDLE;
        when ADD =>
          accumulator <= std_logic_vector(to_unsigned(accum_int + switch_int, accumulator'length));
          state       <= IDLE;
        when SUB =>
          accumulator <= std_logic_vector(to_unsigned(accum_int - switch_int, accumulator'length));
          state       <= IDLE;
      end case;
      if reset then
        state       <= IDLE;
        accumulator <= (others => '0');
      end if;
    end if;
  end process;

  accum <= accumulator;
end ;
