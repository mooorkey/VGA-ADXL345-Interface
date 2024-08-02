# Overview 
This project demonstrates the design and implementation of a digital system using VHDL to interface a VGA display and an ADXL345 accelerometer. The system captures acceleration data via SPI communication and uses it to control the movement direction of an on-screen object.

# Features
- VGA Signal Generation: Implemented VHDL code to generate VGA signals for visual display
- SPI Communication: Utilized SPI protocol to acquire data from the ADXL345 accelerometer
- Real-time Object Control: Controlled the direction of an 2d on-screen object based on real-time acceleration data.
- Game-like Interface: Designed a simple interactive game where the object moves based on the accelerometer's input.

# Project Structure
- MiniProject.vhd: Main project file containing the entity and architecture definitions.
- GAME_CONTROLLER.vhd: VHDL module for processing acceleration data and controlling the on-screen object.
- VGA_CONTROLLER.vhd: VHDL module for generating VGA signals.
- pmod_accelerometer_adxl345.vhd: VHDL module for interfacing with the ADXL345 accelerometer via SPI.

# Components
### MiniProject Entity
```
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
        miso : IN STD_LOGIC;
        sclk : BUFFER STD_LOGIC;
        ss_n : BUFFER STD_LOGIC_VECTOR(0 DOWNTO 0);
        mosi : OUT STD_LOGIC;
        RESTART : IN STD_LOGIC
    );
END MiniProject;
```

### Game Controller
Handles the movement of the object based on acceleration data.
```
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY GAME_CONTROLLER IS
    PORT (
        CLK_IN : IN STD_LOGIC;
        X_coord : IN INTEGER RANGE 0 TO 800;
        Y_coord : IN INTEGER RANGE 0 TO 600;
        R_out : OUT STD_LOGIC_VECTOR(3 downto 0) := x"F";
        G_out : OUT STD_LOGIC_VECTOR(3 downto 0) := x"F";
        B_out : OUT STD_LOGIC_VECTOR(3 downto 0) := x"F";
        X_accr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Y_accr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Z_accr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        FRAME_COUNT : IN INTEGER RANGE 0 TO 59;
        RESTART : IN STD_LOGIC
    );
END GAME_CONTROLLER;
```

### VGA Controller
Generates VGA signals for the display.
```
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
```

### Accelerometer Interface
Handlees SPI communication with the ADXL345 accelerometer.
```
COMPONENT pmod_accelerometer_adxl345 IS
  GENERIC(
     clk_freq : INTEGER := 50;
     data_rate : STD_LOGIC_VECTOR := "1101";
     data_range : STD_LOGIC_VECTOR := "11"
  );
  PORT(
     clk : IN STD_LOGIC;
     reset_n : IN STD_LOGIC;
     miso : IN STD_LOGIC;
     sclk : BUFFER STD_LOGIC;
     ss_n : BUFFER STD_LOGIC_VECTOR(0 DOWNTO 0);
     mosi : OUT STD_LOGIC;
     acceleration_x : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
     acceleration_y : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
     acceleration_z : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;
```
