ENTITY counter_ie14 IS
	PORT(d : IN BIT_VECTOR(0 TO 3);
	     w, r, c1, c2: IN BIT;
	     q : INOUT BIT_VECTOR(0 TO 3)
	);
END counter_ie14;

ARCHITECTURE behavior_ie14 OF counter_ie14 IS
BEGIN
	PROCESS(w, r, c1, c2)
	BEGIN
		IF (w = '0') THEN
			q <= d;
		ELSE

			IF (r = '0') THEN
				q <= "0000";
			END IF;
		
			IF (c1 = '1') THEN
				IF (q = "1111") THEN
					q <= "0000";
				ELSE
					IF q(3) = '0' THEN q(3) <= '1';
					ELSIF q(2) = '0' THEN q(2) <= '1'; q(3) <= '0';
					ELSIF q(1) = '0' THEN q(1) <= '1'; q(2) <= '0'; q(3) <= '0';
					ELSIF q(0) = '0' THEN q(0) <= '1'; q(1) <= '0'; q(2) <= '0'; q(3) <= '0';
					END IF;
				END IF;
			END IF;
	
			IF (c2 = '1') THEN
				IF (q = "0111") THEN
					q <= "0000";
				ELSIF (q = "1111") THEN
					q <= "1000";
				ELSE
					IF q(3) = '1' THEN q(3) <= '0';
					ELSIF q(2) = '1' THEN q(2) <= '0'; q(3) <= '1';
					ELSIF q(1) = '1' THEN q(1) <= '0'; q(2) <= '1'; q(3) <= '1';
					ELSIF q(0) = '1' THEN q(0) <= '0'; q(1) <= '1'; q(2) <= '1'; q(3) <= '1';
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;
END behavior_ie14;

ENTITY full_elem IS
	PORT(q1: IN BIT_VECTOR(0 TO 3);
	     d : OUT BIT);
END full_elem;

ARCHITECTURE behavior_full_elem OF full_elem IS
BEGIN
	PROCESS (q1)
	BEGIN
		IF q1 = "1111" THEN
			d <= '1';
		ELSE  	d <= '0';
		END IF;
	END PROCESS;
END behavior_full_elem;

ENTITY and_elem IS
	PORT(q1, q2 : IN BIT_VECTOR(0 TO 3);
	     d : OUT BIT);
END and_elem;

ARCHITECTURE behavior_and_elem OF and_elem IS
BEGIN
	PROCESS (q1, q2)
	BEGIN
		IF q1 = "1001" AND q2 = "0101" THEN
			d <= '1';
		ELSE  	d <= '0';
		END IF;
	END PROCESS;
END behavior_and_elem;


ENTITY scheme IS
	PORT(syn : IN BIT;
	     v : INOUT BIT);
END scheme;

ARCHITECTURE behavior_scheme OF scheme IS
COMPONENT counter_ie14 IS
	PORT(d : IN BIT_VECTOR(0 TO 3);
	     w, r, c1, c2: IN BIT;
	     q : INOUT BIT_VECTOR(0 TO 3)
	);
END COMPONENT;
COMPONENT and_elem IS
	PORT(q1, q2 : IN BIT_VECTOR(0 TO 3);
	     d : OUT BIT);
END COMPONENT;
COMPONENT full_elem IS
	PORT(q1: IN BIT_VECTOR(0 TO 3);
	     d : OUT BIT);
END COMPONENT;

SIGNAL d : BIT_VECTOR(0 TO 3) := "0000";
SIGNAL q1_t, q2_t : BIT_VECTOR(0 TO 3);
SIGNAL r1, r2: BIT;
SIGNAL tsyn: BIT;

BEGIN
	CNT1: counter_ie14
	PORT MAP(d, '1', r1, syn, '0', q1_t);
	F1: full_elem
	PORT MAP(q1_t, tsyn);
	CNT2: counter_ie14
	PORT MAP(q1_t, '1', r2, tsyn, '0', q2_t);
	A: and_elem
	PORT MAP(q1_t, q2_t, v);

	process(v)
	begin
		if v = '1' then
			r1 <= '0' after 5 ns;
			r2 <= '0' after 5 ns;
		else
			r1 <= '1' after 5 ns;
			r2 <= '1' after 5 ns;
		end if;
	end process;
	
END behavior_scheme;

entity testbench is
	PORT(v: OUT BIT);
end entity;

architecture test of testbench is
COMPONENT scheme IS
	PORT(syn : IN BIT;
	     v : INOUT BIT);
END COMPONENT;
SIGNAL s: BIT;
begin
C: scheme
PORT MAP(s, v);
process
begin
	s <= '1';
	wait for 10 ns;
	s <= '0';
	wait for 10 ns;
end process;
end architecture;
