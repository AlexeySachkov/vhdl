entity JK is
  port(
    J, K, C: in BIT;
    Q, NQ: out BIT
  );
end entity;

architecture behaviour of JK is
signal T: BIT;
begin
T <= '0';
process(C)
begin
  if (C = '1') then
    Q <= ((not T) and J) or (T and (not K));
    NQ <= not Q;
  end if;
end process;
end architecture;

entity CMP is
  port(
    C: in BIT;
    A, B: in BIT_VECTOR(0 to 7);
    O: out BIT
  );
end entity;

architecture behaviour of CMP is
signal T: BIT;
begin
-- T <= '0';
process(C)
begin
  if (A = B) then
    O <= '1';
  else
    O <= '0';
  end if;
end process;
end architecture; 

entity Scheme is
  port(
    C, I: in BIT;
    S: in BIT_VECTOR(0 to 7);
    O: out BIT
  );
end entity;

architecture behaviour of Scheme is
component JK is
  port(
    J, K, C: in BIT;
    Q, NQ: out BIT
  );
end component;

component CMP is
  port(
    C: in BIT;
    A, B: in BIT_VECTOR(0 to 7);
    O: out BIT
  );
end component;
signal buf: BIT_VECTOR(0 to 7);

begin
  JK1: JK port map(I, not I, C, buf(0));
  JK2: JK port map(buf(0), not buf(0), C, buf(1));
  JK3: JK port map(buf(1), not buf(1), C, buf(2));
  JK4: JK port map(buf(2), not buf(2), C, buf(3));
  JK5: JK port map(buf(3), not buf(3), C, buf(4));
  JK6: JK port map(buf(4), not buf(4), C, buf(5));
  JK7: JK port map(buf(5), not buf(5), C, buf(6));
  JK8: JK port map(buf(6), not buf(6), C, buf(7));

  RES: CMP port map(C, buf, S, O);
end architecture;

entity testbench1 is
  port(
    O: out BIT
  );
end entity;

architecture behaviour of testbench1 is
component Scheme is
  port(
    C, I: in BIT;
    S: in BIT_VECTOR(0 to 7);
    O: out BIT
  );
end component;

signal CHAR: BIT_VECTOR(0 to 7);
signal C, I: BIT;
begin

CHAR <= "01000111";

SCH: Scheme port map(C, I, CHAR, O);

process
begin
   C <= '0';
wait for 10 ns;
   I <= '1';
   C <= '1';
   wait for 10 ns;

   C <= '0';
wait for 10 ns;
   I <= '1';
   C <= '1';
   wait for 10 ns;

   C <= '0';
wait for 10 ns;
   I <= '1';
   C <= '1';
   wait for 10 ns;

   C <= '0';
wait for 10 ns;
   I <= '0';
   C <= '1';
   wait for 10 ns;

   C <= '0';
wait for 10 ns;
   I <= '0';
   C <= '1';
   wait for 10 ns;

   C <= '0';
wait for 10 ns;
   I <= '0';
   C <= '1';
   wait for 10 ns;

   C <= '0';
wait for 10 ns;
   I <= '1';
   C <= '1';
   wait for 10 ns;

   C <= '0';
wait for 10 ns;
   I <= '0';
   C <= '1';
   wait for 10 ns;
end process;
end architecture;