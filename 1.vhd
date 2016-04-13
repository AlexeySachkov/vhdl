library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity counter is
  port(
    syn:in std_logic;
    c:in std_logic;
    r:in std_logic;
    v:out std_logic_vector(0 to 9)
  );
end entity;

architecture behavior of counter is
  begin
  process(syn)
    variable value:integer range 0 to 1023;
    begin
      if syn = '1' then
        if c = '1' then
          if value = 1023 then
            value := 0;
          else
            value := value + 1;
          end if;
        elsif r = '1' then
          value := 0;
        end if;
      end if;
      v <= conv_std_logic_vector(value, 10);
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity testbench is

end entity;

architecture testbench_arch of testbench is

signal msyn:std_logic;
signal mc:std_logic;
signal mr:std_logic;
signal mv:std_logic_vector(0 to 9);

component counter
  port(
    syn:in std_logic;
    c:in std_logic;
    r:in std_logic;
    v:out std_logic_vector(0 to 9)
  );
end component;

begin
  msyn <= '0';
  mc <= '0';
  mr <= '0';
  -- mv <= conv_std_logic_vector(0, 10);
  C: counter port map (msyn, mc, mr, mv);
  process
  begin
    mc <= '0';
    msyn <= '0';
    wait for 50 ms;
    mc <= '1';
    msyn <= '1';
    wait for 100 ms;
  end process;
end architecture;