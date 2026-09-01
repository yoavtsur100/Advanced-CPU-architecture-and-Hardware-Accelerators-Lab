Final Project – RISC-V RV32IM MCU Implementation
Advanced CPU Architecture and Hardware Accelerators Lab – 361-1-4693
This project presents the design and implementation of an RV32IM-based Microcontroller Unit (MCU) on an FPGA. The system integrates an RV32IM-compatible processor core with instruction and data memories, memory-mapped GPIO peripherals, interrupt handling, a Basic Timer, and a multicycle hardware division accelerator. The implementation provided is a single-cycle RV32IM MCU.
System Input and Output Description
The FPGA top-level module connects the RV32IM-based MCU to the board I/O devices and exposes several internal signals for simulation and SignalTap validation.
FPGA Board Inputs:
* CLOCK_50 – 50 MHz FPGA board clock. Used as the source for the CPU, peripheral, and divider clock domains.
* KEY[0] – Active-low system reset pushbutton. Resets the processor and returns program execution to the initial instruction.
* KEY[3:1] – Pushbuttons used as interrupt sources through the Interrupt Controller.
* SW[7:0] – Memory-mapped input switches available to the software through PORT_SW.
* SW[9:8] – Currently unused.
FPGA Board Outputs:
* LEDR[7:0] – Memory-mapped red LED output array controlled through PORT_LEDR.
* LEDR[9:8] – Unused and driven low.
* HEX0 – HEX5 – Six active-low 7-segment displays controlled through the memory-mapped GPIO interface.
GPIO Header:
* GPIO[0] – CAPIN1 input for the Basic Timer input-capture functionality.
* GPIO[1] – CAPIN2 input for the Basic Timer input-capture functionality.
* GPIO[9] – Basic Timer PWM output, available for external measurement.
Verification Outputs:
The following signals are exposed for ModelSim verification and FPGA validation using SignalTap:
* pc_o – Current Program Counter value.
* instruction_o – Current fetched instruction.
* RegWrite_ctrl_o – Register-file write-enable control signal.
* MemWrite_ctrl_o – Data-memory write-enable control signal.
* Branch_ctrl_o – Branch control signal.
* read_data1_o, read_data2_o – Register-file source operand values.
* write_data_o – Value written back to the register file.
* alu_res_o – ALU result.
* brTaken_o – Indicates that a branch condition is satisfied.
* dtcm_addr_o – Current DTCM address.
* dtcm_data_wr_o – Data written to the DTCM.
* dtcm_data_rd_o – Data read from the DTCM.
* mclk_cnt_o – 16-bit CPU clock-cycle counter used for execution and IPC analysis.
The design is verified using the provided benchmark applications, with the RARS execution results serving as the golden reference for comparison with ModelSim and FPGA validation results.


 Project Directory Structure:
The project is organized into the following main directories:
- DUT – contains the VHDL design source files.
- TB – contains the VHDL testbench files.
- SIM – contains the ModelSim simulation scripts.
- Quartus – contains the files required for FPGA compilation and validation.
- DOC – contains the project documentation.


















1. DUT
This subdirectory contains all VHDL design files required for the single-cycle RV32IM MCU implementation, including the processor core, instruction and data memories, GPIO interfaces, interrupt-related modules, Basic Timer, division accelerator, clocking logic, and additional supporting components. Only design source files are included in this directory.
VHDL Source Files:
cond_compilation_package.vhd
Defines global configuration constants used throughout the project, including the ModelSim/Quartus mode, memory addressing granularity, memory size, address widths, and clock configuration parameters. 


const_package.vhd
Defines instruction-level constants, including RISC-V opcode values, ALU operation codes, instruction masks, and other constants used for instruction decoding and execution. 




