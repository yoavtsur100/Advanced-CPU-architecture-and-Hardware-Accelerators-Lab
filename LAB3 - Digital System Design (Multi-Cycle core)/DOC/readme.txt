Multi-Cycle Processor Core in VHDL


This project implements a multi-cycle processor core in VHDL.
The processor is organized around a Control Unit and Datapath architecture, supporting arithmetic, logical, memory access, and branching instructions.


Input and Output Description:
* clk – system clock .
* rst – processor reset.
* ena – processor enable signal.
* done – indicates completion of program execution.(Output) 
* Testbench Interfaces
Additional testbench ports are included for simulation support, allowing:
* Program memory (ITCM) initialization
* Data memory (DTCM) initialization
* Memory read/write access during verification
* Testbench-controlled execution flow. 




Top.vhd 
Top-level integration module connecting the Control Unit (FSM), Datapath.
From the datapath we get the status registers of which instruction we need to perform, and the FSM will output the control data for the datapath to perform the needed task.




Control.vhd 
 FSM-based control unit its purpose is to receive the op code the system needs to perform.
The right control flags will turn on to the datapath and dictating the needed operation.




Datapath.vhd   
Main datapath implementation responsible for data movement between processor components, including register transfers, ALU execution, and memory access operations.  
Implements a shared bus architecture with tri-state buffers for controlled data transfer between modules.


ALU.vhd 
Arithmetic Logic Unit implementing arithmetic and logical operations such as add, sub, OR, AND, and XOR.  
Additionally, generates processor status flags: Negative (N), Zero (Z), and Carry (C).




Adder.vhd
This module implements a generic ripple adder.


OpcodeDecoder.vhd  
Decodes the opcode from IR[15:12] and outputs the corresponding instruction signals to the Control Unit.


RF.vhd 
Register File implementation for general-purpose registers, supporting read and write operations for processor instruction execution.


RegisterA.vhd  
Temporary operand register used in the datapath to store ALU input operands during instruction execution.


RegisterC.vhd
Temporary result register used in the datapath to store ALU output values during instruction execution. Implemented as a master-slave register for synchronized sequential operation.


IR.vhd  
Instruction Register (IR) module responsible for latching instructions fetched from program memory when IRin = '1', and providing decoded instruction fields such as opcode, offset, and immediate values for execution.


ProgamCounter.vhd
Program Counter (PC) module responsible for tracking instruction execution flow by storing the current instruction address and updating it for sequential execution or jump operations.


DFlop.vhd 
Generic D Flip-Flop module providing synchronous data storage with clock and reset control, used throughout the processor’s sequential logic.






progMem.vhd 
Program memory module responsible for storing assembly instructions and supplying the appropriate instruction to the processor according to the current Program Counter (PC) address.


dataMem.vhd  
Data memory module used for processor data storage, supporting read and write access for load and store instructions.




BidirPin.vhd 
Bidirectional interface module implementing tri-state bus connectivity for controlled data transfer between shared processor modules.


aux_package.vhd 
This file contains in the form of a package all the components that we would like to use throughout the laboratory.






Created by Yoav Tsur and Elad Lavi.