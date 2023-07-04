-- simple_ff_async.vhd
-- ------------------------------------
-- Show synchronous and Asynchronous reset implementations
-- ------------------------------------
-- Author : Frank Bruno, Guy Eschemann

library IEEE;
use IEEE.std_logic_1164.all;

entity simple_ff_async is
  generic(
    ASYNC : string := "TRUE"
  );
  port(
    D  : in  std_logic;
    SR : in  std_logic;
    CE : in  std_logic;
    CK : in  std_logic;
    Q  : out std_logic
  );
end entity simple_ff_async;

architecture rtl of simple_ff_async is

  signal reg : std_logic := '1';        -- optional initial value

begin
  g_ASYNC : if ASYNC = "TRUE" generate
    FF : process(CK, SR)
    begin
      if SR then
        reg <= '0';
      elsif rising_edge(CK) then
        reg <= D;
      end if;
    end process FF;
  else generate
    FF : process(CK)
    begin
      if rising_edge(CK) then
        reg <= '0' when SR else D;
      end if;
    end process FF;
  end generate g_ASYNC;

  Q <= reg;

end architecture rtl;
