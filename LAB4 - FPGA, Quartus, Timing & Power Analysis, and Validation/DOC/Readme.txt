LAB4 - FPGA based Digital Design




This project implements a digital system with an I/O interface on a DE10-Lite FPGA board. The system is organized around a configurable Arithmetic Logic Unit (ALU) and a Pulse Width Modulation (PWM) controller, supporting asynchronous data loading via latches and real-time visualization on 7-segment displays. 


Input and Output Description
* CLK_50MHZ – System master clock.
* KEY –4  Pushbuttons for asynchronous data loading and system reset (Active Low).
* SW – 10 Input switches for data operands, ALUFN command selection, and multiplexer control.
* LEDR – Output LEDs displaying the current ALUFN opcode and internal processor status flags.
* HEX0 to HEX5 – 7-segment displays indicating the active input bytes and ALU computation results.
* GPIO9 – Dedicated serial output pin for the generated PWM signal.


The VHD file:
LOGIC.VHD:
* Performs bitwise logic operations (AND, OR, XOR, etc.) between X and Y based on ALUFN[2:0].


SHIFTER.VHD:
* This module performs according to the ALUFN input a barrel-shifter based shift, where if ALUFN[2:0] = 000 then we will shift to the left and if ALUFN[2:0] = 001 we will shift to the right. 
We decided to implement the module by going through all k layers (where k=log_2⁡n) and for each layer we will perform a shift accordingly so that if the bit in the relevant layer in X is 0 we will not perform a shift and then the origin of the layer will be the same as the entry and otherwise we will perform a shift according to the layer.


AdderSub.VHD: 
* This module performs Math operation between the input vectors X and Y according opcode ALUFN[2:0]. It operates by using it’s sub-module FA (full-adder) to operate ADD/SUB/NEG/DOUBLE INC/DOUBLE DEC operations.
 Note that the ADDER/SUBTRACTER is performed by Y+X or Y + (Not (X)).
 DOUBLE INC/DOUBLE DEC performed on the input Y vector only by changing X vector value for ‘2’ value in decimal and then using the same adder/subtracter. 
 NEG operation is performed on the input X vector by using Y vector as zero vector and subtracting X vector.
 
FullAdder.VHD:
* This is the basic building block used by the AdderSub module. It receives X, Y and Cin bits and outputs the Sum and Cout bits.


AuxPackage.VHD:
* This file contains in the form of a package all the components that we would like to use throughout the laboratory.


top_ALU.VHD:
* This module wraps the entire system and implements a structural design hierarchy. It receives the input vectors X, Y and the control signal ALUFN to manage the data flow between sub-modules. Based on the operation code ALUFN[4:3], the Top module selects which functional unit is active: "01" for Adder/Subtractor, "10" for Shifter, or "11" for Logic. The module is responsible for multiplexing the results from the various units into a single output vector, ALUout, and generating the status flags Z, N, C, and V based on the operation's outcome.
*  To achieve lower power consumption, the design includes logic gates at the inputs of the sub-modules. These gates ensure that signals make transitions only when the specific module is selected by ALUFN[4:3], preventing unnecessary switching activity.


PWM.vhd:
* A 16-bit timer/counter-based Pulse Width Modulation (PWM) generator. It supports dynamic mode changes (MODE) , enabling pulse generation in Set/Reset, Reset/Set, and Toggle configurations. The total PWM period is determined by the Y register value , while the duty cycle is controlled by the X register value. 
pll.vhd:
*  A hardware clock management wizard-generated component based on Altera's altpll megafunction. It takes an incoming 50 MHz oscillator clock source and divides it down to generate a stable, locked 2 MHz internal system clock for the design. 








SevenSegDecoder.vhd: 
* A combinational decoder that converts a 4-bit hexadecimal nibble into the corresponding 7-segment display code. It uses active-low logic to properly drive and illuminate the hex displays on the FPGA board. 




SystemTop.vhd:
*  The system-level structural wrapper that integrates the core functional logic of the project. Depending on the selection bits of the ALU function input (ALUFN), it routes and masks input signals to drive two main subsystems in parallel: an 8-bit Arithmetic Logic Unit (top_ALU) for data processing and a 16-bit Pulse Width Modulation (PWM) generator. 


FPGA_Top.vhd:
*  The top-level entity of the design implemented on the FPGA board. It interfaces directly with the physical hardware I/O, including switches (SW) , push-buttons (KEY) , LEDs (LEDR) , and seven-segment displays (HEX0-HEX5). It manages clock distribution via the PLL and includes an asynchronous latch process to load input data into the X and Y registers based on button and switch combinations. 
insert the data to the SystemTOP (the design of the LAB).




Created by Yoav Tsur and Elad Lavi.