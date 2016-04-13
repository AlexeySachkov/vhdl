library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity NOT_EL is
  port(
    A: in std_logic;
    R: out std_logic
  );
end entity;

architecture Behavior of NOT_EL is
begin
  process
  begin
    R <= not A;
    wait for 120 ns;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity AND_EL is
  port(
    A, B: in std_logic;
    R: out std_logic
  );
end entity;

architecture Behavior of AND_EL is
begin
  process
  begin
    R <= A and B;
    wait for 120 ns;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity NOTAND_EL is
  port(
    A, B: in std_logic;
    R: out std_logic
  );
end entity;

architecture Structure of NOTAND_EL is
component AND_EL
  port(
    A, B: in std_logic;
    R: out std_logic
  );
end component;

component NOT_EL
  port(
    A: in std_logic;
    R: out std_logic
  );
end component;

signal T: std_logic;

begin
  M1: AND_EL port map (A, B, T);
  M2: NOT_EL port map (T, R);
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity RS is
  port(
    R, S, C: in std_logic;
    Q, NQ: out std_logic
  );
end entity;

architecture Structure of RS is
component NOTAND_EL
  port(
    A, B: in std_logic;
    R: out std_logic
  );
end component;

signal SS, RR: std_logic;

begin
  M1: NOTAND_EL port map (S, C, SS);
  M2: NOTAND_EL port map (R, C, RR);
  M3: NOTAND_EL port map (SS, NQ, Q);
  M4: NOTAND_EL port map (RR, Q, NQ);

  Q <= '0';
  NQ <= '1';
end architecture;