entity NOT_EL is
	port(A: IN BIT; B: OUT BIT);
end entity;

architecture arch of NOT_EL is
begin
	B <= not A after 5 ns;
end architecture;

entity OR_EL is
	port(A1, A2, A3, A4, A5, A6: IN BIT; B: OUT BIT);
end entity;

architecture arch of OR_EL is
begin
process(A1, A2, A3, A4, A5, A6)
begin
	B <= A1 or A2 or A3 or A4 or A5 or A6 after 5 ns;
end process;
end architecture;

entity AND_EL is
	port(A, B: IN BIT; C: OUT BIT);
end entity;

architecture arch of AND_EL is
begin
	C <= A and B after 5 ns;
end architecture;

ENTITY DC IS
	PORT ( x: IN BIT_VECTOR(0 to 3); y: OUT BIT_VECTOR(0 to 15));
END entity;
ARCHITECTURE arch OF DC IS
BEGIN
	PROCESS(x)
	BEGIN
		IF    x = "0000" THEN y <= "1000000000000000" after 5 ns;
		ELSIF x = "0001" THEN y <= "0100000000000000" after 5 ns;
		ELSIF x = "0010" THEN y <= "0010000000000000" after 5 ns;
		ELSIF x = "0011" THEN y <= "0001000000000000" after 5 ns;
		ELSIF x = "0100" THEN y <= "0000100000000000" after 5 ns;
		ELSIF x = "0101" THEN y <= "0000010000000000" after 5 ns;
		ELSIF x = "0110" THEN y <= "0000001000000000" after 5 ns;
		ELSIF x = "0111" THEN y <= "0000000100000000" after 5 ns;
		ELSIF x = "1000" THEN y <= "0000000010000000" after 5 ns;
		ELSIF x = "1001" THEN y <= "0000000001000000" after 5 ns;
		ELSIF x = "1010" THEN y <= "0000000000100000" after 5 ns;
		ELSIF x = "1011" THEN y <= "0000000000010000" after 5 ns;
		ELSIF x = "1100" THEN y <= "0000000000001000" after 5 ns;
		ELSIF x = "1101" THEN y <= "0000000000000100" after 5 ns;
		ELSIF x = "1110" THEN y <= "0000000000000010" after 5 ns;
		ELSIF x = "1111" THEN y <= "0000000000000001" after 5 ns;
		END IF;
	END PROCESS;
END architecture;


entity RS is
	port(C, R, S: IN BIT; Q, NQ: OUT BIT);
end entity;

architecture arch of RS is
begin
process(C)
begin
	if (C = '1') then
		if (R = '1') and (S = '0') then
			Q <= '0' after 5 ns;
			NQ <= '1' after 5 ns;
		elsif (R = '0') and (S = '1') then
			Q <= '1' after 5 ns;
			NQ <= '0' after 5 ns;
		end if;
	end if;
end process;
end architecture;

entity D is
	port(D, C: IN BIT; Q, NQ: OUT BIT);
end entity;

architecture arch of D is
component RS is
	port(C, R, S: IN BIT; Q, NQ: INOUT BIT);
end component;

begin
	RS1: RS port map(C, (not D), D, Q, NQ);
end architecture;

entity automaton is
	port(H, C: IN BIT; Z: IN BIT_VECTOR(0 to 3); Q: OUT BIT_VECTOR(0 to 15));
end entity;

architecture arch of automaton is
component NOT_EL is
	port(A: IN BIT; B: OUT BIT);
end component;
component OR_EL is
	port(A1, A2, A3, A4, A5, A6: IN BIT; B: OUT BIT);
end component;
component AND_EL is
	port(A, B: IN BIT; C: OUT BIT);
end component;
component D is
	port(D, C: IN BIT; Q, NQ: OUT BIT);
end component;
component DC is
	port(x: IN BIT_VECTOR(0 to 3); y: OUT BIT_VECTOR(0 to 15));
end component;

SIGNAL NZ: BIT_VECTOR(0 to 3);
SIGNAL TQ: BIT_VECTOR(0 to 15) := "1000000000000000";
SIGNAL T: BIT_VECTOR(0 to 6) := "0000000";
SIGNAL S: BIT_VECTOR(0 to 3) := "0000";
SIGNAL TS: BIT_VECTOR(0 to 3) := "0000";
SIGNAL TMP: BIT_VECTOR(0 to 3);
begin

	NZ0: NOT_EL port map(Z(0), NZ(0));
	NZ1: NOT_EL port map(Z(1), NZ(1));
	NZ2: NOT_EL port map(Z(2), NZ(2));
	NZ3: NOT_EL port map(Z(3), NZ(3));

	T0: OR_EL  port map(TQ(6), TQ(8), '0', '0', '0', '0', T(0));
	T1: AND_EL port map(NZ(2), T(0), T(1));
	T2: AND_EL port map(Z(2), T(0), T(2));
	T3: AND_EL port map(TQ(1), Z(0), T(3));
	T4: AND_EL port map(TQ(9), Z(3), T(4));
	T5: AND_EL port map(TQ(1), NZ(0), T(5));
	T6: AND_EL port map(TQ(3), NZ(1), T(6));

	S0: OR_EL port map(T(1), TQ(7), T(4), '0', '0', '0', S(0));
	S1: OR_EL port map(TQ(3), TQ(4), TQ(5), T(2), '0', '0', S(1));
	S2: OR_EL port map(T(3), TQ(2), TQ(4), TQ(5), T(2), T(4), S(2));
	S3: OR_EL port map(TQ(0), T(5), TQ(2), T(6), T(2), TQ(7), S(3));

	D0: D port map(S(0), C, TS(0), TMP(0));
	D1: D port map(S(1), C, TS(1), TMP(1));
	D2: D port map(S(2), C, TS(2), TMP(2));
	D3: D port map(S(3), C, TS(3), TMP(3));

	DC0: DC port map(TS, TQ);
	Q <= TQ;
end architecture;

entity automaton_testbench is
	port(Q: OUT BIT_VECTOR(0 to 15));
end entity;

architecture arch of automaton_testbench is
component automaton is
	port(H, C: IN BIT; Z: IN BIT_VECTOR(0 to 3); Q: OUT BIT_VECTOR(0 to 15));
end component;

SIGNAL Z: BIT_VECTOR(0 to 3) := "1001";
SIGNAL C: BIT := '0';

begin
S: automaton port map('1', C, Z, Q);

process
begin
	wait for 20 ns;
	C <= '0';
	wait for 20 ns;
	C <= '1';
end process;
end architecture;