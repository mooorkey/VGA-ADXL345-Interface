LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY GAME_CONTROLLER IS
	PORT (
		CLK_IN  : IN STD_LOGIC;
		X_coord : IN INTEGER RANGE 0 TO 800;
		Y_coord : IN INTEGER RANGE 0 TO 600;
		R_out	  : OUT STD_LOGIC_VECTOR(3 downto 0) := x"F";
		G_out	  : OUT STD_LOGIC_VECTOR(3 downto 0) := x"F";
		B_out	  : OUT STD_LOGIC_VECTOR(3 downto 0) := x"F";
		
		X_accr  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		Y_accr  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		Z_accr  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		FRAME_COUNT : IN INTEGER RANGE 0 TO 59;
		RESTART : IN STD_LOGIC
	);
END GAME_CONTROLLER;

ARCHITECTURE BEHAVIORAL OF GAME_CONTROLLER IS
	SIGNAL X_accr_int : INTEGER;
	SIGNAL Y_accr_int : INTEGER;
	SIGNAL Z_accr_int : INTEGER;
	SIGNAL FRAME_COUNT_PREV : INTEGER RANGE 0 to 59 := 0;
	SIGNAL BALL_CENTER_X : INTEGER := 400;
	SIGNAL BALL_CENTER_Y : INTEGER := 300;
	SIGNAL BALL_RADIUS 	: INTEGER := 30;
	
	SIGNAL START_REC1_X  : INTEGER := 0;
	SIGNAL START_REC1_Y  : INTEGER := 0;
	SIGNAL REC1_X_L		: INTEGER := 50;
	SIGNAL REC1_Y_L		: INTEGER := 50;

	
	SIGNAL SQUARE_1_CHECKED : STD_LOGIC := '0';
	SIGNAL SQUARE_2_CHECKED : STD_LOGIC := '0';
	SIGNAL SQUARE_3_CHECKED : STD_LOGIC := '0';
	
	SIGNAL GAME_OVER : STD_LOGIC := '0';
	
	BEGIN
	X_accr_int <= to_integer(signed(X_accr))/10;
	Y_accr_int <= to_integer(signed(Y_accr))/10;
	
	PROCESS(CLK_IN)
		BEGIN
			IF RISING_EDGE(CLK_IN) THEN
				FRAME_COUNT_PREV <= FRAME_COUNT;
				IF FRAME_COUNT /= FRAME_COUNT_PREV THEN
					BALL_CENTER_X <= BALL_CENTER_X - X_accr_int;
					BALL_CENTER_Y <= BALL_CENTER_Y + Y_accr_int;
					
					IF BALL_CENTER_X > 800 THEN -- if ball goes out to the right
						BALL_CENTER_X <= 0;
					ELSIF BALL_CENTER_X < 0 THEN -- if ball goes out to the left
						BALL_CENTER_X <= 800;
					END IF;
					IF BALL_CENTER_Y > 600 THEN -- if ball goes out to the right
						BALL_CENTER_Y <= 0;
					ELSIF BALL_CENTER_Y < 0 THEN -- if ball goes out to the left
						BALL_CENTER_Y <= 600;
					END IF;
				END IF;
				
				IF RESTART = '0' THEN
					SQUARE_1_CHECKED <= '0';
					SQUARE_2_CHECKED <= '0';
					SQUARE_3_CHECKED <= '0';
					GAME_OVER <= '0';
				END IF;
				
				IF GAME_OVER = '0' THEN
					IF ((((X_coord - BALL_CENTER_X)**2) + ((Y_coord - BALL_CENTER_Y)**2)) < BALL_RADIUS**2) THEN -- Main Circle
						R_out <= x"F";
						G_out <= x"0";
						B_out <= x"0";
					ELSIF (X_coord >= START_REC1_X and X_coord <= REC1_X_L and Y_coord >= START_REC1_Y and Y_coord <= REC1_Y_L) THEN
						IF (SQUARE_1_CHECKED = '0') THEN
							R_out <= x"F";
							G_out <= x"0";
							B_out <= x"0";
						ELSE
							R_out <= x"F";
							G_out <= x"F";
							B_out <= x"F";
						END IF;
					ELSIF (X_coord >= 700 and X_coord <= 800 and Y_coord >= 0 and Y_coord <= 119) AND (SQUARE_2_CHECKED = '0') THEN
						IF (SQUARE_2_CHECKED = '0') THEN
							R_out <= x"0";
							G_out <= x"F";
							B_out <= x"0";
						ELSE
							R_out <= x"F";
							G_out <= x"F";
							B_out <= x"F";
						END IF;
					ELSIF (X_coord >= 520 and X_coord <= 639 and Y_coord >= 500 and Y_coord <= 600) AND (SQUARE_3_CHECKED = '0') THEN
						IF (SQUARE_3_CHECKED = '0') THEN
							R_out <= x"0";
							G_out <= x"0";
							B_out <= x"F";
						ELSE
							R_out <= x"F";
							G_out <= x"F";
							B_out <= x"F";
						END IF;
					ELSE
						R_out <= x"F";
						G_out <= x"F";
						B_out <= x"F";
					END IF;
					
					IF (((BALL_CENTER_X) > START_REC1_X AND (BALL_CENTER_X) < REC1_X_L) AND (BALL_CENTER_Y) > START_REC1_Y AND (BALL_CENTER_Y) < REC1_Y_L) THEN
						SQUARE_1_CHECKED <= '1';
					ELSIF (((BALL_CENTER_X) > 700 AND (BALL_CENTER_X) < 800) AND (BALL_CENTER_Y) > 0 AND (BALL_CENTER_Y) < 199) THEN
						SQUARE_2_CHECKED <= '1';
					ELSIF (((BALL_CENTER_X) > 520 AND (BALL_CENTER_X) < 639) AND (BALL_CENTER_Y) > 500 AND (BALL_CENTER_Y) < 600) THEN
						SQUARE_3_CHECKED <= '1';
					END IF;
					
					IF SQUARE_1_CHECKED = '1' AND SQUARE_2_CHECKED = '1'  AND SQUARE_3_CHECKED = '1' THEN
						GAME_OVER <= '1';
					END IF;
				ELSE
					IF (X_coord > 0 AND X_coord < 800 AND Y_coord > 0 AND Y_coord < 600) THEN
						R_out <= x"0";
						G_out <= x"F";
						B_out <= x"0";
					END IF;
				END IF;
--				
--				IF ((SQUARE_1_CHECKED = '1') AND (X_coord >= START_REC1_X and X_coord <= REC1_X_L and Y_coord >= START_REC1_Y and Y_coord <= REC1_Y_L))  THEN
--					R_out <= x"F";
--					G_out <= x"F";
--					B_out <= x"F";
--				END IF;
				
				
			END IF;
	END PROCESS;
END BEHAVIORAL;