LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY VGA_CONTROLLER IS
	PORT (
		CLK : IN STD_LOGIC;
		HSYNC : OUT STD_LOGIC;
		VSYNC : OUT STD_LOGIC;
		R : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		G : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		B : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		FRAME : OUT INTEGER RANGE 0 TO 59;
		CURRENT_X : OUT INTEGER RANGE 0 TO 800;
		CURRENT_Y: OUT INTEGER RANGE 0 TO 600;
		R_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		G_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		B_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END VGA_CONTROLLER;
ARCHITECTURE MAIN OF VGA_CONTROLLER IS
	SIGNAL H_pix : INTEGER RANGE 0 TO 1056 := 0;
	SIGNAL V_pix : INTEGER RANGE 0 TO 628 := 0;
	SIGNAL FRAME_COUNTER : INTEGER RANGE 0 TO 60 := 0;

BEGIN
	PROCESS (CLK)
	BEGIN
		IF (RISING_EDGE(CLK)) THEN
			IF (H_pix < 800 and V_pix < 600) THEN
				CURRENT_X <= H_pix;
				CURRENT_Y <= V_pix;
				R <= R_in;
				G <= G_in;
				B <= B_in;
			ELSE
				R <= x"0";
				G <= x"0";
				B <= x"0";
			END IF;
				
			IF (H_pix < 1056) THEN
				H_pix <= H_pix + 1;
			ELSE
				H_pix <= 0;
				IF (V_pix < 628) THEN
					V_pix <= V_pix + 1;
				ELSE
					V_pix <= 0;
					FRAME_COUNTER <= FRAME_COUNTER + 1;
				END IF;
			END IF;

			IF (H_pix > 840 AND H_pix <= 968) THEN----HSYNC
				HSYNC <= '0';
			ELSE
				HSYNC <= '1';
			END IF;

			IF (V_pix > 601 AND V_pix <= 605) THEN----------vsync
				VSYNC <= '0';
			ELSE
				VSYNC <= '1';
			END IF;
		END IF;
	END PROCESS;

	FRAME <= FRAME_COUNTER;

END MAIN;