aux_package.vhd
Declares the component interfaces used throughout the project, enabling structural instantiation and connection of the MCU modules. 
BasicTimer.vhd
Implements the memory-mapped Basic Timer peripheral, including timer counting, clock prescaling, compare and capture modes, PWM generation, and timer interrupt generation. 
BidirPin.vhd
Implements a generic tri-state bidirectional buffer used for communication over the shared DataBUS. It drives the bus when enabled and otherwise places the output in a high-impedance state. 
GPIO_peripherals.vhd
Implements the memory-mapped GPIO interface, including address decoding and access to the switches, LEDs, and six 7-segment displays through the shared DataBUS.
InterruptController.vhd
Implements the memory-mapped Interrupt Controller. It detects interrupt requests from KEY1–KEY3 and the Basic Timer, manages the interrupt enable and flag registers, performs priority selection, and interfaces with the CPU through the INTR/INTA handshake.
PLL.vhd
Implements the FPGA PLL used to generate the required system clock signals from the board input clock.
SevenSegDecoder.vhd
Converts a 4-bit hexadecimal value (0–F) into the corresponding active-low 7-segment display pattern.
CONTROL.vhd
Implements the CPU control unit. It decodes RV32IM instructions and generates the control signals for the datapath, memory accesses, multiplication/division operations, CPU stalls, and interrupt handling.
multiplier_16bit.vhd
Implements a 16×16-bit combinational multiplier using four 8×8 partial products and combines them to generate a 32-bit multiplication result.
Divider_32bit.vhd
Implements the 32-bit multicycle binary division accelerator. It performs iterative division over multiple DIVCLK cycles and produces the quotient, residue, and DIVBUSY status signal.
Sync.vhd
Implements a two-stage synchronizer for transferring the divider operands into the DIVCLK clock domain and reducing clock-domain crossing issues.
IFETCH.vhd
Implements the instruction-fetch stage, including the Program Counter, ITCM instruction memory, next-PC selection for branches and jumps, PC stalling, and interrupt return-address handling.
IDECODE.vhd
Implements the instruction decode stage and 32-register RISC-V register file. It extracts instruction fields, generates immediate values, controls register write-back, and supports the interrupt-related GIE and return-address handling.
EXECUTE.vhd
Implements the execution stage of the processor, including the ALU, branch decision logic, branch address generation, shifting and comparison operations, and integration of the multiplication and division units.
DMEMORY.vhd
Implements the Data Tightly-Coupled Memory (DTCM) using an FPGA embedded memory block for storing and accessing the application's data.
RV32IMscMCU.vhd
Structural top-level module of the single-cycle RV32IM MCU core. It integrates the instruction fetch, decode, control, execute, data memory, shared bus, and interrupt-support logic.
FPGA_Top_SingleCycle.vhd
Top-level FPGA module for the single-cycle MCU implementation. It connects the MCU core to the board clocks, switches, pushbuttons, LEDs, 7-segment displays, GPIO pins, Basic Timer, and Interrupt Controller.




2. TB
The TB directory contains the VHDL testbench used for functional verification of the RV32IM-based MCU in ModelSim.
tb_RV32IMscMCU.vhd
Testbench for the single-cycle RV32IM MCU. It instantiates the DUT and provides the required simulation environment for verifying the processor and MCU behavior using the benchmark applications.
3. SIM
The SIM directory contains the ModelSim simulation script used to compile, load, and run the RV32IM-based MCU simulation.
RV32IMscMCU.do file
Contains the ModelSim commands required to compile the VHDL source files, start the tb_RV32IMscMCU simulation, configure the waveform display, and run the simulation for functional verification of the single-cycle MCU.
4. DOC
The DOC directory contains the project documentation files.
Readme.txt
Provides a description of the project directory structure, including the purpose and contents of each folder and subfolder, for convenient project navigation.
Final_report.pdf
Contains the complete final project report, including the system architecture, RTL results, PPA analysis, HDL source-file descriptions, simulation and validation waveforms, and project conclusions.
5. Quartus
The Quartus directory contains the files required for FPGA implementation, timing constraints, programming, and on-board validation of the RV32IM-based MCU.
Quartus/RV32IMscMCU
SignalTap .stp file
Contains the SignalTap Logic Analyzer configuration used for on-board validation and internal signal monitoring of the single-cycle MCU.
Timing .sdc file
Defines the timing constraints used by Quartus for static timing analysis and FMAX evaluation.
Programming .sof file
Contains the compiled FPGA programming image used to configure the FPGA with the single-cycle RV32IM MCU design.


Developed by:
- Yoav Tsur
- Elad Lavi