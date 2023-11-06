LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY MiniProject IS
	PORT (
		CLOCK_50 : IN STD_LOGIC;
		VGA_HSYNC, VGA_VSYNC : OUT STD_LOGIC;
		VGA_RED, VGA_BLUE, VGA_GREEN : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		RESET : IN STD_LOGIC;
		miso : IN      STD_LOGIC;                      --SPI bus: master in, slave out
		sclk : BUFFER  STD_LOGIC;                      --SPI bus: serial clock
		ss_n : BUFFER  STD_LOGIC_VECTOR(0 DOWNTO 0);   --SPI bus: slave select
		mosi : OUT     STD_LOGIC;                      --SPI bus: master out, slave in
		RESTART : IN STD_LOGIC
	);
END MiniProject;

ARCHITECTURE Structural OF MiniProject IS
	SIGNAL CLOCK_40 : std_logic;
	SIGNAL FRAME_COUNTER : INTEGER RANGE 0 TO 59 := 0;
	SIGNAL X : INTEGER RANGE 0 TO 800;
	SIGNAL Y : INTEGER RANGE 0 TO 600;
	SIGNAL R : STD_LOGIC_VECTOR(3 DOWNTO 0) := x"F";
	SIGNAL G : STD_LOGIC_VECTOR(3 DOWNTO 0) := x"F";
	SIGNAL B : STD_LOGIC_VECTOR(3 DOWNTO 0) := x"F";
	
	SIGNAL X_accerelation : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL Y_accerelation : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL Z_accerelation : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	COMPONENT VGA_CONTROLLER IS
		PORT(
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
			B_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0));
	END COMPONENT;
		
	COMPONENT CLK_IN IS
		PORT (
			inclk0 : IN STD_LOGIC := 'X';
			c0 : OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT GAME_CONTROLLER IS
		PORT(
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
	END COMPONENT;
	
	COMPONENT pmod_accelerometer_adxl345 IS
	  GENERIC(
		 clk_freq   : INTEGER := 50;              --system clock frequency in MHz
		 data_rate  : STD_LOGIC_VECTOR := "1101"; --data rate code to configure the accelerometer
		 data_range : STD_LOGIC_VECTOR := "11");  --data range code to configure the accelerometer
	  PORT(
		 clk            : IN      STD_LOGIC;                      --system clock
		 reset_n        : IN      STD_LOGIC;                      --active low asynchronous reset
		 miso           : IN      STD_LOGIC;                      --SPI bus: master in, slave out
		 sclk           : BUFFER  STD_LOGIC;                      --SPI bus: serial clock
		 ss_n           : BUFFER  STD_LOGIC_VECTOR(0 DOWNTO 0);   --SPI bus: slave select
		 mosi           : OUT     STD_LOGIC;                      --SPI bus: master out, slave in
		 acceleration_x : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);  --x-axis acceleration data
		 acceleration_y : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);  --y-axis acceleration data
		 acceleration_z : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0)); --z-axis acceleration data
	END COMPONENT;

	BEGIN
		U0 : CLK_IN PORT MAP(CLOCK_50, CLOCK_40);
		U1 : VGA_CONTROLLER PORT MAP(CLOCK_40, VGA_HSYNC, VGA_VSYNC, VGA_RED, VGA_GREEN, VGA_BLUE, FRAME_COUNTER, X, Y, R, G, B);
		U2 : GAME_CONTROLLER PORT MAP(CLOCK_40, X, Y, R, G, B, X_accerelation, Y_accerelation, Z_accerelation, FRAME_COUNTER, RESTART);
		U3 : pmod_accelerometer_adxl345 GENERIC MAP(50, "1101", "11") PORT MAP(CLOCK_50, RESET, miso, sclk, ss_n, mosi, X_accerelation, Y_accerelation, Z_accerelation);
END Structural;